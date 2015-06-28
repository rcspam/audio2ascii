# audio2ascii

    Convert an audio file to an ascii file readable by Natron/Nuke

#Requirements

    *Sox: sudo apt-get install sox or  sudo yum install sox
	  To support more audio formats than 'wav': sudo apt-get install libsox-fmt-all (debian) 
	  Fedora: to mp3 support for sox in fedora you can follow [This](https://unix.stackexchange.com/questions/98524/sox-returns-an-error-when-i-try-to-handle-mp3-files)
    *Yad: If you want a gui: sudo apt-get install yad ; sudo yum install yad

#Installation / Usage

    ```
    $ wget https://github.com/rcspam/audio2ascii/releases/download/v1.0.1/audio2ascii
    $ chmod +x ./audio2ascii
    $ ./audio2ascii --help # launch command line to know parameters
    $ ./audio2ascii -g # or launch with gui (see Requirements bellow)
    ```

