#!/bin/bash
#
# Convert audio files to ascii file importable in Natron/Nuke
#
# audio2ascii 'audioFile' 'asciiFile dim NatronProjectFps length [CurveHeightInX] [CurveLenghtInY]
# sox must be installed (for mp3 format as input see the Readme.md)
# yad must be installed for the GUI

function usage() {
	ud=$(basename "$0")
	echo "Usage: $ud [-g] audioFile file.ascii [x|y|xy] NatronProjectFps length [CurveHeightInX] [CurveLenghtInY]"
	echo "-g : start with GUI"
	echo "x|y|xy: In which dimension calculate the curve (e.g.: Audio files in stereo can be calculate in xy)"
	echo "Convert audio file (all supported by 'sox') in an ascii file support by Natron/Nuke"
	echo "'sox' must be installed"
	echo "Only for GUI:'yad' must be installed"
	exit
}

function error() {
	echo -e "\n$(cat ${error_log})"
	[[ $gui ]] && yad --center --on-top --geometry="400x120" --image="error" --text="\n\t<b>Sox Error:</b>\n\n\n\t$(cat ${error_log})" 2> /dev/null &
	sleep 1 # let time yad to read ${error_log}
	rm "${data}" "${error_log}"
	exit $1
}

function awkmax() {
	echo $line | grep -v ";" | sed 's/ [[:blank:]]//g;s/[[:space:]]/ /g' |\
		awk -v maxdx="$maxdx" -v maxdy="$maxdy"\
		'\
		{if ($2 < 0) $2 = -$2}\
		{if (($2) > maxdx) maxdx = ($2)}\
		{if ($3 < 0) $3 = -$3}\
		{if (($3) > maxdy) maxdy = ($3)}\
		{printf "%.10f %.10f", maxdx, maxdy}\
		'
}

function awkx() {
	echo $line | grep -v ";" | sed 's/ [[:blank:]]//g;s/[[:space:]]/ /g' |\
		awk -v factx="$factx" -v maxx="$maxx" -v maxdx="$maxdx"\
			'\
			{printf "%.10f\n", ($2*factx/maxdx)}\
			{if ($2 < 0) $2 = -$2}\
			{if (($2*factx/maxdx) > maxx) maxx = ($2*factx/maxdx)}\
			{printf "%.2f %.10f", maxx, maxdx}\
			'
}

function awkxy() {
	echo $line | grep -v ";" | sed 's/ [[:blank:]]//g;s/[[:space:]]/ /g' |\
		awk -v factx="$factx" -v facty="$facty" -v maxx="$maxx" -v maxy="$maxy" -v maxdx="$maxdx"  -v maxdy="$maxdy"\
			'\
			{printf "%.10f %.10f\n", ($2*factx/maxdx), ($3*facty/maxdy)}\
			{if ($2 < 0) $2 = -$2}\
			{if ($3 < 0) $3 = -$3}\
			{if (($2*factx/maxdx) > maxx) maxx = ($2*factx/maxdx)}\
			{if (($3*facty/maxdy) > maxy) maxy = ($3*facty/maxdy)}\
			{printf "%.2f %.10f %.2f %.10f", maxx, maxdx, maxy, maxdy}\
			'
}

data="/tmp/data_$$_tmp.dat"
error_log="/tmp/error_log_sox_$$"
dim_def="^x!y!xy" # Default: x dimension 
maxx=0
maxy=0
maxdx=0
maxdy=0

if ! which sox >/dev/null;then
	echo "$0 require 'sox' which is not installed"
	exit 1  
fi

if [ "$1" == "-g" ]; then
	gui=1
	shift
	if ! which yad >/dev/null;then
		echo "$0 require 'yad' which is not installed"
		exit 1
	fi
else
	gui=""
fi

[[ "$1" == "-h" || "$1" == "--help" ]] && usage

#GUI
if [ $gui ];then
	YAD_TMP=$(mktemp --tmpdir yad.XXXXXXXX)
	yad	--center --on-top --title="Convert Audio to ascii"\
		--form	--field="<b>Audio file </b> to convert \::FL"\
				--field="<b>Ascii file </b> to create \::SFL"\
				--field="<b>Dimensions </b> (on 1 axe\: x or on 2 axes\:xy)\:CB"\
				--field="<b>Frames/sec </b> (of the Natron project)\:"\
				--field="<b>Duration</b> (of the curve in secondes)\:"\
				--field="<b>Curve height in x</b> (default is 100):"\
				--field="<b>Curve lenght in y</b> (default is 100):"\
				"${1}"\
				"${2:-"${HOME}/Desktop/curve.ascii"}"\
				"${3:-"${dim_def}"}"\
				"${4:-24}"\
				"${5:-10}"\
				"${6:-100}"\
				"${7:-100}" > "${YAD_TMP}" 2>/dev/null 
	[[ $? = 252 || $? = 1 ]] && rm "${YAD_TMP}" && exit 1
	
	in="$(cut -d'|' -f1 < "${YAD_TMP}")"
	out="$(cut -d'|' -f2 < "${YAD_TMP}")"
	dim="$(cut -d'|' -f3 < "${YAD_TMP}")"
	fps="$(cut -d'|' -f4 < "${YAD_TMP}")"
	len="$(cut -d'|' -f5 < "${YAD_TMP}")"
	factx="$(cut -d'|' -f6 < "${YAD_TMP}")"
	facty="$(cut -d'|' -f7 < "${YAD_TMP}")"
	
	rm "${YAD_TMP}"
