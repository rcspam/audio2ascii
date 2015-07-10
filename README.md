# audio2ascii
  Natron2.0 python plugin to animate you parameters with waveform from an audio file(mp3, wav,aiff,...).
  It use a bash script that you must have in your $PATH. (This is a Linux version, but it can be easily adapted for OSX or other Unix-like).

 ![frame](https://cloud.githubusercontent.com/assets/10021906/8617866/52e30a04-2708-11e5-95e7-d6c725a9e698.png)

 
 ![screenshot-2](https://cloud.githubusercontent.com/assets/10021906/8550164/3fd4ae8a-24cf-11e5-9c1d-87d153b72dec.png)


 A multiplatform Qt version of the bash script are currently being developed by [olear](https://github.com/olear/audiocurve)

#Requirements

 * [Sox](http://sox.sourceforge.net/): **sudo apt-get install sox** or  **sudo yum install sox**.

    For support more audio formats than 'wav': **sudo apt-get install libsox-fmt-all** (debian).

    Fedora: for mp3 support for sox you can read [this](https://unix.stackexchange.com/questions/98524/sox-returns-an-error-when-i-try-to-handle-mp3-files)

 * [Yad](http://sourceforge.net/projects/yad-dialog): If you want a gui: **sudo apt-get install yad** ; **sudo yum install yad**

#Installation / Usage

```
$ wget https://github.com/rcspam/audio2ascii/archive/v1.7.tar.gz
$ tar xvzf audio2ascii-1.7.tar.gz
$ cd audio2ascii-1.7
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
