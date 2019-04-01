/*
* This is the interface exposed by Emscripten to the JavaScript world..
*
* Copyright (C) 2018 Juergen Wothke
*
*
* note: I temporarily added HivelyPlayer impl from zxtune (it is easier to activate the
* code here than to update my old zxtune version.. Also the dead code in xmp suggests
* that hvl support is envisoned and that my temporary add-on might become obsolete soon ;-)
*
* LICENSE
* 
* This library is free software; you can redistribute it and/or modify it
* under the terms of the GNU Lesser General Public License as published by
* the Free Software Foundation; either version 2.1 of the License, or (at
* your option) any later version. This library is distributed in the hope
* that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
* warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU Lesser General Public License for more details.
* 
* You should have received a copy of the GNU Lesser General Public
* License along with this library; if not, write to the Free Software
* Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301 USA
*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h> 


#include <xmp.h>
#include "common.h"

#include <hvl_replay.h>

#ifdef EMSCRIPTEN
#define EMSCRIPTEN_KEEPALIVE __attribute__((used))
#else
#define EMSCRIPTEN_KEEPALIVE
#endif

int isHvlMode= 0;

// regular XMP stuff:
int sampleRate=0;
xmp_context c;
struct xmp_frame_info fi;
struct xmp_module_info mi;

// temporary HivelyTracker add-on:
struct hvl_tune *ht;
#define CHANNELS 2				
#define BYTES_PER_SAMPLE 2
int16 *sample_buffer= 0;
int sample_buffer_size= 0;
int total_frames= 0;

void hvlSetupTrack(int trackId) {
	
	hvl_InitSubsong(ht, trackId);

	// determine length in frames
	total_frames= 0;
	while (!ht->ht_SongEndReached) {
		hvl_NextFrame(ht);
		++total_frames;
	}
	hvl_InitSubsong(ht, trackId);	// restart
}

int initXmp() __attribute__((noinline));
int EMSCRIPTEN_KEEPALIVE initXmp() {
	if (isHvlMode) {
	} else {
		c = xmp_create_context();
	}
	return 0;
}

int loadXmpModule(unsigned char *buf, long len, int rate) __attribute__((noinline));
int EMSCRIPTEN_KEEPALIVE loadXmpModule(unsigned char *buf, long len, int rate) {
	if (rate < XMP_MIN_SRATE) rate = XMP_MIN_SRATE;	// use resampling outside of this range
	if (rate > XMP_MAX_SRATE) rate = XMP_MAX_SRATE;
	
	sampleRate= rate;

	isHvlMode= !strncmp("HVL", buf, 3);
	if (isHvlMode) {
		if (sample_buffer == 0)	hvl_InitReplayer();

		ht = hvl_ParseTune( buf, len, sampleRate, 0 );
		return (ht == 0);
	} else {
		return xmp_load_module_from_memory(c, (void*)buf, len);
	}
}

int startXmpPlayer() __attribute__((noinline));
int EMSCRIPTEN_KEEPALIVE startXmpPlayer(int trackId) {
	if (isHvlMode) {
		if ((trackId < 0) || (trackId >= ht->ht_SubsongNr)) {
			trackId= 0;
		}
		hvlSetupTrack(trackId);
	} else {
		if (xmp_start_player(c, sampleRate, 0)) return 1;	// error
	}
    return 0;
}

int getXmpSampleRate() __attribute__((noinline));
int EMSCRIPTEN_KEEPALIVE getXmpSampleRate() {
	return sampleRate;
}

int getXmpFrameInfo() __attribute__((noinline));
int EMSCRIPTEN_KEEPALIVE getXmpFrameInfo() {
	xmp_get_frame_info(c, &fi);
	return 0;
}

int playXmpFrame() __attribute__((noinline));
int EMSCRIPTEN_KEEPALIVE playXmpFrame() {
	if (isHvlMode) {	
		uint32 samples= hvl_getSamplesPerFrame(ht);
		if (!sample_buffer || (samples > sample_buffer_size)) {
			if (sample_buffer) free(sample_buffer);
			
			sample_buffer= malloc(samples*CHANNELS*BYTES_PER_SAMPLE);
			sample_buffer_size= samples;
		}
	    if (!ht->ht_SongEndReached) {
			hvl_DecodeFrame(ht, (int8*)sample_buffer, (int8*)sample_buffer+BYTES_PER_SAMPLE, CHANNELS*BYTES_PER_SAMPLE);	// interleave left/right channel	
		}
		return ht->ht_SongEndReached;	// 0=OK
	} else {
		return  xmp_play_frame(c);
	}
}

int getXmpLoopCount() __attribute__((noinline));
int EMSCRIPTEN_KEEPALIVE getXmpLoopCount() {
	if (isHvlMode) {
		return ht->ht_SongEndReached;	// 1= end song
	} else {
		xmp_get_frame_info(c, &fi);
		return fi.loop_count;
	}
}

int getXmpSoundBufferLen() __attribute__((noinline));
int EMSCRIPTEN_KEEPALIVE getXmpSoundBufferLen() {
	if (isHvlMode) {
		return sample_buffer_size << 2;	// in bytes
	} else {
		return fi.buffer_size;
	}
}

char* getXmpSoundBuffer() __attribute__((noinline));
char* EMSCRIPTEN_KEEPALIVE getXmpSoundBuffer() {
	if (isHvlMode) {
		return (char*)sample_buffer;
	} else {
		return fi.buffer;
	}
}

int endXmp() __attribute__((noinline));
int EMSCRIPTEN_KEEPALIVE endXmp() {
	if (isHvlMode) {
		hvl_FreeTune( ht );
		ht= 0;
	} else {
		xmp_end_player(c);
		xmp_release_module(c);        /* unload module */
		xmp_free_context(c);          /* destroy the player context */
	}
	return 0;
}
	
