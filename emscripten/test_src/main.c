// simple proof of concept to check if the APIs intended for JavaScript use work as expected..

#include <stdio.h>
#include <stdlib.h>
#include <xmp.h>

FILE *createOutput() {
    FILE *f;
    /* The output raw file */
    f = fopen("out.raw", "wb");
    if (f == NULL) {
        fprintf(stderr, "can't open output file\n");
        exit(EXIT_FAILURE);
    }
	return f;
}

int main(int argc, char **argv)
{
	FILE *outf= createOutput();
	
	initXmp();
	
    if (loadXmpModule(argv[1]) != 0) {
        fprintf(stderr, "can't load module\n");
        exit(EXIT_FAILURE);
    }
    startXmpPlayer(44100);
	
	getMusicInfo();
	
    while (playXmpFrame(c) == 0) {
        getXmpFrameInfo();

        if (getXmpLoopCount() > 0)    /* exit before looping */
            break;
			
        fwrite(getXmpSoundBuffer(), getXmpSoundBufferLen(), 1, outf);  /* write audio data */
    }
	
	endXmp();

    fclose(f);
    exit(EXIT_SUCCESS);
}

