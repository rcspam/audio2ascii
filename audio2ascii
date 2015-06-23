#!/bin/bash

# audio2ascii audio_file ascii_file dim Natron_project_fps length [multiplication_factor]
# sox must installed

if [ -z $3 ] ;then
	echo "Usage: $0 audio_file file.ascii dim Natron_project_fps lenght [multiplication_factor]"
	echo "Convert audio file (all supported by 'sox') in an ascii file support by Natron"
	echo "'sox' must be installed"
	exit 1
fi

in="${1}"
out="${2}"
dim="${3}"
fps="${4}"
len="${5}"
# multip. factor Default: 1000
fact="${6:-1000}"
data="${PWD}/data_$$_tmp.dat"

# convert audio to .dat 
srate=$(sox --i "${in}" | grep "^Sample Rate" | awk '{print $4}')
echo -n "Converting $in to Data file with SampleRate $fps (original: $srate)..."
echo sox "${in}" -r ${fps} "${data}" trim 0 ${len} 
sox "${in}" -r ${fps} "${data}" trim 0 ${len} || exit 1
echo "Done"

# convert .dat to ascii
echo -n "Converting Data file to $out..."
if [ $dim -le 2 ];then
	while read line
	do
		if [ $dim == 1 ];then
			# x
			echo $line | grep -v ";" | sed 's/ [[:blank:]]//g;s/[[:space:]]/ /g' | awk -v fact="$fact" '{printf "%.10f\n", $2*fact}'
		else
			# xy
			echo $line | grep -v ";" | sed 's/ [[:blank:]]//g;s/[[:space:]]/ /g' | awk -v fact="$fact" '{printf "%.10f_%.10f\n", $2*fact, $3*fact}'

		fi
	done < "${data}" > "${out}"
else
	echo "  Error dim =$dim :  must 1 or 2"
	rm ${data}
	exit 1
fi
echo "Done"
rm ${data}
