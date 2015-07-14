# audio2ascii (Only Linux and Mac Osx)
  Natron2.0 python plugin to animate you parameters with waveform from an audio file(mp3, wav,aiff,...).
  
  It try to preview audio while viewer playing. it can be usefull until [the basic sound support](https://github.com/MrKepzie/Natron/issues/76#issuecomment-120059396) in future Natron versions (>2.0).
  
  An external app can be set and launch from the plugin to edit audio file (e.g. audacity..)
  
  The plugin use a bash script(audio2ascii.sh), sox to convert audio and ffplay(from ffpmeg) to play the preview, you must have them in your environment PATH.
  
  OSX users will need to set PATH for terminal (~/.profile, ~/.bash_profile, or ~/.bashrc) and windowed apps (depend of your Mac version).
  
  [Here is a Demo/tuto](https://www.youtube.com/watch?v=koagSOPnsVw)

 ![frame](https://cloud.githubusercontent.com/assets/10021906/8639016/ce766e70-28cc-11e5-9c19-486f64b71992.png)


 ![screenshot-2](https://cloud.githubusercontent.com/assets/10021906/8639230/a3a4e7f6-28d3-11e5-96e1-3e0490e6b9fe.png)


 For Windows users, a multiplatform Qt version of the bash script are currently being developed by [olear](https://github.com/olear/audiocurve)

#Requirements

 * [sox](http://sox.sourceforge.net/):

    - <u>Debian/Ubuntu:</u> **sudo apt-get install sox** or  **sudo yum install sox**. For support more audio formats than 'wav': **sudo apt-get install libsox-fmt-all** (debian).

    - <u>Fedora:</u> for mp3 support for sox you can read [this](https://unix.stackexchange.com/questions/98524/sox-returns-an-error-when-i-try-to-handle-mp3-files)

    - <u>Mac OSX:</u> **sudo port install sox** (After have installed [Xcode](https://developer.apple.com/download) and [Command Line Tools](https://developer.apple.com/download))

 * [ffmpeg](http://www.ffmpeg.org/):

    - <u>Debian/Ubuntu:</u> **sudo apt-get install ffmpeg** or **sudo yum install ffmpeg**

    - <u>Mac OSX:</u> **sudo port install ffmpeg**

 * <u>[gawk](http://www.gnu.org/software/gawk)</u> (Mac OSX users only, awk doesn't support floats):

     - **sudo port install gawk**</u>
     

 * [yad](http://sourceforge.net/projects/yad-dialog) (optional, stand alone GUI on Linux):

    - <u>Debian/Ubuntu:</u> **sudo apt-get install yad**

    - <u>Fedora:</u>**sudo yum install yad**

#Installation / Usage

```
$ wget https://github.com/rcspam/audio2ascii/archive/v1.9.tar.gz
$ tar xvzf audio2ascii-1.9.tar.gz
$ cd audio2ascii-1.9
$ cp ./audio2ascii.sh /somewhere/in/your/path  # must be in your $PATH
```
If you want start audio2ascii from Natron, you should run it with its gui (yad must be installed). To install the plugin AudioToAscii.py and its icon:
```
$ # create the local Plugins directory if it doesn't exist
$ mkdir $HOME/.local/share/INRIA/Natron/Plugins
$ cp ./AudioToAscii.*  $HOME/.local/share/INRIA/Natron/Plugins
```
If you want just add a menu command to the application’s menu-bar, add the following lines in your $HOME/.local/share/INRIA/Natron/Plugins/init.py (create init.py if doesn't exist):

```
import os
def audioToAscii():
    os.system("audio2ascii.sh -g &")
NatronGui.natron.addMenuCommand("Ext-Tools/AudioToAscii","audioToAscii",QtCore.Qt.Key.Key_L,QtCore.Qt.KeyboardModifier.ShiftModifier)
```

#Examples

Some short videos released with the [Natron 2 Snapshot](http://sourceforge.net/projects/natron/files/snapshots/) Transform Node:

* [Test1.mp4](https://dl.dropboxusercontent.com/u/2677320/test1.mp4) ( x curve on scale)
* [Test2.mp4](https://dl.dropboxusercontent.com/u/2677320/test2.mp4) ( xy curves (stereo) with x translate on left channel,  y translate on right channel )
* [Test3.mp4](https://dl.dropboxusercontent.com/u/2677320/test3.mp4) (y curve on y translate)
