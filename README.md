# WebXmp

Copyright (C) 2014-2018 Juergen Wothke

This is a JavaScript/WebAudio plugin of XMP. This plugin is designed to work with my 
generic WebAudio ScriptProcessor music player (see separate project). 

A running example can be found here: http://www.wothke.ch/webxmp

The all the "Web" changes/additions are contained in the "emscripten" subfolder. The main 
addition is the new adapter.c file: It encapsulates all those APIs that interface with the 
JavaScript/Web world. 

## Credits
This mainly "project" is based on libxmp (4.4.1): http://xmp.sourceforge.net/
(The "hvl" add-on is based on Xeron/IRIS's "hvl2wav tool" with changes performed by Vitamin/CAIG. 
I hope that eventually XMP's currently unused "hvl" impl will be usable so that this add-on
will then no longer be neeeded.)

## Howto build

You'll need Emscripten (http://kripken.github.io/emscripten-site/docs/getting_started/downloads.html). The make script 
is designed for use of emscripten version 1.37.29 (unless you want to create WebAssembly output, older versions might 
also still work).

The below instructions assume that the libxmp-4.4.1 project folder has been moved into the main emscripten 
installation folder (maybe not necessary) and that a command prompt has been opened within the 
project's "emscripten" sub-folder, and that the Emscripten environment vars have been previously 
set (run emsdk_env.bat).

The Web version is then built using the makeEmscripten.bat that can be found in this folder. The 
script will compile directly into the "emscripten/htdocs" example web folder, were it will create 
the backend_xmp.js library. The content of the "htdocs" can be tested by first copying it into some 
document folder of a web server. 

## Dependencies
The current version requires version 1.02 (older versions will not
support WebAssembly) of my https://github.com/wothke/webaudio-player.

## License
This library is free software; you can redistribute it and/or modify it
under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation; either version 2.1 of the License, or (at
your option) any later version. This library is distributed in the hope
that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301 USA

