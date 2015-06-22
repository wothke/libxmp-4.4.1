/*
* This is the interface exposed by Emscripten to the JavaScript world..
*
* Copyright (C) 2014 Juergen Wothke
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

#ifdef EMSCRIPTEN
#define EMSCRIPTEN_KEEPALIVE __attribute__((used))
#else
#define EMSCRIPTEN_KEEPALIVE
#endif


xmp_context c;
struct xmp_frame_info fi;
struct xmp_module_info mi;

int initXmp() __attribute__((noinline));
int EMSCRIPTEN_KEEPALIVE initXmp() {
    c = xmp_create_context();
	return 0;
}
int sampleRate=0;

int loadXmpModule(unsigned char *buf, long len, int rate) __attribute__((noinline));
int EMSCRIPTEN_KEEPALIVE loadXmpModule(unsigned char *buf, long len, int rate) {
	if (rate < XMP_MIN_SRATE) rate = XMP_MIN_SRATE;	// use resampling outside of this range
	if (rate > XMP_MAX_SRATE) rate = XMP_MAX_SRATE;
	sampleRate= rate;			

	return xmp_load_module_from_memory(c, (void*)buf, len);
}

int startXmpPlayer() __attribute__((noinline));
int EMSCRIPTEN_KEEPALIVE startXmpPlayer() {
    xmp_start_player(c, sampleRate, 0);
    return 0;
}

int getXmpSampleRate() __attribute__((noinline));
int EMSCRIPTEN_KEEPALIVE getXmpSampleRate() {
	return sampleRate;
}

int playXmpFrame() __attribute__((noinline));
int EMSCRIPTEN_KEEPALIVE playXmpFrame() {
	return xmp_play_frame(c);
}

int getXmpFrameInfo() __attribute__((noinline));
int EMSCRIPTEN_KEEPALIVE getXmpFrameInfo() {
	xmp_get_frame_info(c, &fi);
	return 0;
}

int getXmpModuleInfo() __attribute__((noinline));
int EMSCRIPTEN_KEEPALIVE getXmpModuleInfo() {
	xmp_get_module_info(c, &mi);
	return 0;
}

int getXmpLoopCount() __attribute__((noinline));
int EMSCRIPTEN_KEEPALIVE getXmpLoopCount() {
	return fi.loop_count;
}

int getXmpSoundBufferLen() __attribute__((noinline));
int EMSCRIPTEN_KEEPALIVE getXmpSoundBufferLen() {
	return fi.buffer_size;
}

char* getXmpSoundBuffer() __attribute__((noinline));
char* EMSCRIPTEN_KEEPALIVE getXmpSoundBuffer() {
	return fi.buffer;
}

int endXmp() __attribute__((noinline));
int EMSCRIPTEN_KEEPALIVE endXmp() {
    xmp_end_player(c);
    xmp_release_module(c);        /* unload module */
    xmp_free_context(c);          /* destroy the player context */
	return 0;
}
	
static char* infoTexts[2];	// to be extended

char** getMusicInfo() __attribute__((noinline));
char** EMSCRIPTEN_KEEPALIVE getMusicInfo() {
	xmp_get_module_info(c, &mi);
	
    infoTexts[0]= mi.mod->name;
    infoTexts[1]= mi.mod->type;
		
    return infoTexts;
}


int getXmpCurrentPosition() __attribute__((noinline));
int EMSCRIPTEN_KEEPALIVE getXmpCurrentPosition() {
	struct context_data *ctx = (struct context_data *)c;
	struct player_data *p = &ctx->p;
	return p->pos;
}

void seekXmpPosition(int pos) __attribute__((noinline));
void EMSCRIPTEN_KEEPALIVE seekXmpPosition(int pos) {
	xmp_set_position(c, pos);
}

int getXmpMaxPosition() __attribute__((noinline));
int EMSCRIPTEN_KEEPALIVE getXmpMaxPosition() {
	struct context_data *ctx = (struct context_data *)c;
	struct module_data *m = &ctx->m;
	return  m->mod.len;
}