static char* infoTexts[3];	// to be extended

#define MAX_TXT 64
static char module_name_str[MAX_TXT];
static char module_type_str[MAX_TXT];

static char tracks_str[5];

char** getMusicInfo() __attribute__((noinline));
char** EMSCRIPTEN_KEEPALIVE getMusicInfo() {
	if (isHvlMode) {
		infoTexts[0]= ht->ht_Name;
		infoTexts[1]= ""; 

		sprintf(tracks_str, "%d", ht->ht_SubsongNr);
		infoTexts[2]= tracks_str; 
	} else {
		// issue: when initially starting FuchsTracker/lowtheme.fuchs, then the type field reports garbage
		// but after some reloads it changes to "Fuchs Tracker" .. WTF?
		
		xmp_get_module_info(c, &mi);
		
		// directly using the "mi.mod->" pointers led to refresh problems.. see FuchsTracker
		// (author from previous song was sometimes reported)
		snprintf(module_name_str, "%s", mi.mod->name, MAX_TXT);
		snprintf(module_type_str, "%s", mi.mod->type, MAX_TXT);
		
		
		infoTexts[0]= module_name_str;
		infoTexts[1]= module_type_str;

		sprintf(tracks_str, "%d", 0);
		infoTexts[2]= tracks_str; 
	}		
    return infoTexts;
}

int getXmpCurrentPosition() __attribute__((noinline));
int EMSCRIPTEN_KEEPALIVE getXmpCurrentPosition() {
	if (isHvlMode) {
		return ht->ht_PlayingTime;
	} else {
		return fi.time;
		/*
		struct context_data *ctx = (struct context_data *)c;
		struct player_data *p = &ctx->p;
		return p->pos;*/
	}
}

void seekXmpPosition(int pos) __attribute__((noinline));
void EMSCRIPTEN_KEEPALIVE seekXmpPosition(int pos) {
	if (isHvlMode) {
		uint32 current = ht->ht_PlayingTime;
		if (pos < current) {
			hvl_InitSubsong(ht, 0);
			current = 0;
		}
		for (; current < pos; ++current) {
			hvl_NextFrame(ht);
		}
	} else {
		xmp_set_position(c, pos);
	}
}

int getXmpMaxPosition() __attribute__((noinline));
int EMSCRIPTEN_KEEPALIVE getXmpMaxPosition() {
	if (isHvlMode) {
		return total_frames;
	} else {
		return fi.total_time;
		/*
		struct context_data *ctx = (struct context_data *)c;
		struct module_data *m = &ctx->m;
		return  m->mod.len;
		*/
	}
}