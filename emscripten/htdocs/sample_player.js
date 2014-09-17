/**
* sample_player.js
*
* 	Copyright (C) 2014 Juergen Wothke
*
* Terms of Use: This software is licensed under a CC BY-NC-SA 
* (http://creativecommons.org/licenses/by-nc-sa/4.0/).
*/

var fetchSamples= function(e) { 		
	// it seems that it is necessary to keep this explicit reference to the event-handler
	// in order to pervent the dumbshit Chrome GC from detroying it eventually
	
	var f= window.player['genSamples'].bind(window.player); // need to re-bind the instance.. after all this 
															// joke language has no real concept of OO	
	f(e);
};


SamplePlayer = function(onEnd) {
	this.title;
	this.player;

	this.isPaused= false;

	// internals
	this.initialized= false;
	this.onEnd= onEnd;
	
	this.sourceBuffer;
	this.sourceBufferLen;

	this.numberOfSamplesRendered= 0;
	this.numberOfSamplesToRender= 0;
	this.sourceBufferIdx=0;	
	
	try {
		window.AudioContext = window.AudioContext||window.webkitAudioContext;
		this.sampleRate = new AudioContext().sampleRate;
	} catch(e) {
		alert('Web Audio API is not supported in this browser (get Chrome 18 or Firefox 26)');
	}

	this.SAMPLES_PER_BUFFER = 8192;	// allowed: buffer sizes: 256, 512, 1024, 2048, 4096, 8192, 16384
	
	window.player= this;
};

SamplePlayer.prototype = {
	createScriptProcessor: function(audioCtx) {
		var scriptNode = audioCtx.createScriptProcessor(this.SAMPLES_PER_BUFFER, 0, 2);
		scriptNode.onaudioprocess = fetchSamples;
	//	scriptNode.onaudioprocess = player.generateSamples.bind(player);	// doesn't work with dumbshit Chrome GC
		return scriptNode;
	},
	playSong: function (data, track) {
		this.isPaused= true;
		this.loadData(data);
		this.selectTrack(track);
		this.isPaused= false;
	},
	playTmpFile: function (file) {
		var reader = new FileReader();
		reader.onload = function() {
			this.playSong(reader.result, 0);
		}.bind(this);
		reader.readAsArrayBuffer(file);
	},	
	loadData: function(arrayBuffer) {
		if(!this.initialized) {
			this.initialized= true;
		} else {
			Module.ccall('endXmp', 'number');	// just in case
		}
		Module.ccall('initXmp', 'number');

		if (arrayBuffer) {
			var byteArray = new Uint8Array(arrayBuffer);

			// load the song's binary data
			var buf = Module._malloc(byteArray.length);
			Module.HEAPU8.set(byteArray, buf);
			var ret = Module.ccall('loadXmpModule', 'number', ['number', 'number'], [buf, byteArray.length]);
			Module._free(buf);					
		}
	},
	updateTrackInfos: function() {
		// get song infos (so far we only use some top level module infos)
		ret = Module.ccall('getMusicInfo', 'number');
		
		var array = Module.HEAP32.subarray(ret>>2, (ret>>2)+2);
		this.title= Module.Pointer_stringify(array[0]);
		this.player= Module.Pointer_stringify(array[1]);
	},
	selectTrack: function(id) {
		// FIXME use selected track id
		ret = Module.ccall('startXmpPlayer', 'number', ['number'], [this.sampleRate]);
			
		this.updateTrackInfos();	  
	},
	genSamples: function(event) {
		var output1 = event.outputBuffer.getChannelData(0);
		var output2 = event.outputBuffer.getChannelData(1);

		if (this.isPaused) {
			var i;
			for (i= 0; i<output1.length; i++) {
				output1[i]= 0;
				output2[i]= 0;
			}		
		} else {
			var outSize= output1.length;
			
			this.numberOfSamplesRendered = 0;		

			while (this.numberOfSamplesRendered < outSize)
			{
				if (this.numberOfSamplesToRender == 0) {
				
					var status = Module.ccall('playXmpFrame', 'number');
					if (status != 0) {
						// no frame left
						this.fillEmpty(outSize, output1, output2);	
						if (this.onEnd) this.onEnd();
						this.isPaused= true;
						return;
					}
					status = Module.ccall('getXmpFrameInfo', 'number');
					
					status = Module.ccall('getXmpLoopCount', 'number');
					if (status > 0) {
						this.fillEmpty(outSize, output1, output2);	
						if (this.onEnd) this.onEnd();
						this.isPaused= true;
						return;					
					}

					// refresh just in case they are not using one fixed buffer..
					this.sourceBuffer= Module.ccall('getXmpSoundBuffer', 'number');
					this.sourceBufferLen= Module.ccall('getXmpSoundBufferLen', 'number')/4;
					
					this.numberOfSamplesToRender = this.sourceBufferLen;
					this.sourceBufferIdx=0;			
				}
				
				var srcBufI16= this.sourceBuffer>>1;	// 2 x 16 bit samples
				if (this.numberOfSamplesRendered + this.numberOfSamplesToRender > outSize) {
					var availableSpace = outSize-this.numberOfSamplesRendered;
					
					var i;
					for (i= 0; i<availableSpace; i++) {
						var r16= Module.HEAP16[srcBufI16 + (this.sourceBufferIdx++)];
						var l16= Module.HEAP16[srcBufI16 + (this.sourceBufferIdx++)];
						output1[i+this.numberOfSamplesRendered]= r16/0x7fff;
						output2[i+this.numberOfSamplesRendered]= l16/0x7fff;
					}				
					this.numberOfSamplesToRender -= availableSpace;
					this.numberOfSamplesRendered = outSize;
				} else {
					var i;
					for (i= 0; i<this.numberOfSamplesToRender; i++) {
						var r16= Module.HEAP16[srcBufI16 + (this.sourceBufferIdx++)];
						var l16= Module.HEAP16[srcBufI16 + (this.sourceBufferIdx++)];
						output1[i+this.numberOfSamplesRendered]= r16/0x7fff;
						output2[i+this.numberOfSamplesRendered]= l16/0x7fff;
					}						
					this.numberOfSamplesRendered += this.numberOfSamplesToRender;
					this.numberOfSamplesToRender = 0;
				} 
			}  
		}	
	},
	fillEmpty: function(outSize, output1, output2) {
		var availableSpace = outSize-this.numberOfSamplesRendered;
		for (i= 0; i<availableSpace; i++) {
			output1[i+this.numberOfSamplesRendered]= 0;
			output2[i+this.numberOfSamplesRendered]= 0;
		}				
		this.numberOfSamplesToRender = 0;
		this.numberOfSamplesRendered = outSize;			
	}
};