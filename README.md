# audio2ascii
  Natron2.0 python plugin for Linux and MacOSX to animate you parameters with waveform from an audio file(mp3, wav,aiff,...).
  It can do a basic preview audio while viewer playing, this can be usefull [until a sound support](https://github.com/MrKepzie/Natron/issues/76#issuecomment-120059396) in future Natron versions (>2.0).

  An external app can be set and launch from the plugin to edit audio file (e.g. audacity..)

  The plugin use a bash script(audio2ascii.sh), sox to convert audio and ffplay(from ffpmeg) to play the preview.


  [Here is a Demo/tuto](https://www.youtube.com/watch?v=koagSOPnsVw).
  
  Other videos in the [examples section](https://github.com/rcspam/audio2ascii/blob/master/README.md#examples) below.

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

Just copy audio2ascii.sh, AudioToAscii.py and AudioToAscii.png in your Home Natron Plugins directory.

For Linux
```
$ wget https://github.com/rcspam/audio2ascii/archive/v2.0beta.tar.gz
$ tar xvzf audio2ascii-2.0beta.tar.gz
$ cd audio2ascii-2.0beta
$ cp audio2ascii.sh AudioToAscii.png AudioToAscii.py  $HOME/.local/share/INRIA/Natron/Plugins
```

For OSX
Download [last version](https://github.com/rcspam/audio2ascii/archive/v2.0beta.tar.gz)
Copy audio2ascii.sh AudioToAscii.png AudioToAscii.py in  /Users/your_name/Library/Application\ Support/INRIA/Natron/Plugins


Some extras (Optional)

 * If you want add a menu command to the Natron menu-bar, add the following lines in the init.py of your home Natron plugin directory (create it if doesn't exist):
```
# Linux
import os
def audioToAscii():
    os.system("$HOME/.local/share/INRIA/Natron/Plugins/audio2ascii.sh -g &")
NatronGui.natron.addMenuCommand("Ext-Tools/AudioToAscii","audioToAscii",QtCore.Qt.Key.Key_L,QtCore.Qt.KeyboardModifier.ShiftModifier)
```
```
# OSX
import os
def audioToAscii():
    os.system("$HOME/Library/Application\ Support/INRIA/Natron/Plugins/audio2ascii.sh -g &")
NatronGui.natron.addMenuCommand("Ext-Tools/AudioToAscii","audioToAscii",QtCore.Qt.Key.Key_L,QtCore.Qt.KeyboardModifier.ShiftModifier)
```

 * Linux users can run audio2ascii.sh as standalone to create ascii curves (yad must be installed)

```
$ your/path/to/audio2ascii.sh -g
```

#Examples

Some short videos released with the [Natron 2 Snapshot](http://sourceforge.net/projects/natron/files/snapshots/) Transform Node:

* [Test1.mp4](https://dl.dropboxusercontent.com/u/2677320/test1.mp4) ( x curve on scale)
* [Test2.mp4](https://dl.dropboxusercontent.com/u/2677320/test2.mp4) ( xy curves (stereo) with x translate on left channel,  y translate on right channel )
* [Test3.mp4](https://dl.dropboxusercontent.com/u/2677320/test3.mp4) (y curve on y translate)
