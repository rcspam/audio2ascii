# audio2ascii
   ![frame](https://cloud.githubusercontent.com/assets/10021906/8899999/50eb0540-343b-11e5-9d9b-63ceb5a540b6.png)

 ![screenshot-2](https://cloud.githubusercontent.com/assets/10021906/8778111/35a9be00-2efc-11e5-828a-4fed9d3d266d.png)

 Natron2.0 python plugin to animate you parameters with waveform from an audio file(mp3, wav,aiff,...).
  It can do a basic preview audio while viewer playing (only OSX and Linux for now), this can be usefull [until a sound support](https://github.com/MrKepzie/Natron/issues/76#issuecomment-120059396) in future Natron versions (>2.0).

  An external app can be set and launch directly from the plugin to edit audio files (e.g. audacity..)

  The plugin use [AudioCurve](https://github.com/olear/audiocurve) written by [@olear](https://github.com/olear)  on Linux and Windows, and a bash script(audio2ascii.sh) on MacOSX.

  [sox](http://sox.sourceforge.net/) is use to convert audio.
  
  ffplay(from [ffmpeg](http://www.ffmpeg.org/)) to play the preview.

  [Here is a Demo/tuto](https://www.youtube.com/watch?v=koagSOPnsVw).

  Other videos in the [examples section](https://github.com/rcspam/audio2ascii/blob/master/README.md#examples) below.

#Installation

* Linux
```
$ wget https://github.com/rcspam/audio2ascii/releases/download/v2.0.1/v2.1-linux64.tar.gz
$ tar xvzf audio2ascii-2.0.tar.gz
$ cd audio2ascii-2.0beta
$ ./install_Unix.sh
```

* MacOSX

   Download [last version](https://github.com/rcspam/audio2ascii/releases/download/v2.0.1/v2.1-macosx.tar.gz).
Decompress it where you want and launch **'install_Unix.sh'** from the decompress directory in a terminal,
or open archive and copy all files in **'/Users/\<username\>/Library/Application Support/INRIA/Natron/Plugins'**.

* Windows

   Download [last version](https://github.com/rcspam/audio2ascii/releases/download/v2.0.1/v2.1-win.zip).
   Open archive and copy all files in **'C:\Users\\\<username\>\\Local Settings\Application Data\INRIA\Natron\Plugins'**

<u>Install some extras (Optional)</u>

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
* [Tuto/Demo](https://www.youtube.com/watch?v=koagSOPnsVw) (animate a rotopaint point on music)

 
#Requirements

 * [sox](http://sox.sourceforge.net/):

    - <u>Debian/Ubuntu:</u> **sudo apt-get install sox** or  **sudo yum install sox**. For support more audio formats than 'wav': **sudo apt-get install libsox-fmt-all** (debian).

    - <u>Fedora:</u> for mp3 support for sox you can read [this](https://unix.stackexchange.com/questions/98524/sox-returns-an-error-when-i-try-to-handle-mp3-files)

    - <u>Mac OSX:</u> **sudo port install lame**(mp3 support) and **sudo port install sox** (After have installed [Xcode](https://developer.apple.com/download) and [Command Line Tools](https://developer.apple.com/download))

    - <u>Windows</u>: Sox is include, so no need to install it but the official SoX Windows binaries can't play 'mp3' due to license restrictions.

 * [ffmpeg](http://www.ffmpeg.org/):

    - <u>Debian/Ubuntu:</u> **sudo apt-get install ffmpeg** or **sudo yum install ffmpeg**

    - <u>Mac OSX:</u> **sudo port install ffmpeg**

 * <u>[gawk](http://www.gnu.org/software/gawk)</u> (Mac OSX users only, awk doesn't support floats):

     - **sudo port install gawk**</u>


 * [yad](http://sourceforge.net/projects/yad-dialog) (optional, stand alone GUI on Linux):

    - <u>Debian/Ubuntu:</u> **sudo apt-get install yad**

    - <u>Fedora:</u>**sudo yum install yad**
