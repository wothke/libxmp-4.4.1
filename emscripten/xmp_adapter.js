/*
 xmp_adapter.js: Adapts XMP backend to generic WebAudio/ScriptProcessor player.
 
 version 1.0
 
 	Copyright (C) 2015 Juergen Wothke

 LICENSE
 
 This library is free software; you can redistribute it and/or modify it
 under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2.1 of the License, or (at
 your option) any later version. This library is distributed in the hope
 that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
 warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public
 License along with this library; if not, write to the Free Software
 Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301 USA
*/
XMPBackendAdapter = (function(){ var $this = function () { 
		$this.base.call(this, backend_XMP.Module, 2);	
		this.isXmpAllocated= 0;
	}; 
	// XMP's sample buffer contains 2-byte integer sample data (i.e. must be rescaled) 
	// of 2 interleaved channels
	extend(EmsHEAP16BackendAdapter, $this, {  
		getAudioBuffer: function() {
			var ptr=  this.Module.ccall('getXmpSoundBuffer', 'number');			
			// make it a this.Module.HEAP16 pointer
			return ptr >> 1;	// 2 x 16 bit samples			
		},
		getAudioBufferLength: function() {
			var len= this.Module.ccall('getXmpSoundBufferLen', 'number') >>2;
			return len;
		},
		computeAudioSamples: function() {
			var status= this.Module.ccall('playXmpFrame', 'number');
			if (status != 0) return status;						// means "end song"
			
			return this.Module.ccall('getXmpLoopCount', 'number');	// >0 means "end song"
		},
		getMaxPlaybackPosition: function() { 
			return this.Module.ccall('getXmpMaxPosition', 'number');
		},
		getPlaybackPosition: function() {
			return this.Module.ccall('getXmpCurrentPosition', 'number');
		},
		seekPlaybackPosition: function(pos) { 
			return this.Module.ccall('seekXmpPosition', 'number', ['number'], [pos]);
		},

		getPathAndFilename: function(filename) {
			return ['/', filename];
		},
		registerFileData: function(pathFilenameArray, data) {
			return 0;	// not used in XMP
		},
		loadMusicData: function(sampleRate, path, filename, data, options) {
			var buf = this.Module._malloc(data.length);
			this.Module.HEAPU8.set(data, buf);
			
			var ret = this.Module.ccall('loadXmpModule', 'number', ['number', 'number', 'number'], [buf, data.length, sampleRate]);
			this.Module._free(buf);

			if (ret == 0) {			
				var inputSampleRate = this.Module.ccall('getXmpSampleRate', 'number');
				this.resetSampleRate(sampleRate, inputSampleRate); 
			}
			return ret;			
		},
		evalTrackOptions: function(options) {
			if (typeof options.timeout != 'undefined') {
				ScriptNodePlayer.getInstance().setPlaybackTimeout(options.timeout*1000);
			}
			var trackId= (typeof options.trackId != 'undefined') ? options.trackId : 0;	// only used for hvl			
			return this.Module.ccall('startXmpPlayer', 'number', ['number'], [trackId]);
		},				
		teardown: function() {
			if(this.isXmpAllocated)
				this.Module.ccall('endXmp', 'number');	// just in case
			this.Module.ccall('initXmp', 'number');
			this.isXmpAllocated= 1;
		},
		getSongInfoMeta: function() {
			return {title: String,
					player: String,
					tracks: String 
					};
		},
		updateSongInfo: function(filename, result) {
		// get song infos (so far only use some top level module infos)
			var numAttr= 3;
			var ret = this.Module.ccall('getMusicInfo', 'number');
			
			var array = this.Module.HEAP32.subarray(ret>>2, (ret>>2)+numAttr);
			result.title= this.Module.Pointer_stringify(array[0]);
			if (!result.title.length || (result.title ==="<unnamed>")) result.title= filename.replace(/^.*[\\\/]/, '').split('.').slice(0, -1).join('.');
			result.player= this.Module.Pointer_stringify(array[1]);
			result.tracks= this.Module.Pointer_stringify(array[2]);
		}
	});	return $this; })();
	