else
	[[ -z $3 ]] && usage

	in="${1}"
	out="${2}"
	dim="${3}"
	fps="${4}"
	len="${5}"
	factx="${6:-100}"
	facty="${7:-100}"
fi

# convert audio to .dat 
srate=$(sox --i "${in}" 2>${error_log} | grep "^Sample Rate" | awk '{print $4}')
echo CMD: sox "${in}" -r ${fps} "${data}" trim 0 ${len}
echo -n "Converting $in to Data file with SampleRate $fps (original: $srate)..."
sox "${in}" -r ${fps} "${data}" trim 0 ${len} 2>${error_log} || error 1
echo "Done"

# Search the dry maximum variation in x and in y
# we parse $data a first time (awkmax) to pass $madx and $mady as variables
# to the second parse (awkx or awkxy). 
echo -n "Search the maximum variation ..."
while read line
do
	read maxdx maxdy <<< $(awkmax)
done < "${data}"
echo "maxdx=$maxdx maxdy=$maxdy Done"
[[ $maxdx == 0 ]] && echo Plat curve: Max variation is 0 && exit

# convert .dat to ascii

echo -n "Converting Data file to $out..."
nr=0 # line count
while read line
do
	if [ "$dim" == "x" ];then
		# x
		read dimx maxx maxdx_tmp maxdy_tmp <<< $(awkx) 
		[[ -n $dimx ]] && nr=$((nr+1)) && echo "$dimx" # $dimx test to avoid empty lines
		
		# gui info
		dim_def="^x!y!xy"
		print_dim="\t\t\tX:<b> $maxx</b> ($maxdx_tmp)"
	elif [ "$dim" == "y" ];then
		# y
		read dimx dimy maxx maxdx_tmp maxy maxdy_tmp <<< $(awkxy)
		[[ -n $dimx ]] && nr=$((nr+1)) && echo "$dimy" # $dimx test to avoid empty lines
		
		# gui info
		dim_def="x!^y!xy"
		print_dim="\t\t\tY:<b> $maxy</b> ($maxdy_tmp)"
	else
		# xy
		read dimx dimy maxx maxdx_tmp maxy maxdy_tmp <<< $(awkxy)
		[[ -n $dimx ]] && nr=$((nr+1)) && echo "${dimx}_${dimy}" # $dimx test to avoid empty lines
		
		# gui info
		dim_def="x!y!^xy"
		print_dim="\t\t\tX:<b> $maxx</b> ($maxdx_tmp)\n\t\t\tY:<b> $maxy</b> ($maxdy_tmp)"
	fi
done < "${data}" > "${out}"
echo "Done"

# Result
# result non GUI
print_x="X: ${maxx}(${maxdx_tmp})"
[[ "$dim" == "y" ]] && print_x="X: 0()"
print_y="\t\t      Y: ${maxy}(${maxdy_tmp})"
echo -e "The maximum varation: ${print_x}\n${print_y}" 
echo -e "\t\t      $nr keys in $(($nr/$fps)) seconds  ($fps frames/s)"
#GUI
[[ $gui ]] && { 
				print_head="\n\t\t\t\t<b><u>Maximum variations:</u></b>\n"
				print_nbkey="\t\t\t<b>$nr</b> keys in <b>$(($nr/$fps))</b> seconds  ($fps frames/s)"
				print_extra="\t<span color='grey'><small>\t\tInside brakets: maximum before scaling</small></span>\n"
				print_out="Result in <b>${out}</b>:"
				print_info="${print_head}\n${print_dim}\n${print_nbkey}\n${print_extra}\n${print_out}"
				
				yad --center --on-top --geometry="400x600" --image="info" --text-info\
					--text="${print_info}"\
					--tail  --listen \
					--button="Change parameter(s):2"\
					--button="Ok:0" 2> /dev/null < "${out}"
					
				ret=$?
				[[ $ret == 2 ]] && "${0}" -g "${in}" "${out}" "${dim_def}" "${fps}" "${len}" "${factx}" "${facty}"
			 }
			 
rm "${data}"  "${error_log}"
