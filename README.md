# audio2ascii

 Convert an audio file to an ascii file readable by the Natron/Nuke curve editor.
    
#Requirements

 * [Sox](http://sox.sourceforge.net/): **sudo apt-get install sox** or  **sudo yum install sox**.
 
    For support more audio formats than 'wav': **sudo apt-get install libsox-fmt-all** (debian).
		 
    Fedora: for mp3 support for sox you can read [this](https://unix.stackexchange.com/questions/98524/sox-returns-an-error-when-i-try-to-handle-mp3-files)
 
 * [Yad](http://sourceforge.net/projects/yad-dialog): If you want a gui: **sudo apt-get install yad** ; **sudo yum install yad**

#Installation / Usage

```
$ wget https://github.com/rcspam/audio2ascii/releases/download/v1.2/audio2ascii
$ chmod +x ./audio2ascii
$ ./audio2ascii --help # launch command line to know the parameters
$ ./audio2ascii -g # or launch with gui (see Requirements above)
```
#Examples

Some short videos released with the [Natron 2 Snapshot](http://sourceforge.net/projects/natron/files/snapshots/) Transform Node:

* [Test1.mp4](https://dl.dropboxusercontent.com/u/2677320/test1.mp4) ( x curve on scale)
* [Test2.mp4](https://dl.dropboxusercontent.com/u/2677320/test2.mp4) ( xy curves (stereo) with x translate on left channel,  y translate on right channel )
* [Test3.mp4](https://dl.dropboxusercontent.com/u/2677320/test3.mp4) (y curve on y translate)
