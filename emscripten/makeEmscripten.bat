:: **** use the "-s WASM" switch to compile WebAssembly output. warning: the SINGLE_FILE approach does NOT currently work in Chrome 63.. ****
:: NOTE: TOTAL_MEMORY is currently configured for a maximum music file size of about 30mb

emcc.bat -s WASM=1 -s ASSERTIONS=0 -s SAFE_HEAP=0  -Wno-pointer-sign -s VERBOSE=0 -s TOTAL_MEMORY=100663296 -DHAVE_MKSTEMP=1 -I ../include -I ../src -I ../src/hvl -Os -O3  --memory-init-file 0 --closure 1 --llvm-lto 1 -s FORCE_FILESYSTEM=1 ../src/hvl/hvl_tables.c ../src/hvl/hvl_replay.c ../src/depackers/readhuff.c ../src/depackers/ppdepack.c ../src/depackers/unsqsh.c ../src/depackers/mmcmp.c ../src/depackers/readrle.c ../src/depackers/readlzw.c ../src/depackers/unarc.c ../src/depackers/arcfs.c  ../src/depackers/inflate.c ../src/depackers/muse.c ../src/depackers/unlzx.c ../src/depackers/s404_dec.c ../src/depackers/unzip.c ../src/depackers/gunzip.c ../src/depackers/uncompress.c ../src/depackers/unxz.c ../src/depackers/bunzip2.c ../src/depackers/unlha.c ../src/depackers/xz_dec_lzma2.c ../src/depackers/xz_dec_stream.c ../src/depackers/oxm.c ../src/depackers/vorbis.c ../src/depackers/crc32.c ../src/depackers/readhuff.c  ../src/loaders/common.c ../src/loaders/iff.c ../src/loaders/itsex.c ../src/loaders/asif.c ../src/loaders/voltable.c ../src/loaders/sample.c ../src/loaders/xm_load.c ../src/loaders/mod_load.c ../src/loaders/s3m_load.c ../src/loaders/stm_load.c ../src/loaders/669_load.c ../src/loaders/far_load.c ../src/loaders/mtm_load.c ../src/loaders/ptm_load.c ../src/loaders/okt_load.c ../src/loaders/ult_load.c ../src/loaders/mdl_load.c ../src/loaders/it_load.c ../src/loaders/stx_load.c ../src/loaders/pt3_load.c ../src/loaders/sfx_load.c ../src/loaders/flt_load.c ../src/loaders/st_load.c ../src/loaders/emod_load.c ../src/loaders/imf_load.c ../src/loaders/digi_load.c ../src/loaders/fnk_load.c ../src/loaders/ice_load.c ../src/loaders/liq_load.c ../src/loaders/ims_load.c ../src/loaders/masi_load.c ../src/loaders/amf_load.c ../src/loaders/psm_load.c ../src/loaders/stim_load.c ../src/loaders/mmd_common.c ../src/loaders/mmd1_load.c ../src/loaders/mmd3_load.c ../src/loaders/rtm_load.c ../src/loaders/dt_load.c ../src/loaders/no_load.c ../src/loaders/arch_load.c ../src/loaders/sym_load.c ../src/loaders/med2_load.c ../src/loaders/med3_load.c ../src/loaders/med4_load.c ../src/loaders/dbm_load.c ../src/loaders/umx_load.c ../src/loaders/gdm_load.c ../src/loaders/pw_load.c ../src/loaders/gal5_load.c ../src/loaders/gal4_load.c ../src/loaders/mfp_load.c ../src/loaders/asylum_load.c ../src/loaders/hmn_load.c ../src/loaders/mgt_load.c ../src/loaders/chip_load.c ../src/loaders/abk_load.c  ../src/loaders/prowizard/prowiz.c ../src/loaders/prowizard/ptktable.c ../src/loaders/prowizard/tuning.c ../src/loaders/prowizard/ac1d.c ../src/loaders/prowizard/di.c ../src/loaders/prowizard/eureka.c ../src/loaders/prowizard/fc-m.c ../src/loaders/prowizard/fuchs.c ../src/loaders/prowizard/fuzzac.c ../src/loaders/prowizard/gmc.c ../src/loaders/prowizard/heatseek.c ../src/loaders/prowizard/ksm.c ../src/loaders/prowizard/mp.c ../src/loaders/prowizard/np1.c ../src/loaders/prowizard/np2.c ../src/loaders/prowizard/np3.c ../src/loaders/prowizard/p61a.c ../src/loaders/prowizard/pm10c.c ../src/loaders/prowizard/pm18a.c ../src/loaders/prowizard/pha.c ../src/loaders/prowizard/prun1.c ../src/loaders/prowizard/prun2.c ../src/loaders/prowizard/tdd.c ../src/loaders/prowizard/unic.c ../src/loaders/prowizard/unic2.c ../src/loaders/prowizard/wn.c ../src/loaders/prowizard/zen.c ../src/loaders/prowizard/tp1.c ../src/loaders/prowizard/tp3.c ../src/loaders/prowizard/p40.c ../src/loaders/prowizard/xann.c ../src/loaders/prowizard/theplayer.c ../src/loaders/prowizard/pp10.c ../src/loaders/prowizard/pp21.c ../src/loaders/prowizard/starpack.c ../src/loaders/prowizard/titanics.c ../src/loaders/prowizard/skyt.c ../src/loaders/prowizard/novotrade.c ../src/loaders/prowizard/hrt.c ../src/loaders/prowizard/noiserun.c ../src/tempfile.c ../src/mix_paula.c ../src/lutgen.c ../src/virtual.c ../src/format.c ../src/period.c ../src/player.c ../src/read_event.c ../src/dataio.c ../src/mkstemp.c ../src/md5.c ../src/lfo.c ../src/scan.c ../src/control.c ../src/med_extras.c ../src/filter.c ../src/fmopl.c ../src/effects.c ../src/mixer.c ../src/mix_all.c  ../src/load_helpers.c ../src/load.c ../src/memio.c ../src/hio.c ../src/hmn_extras.c ../src/extras.c ../src/smix.c adapter.c -s EXPORTED_FUNCTIONS="['_initXmp', '_loadXmpModule', '_startXmpPlayer', '_playXmpFrame', '_getXmpSampleRate', '_getXmpCurrentPosition', '_seekXmpPosition', '_getXmpMaxPosition', '_getXmpLoopCount', '_getXmpSoundBufferLen', '_getXmpSoundBuffer', '_endXmp', '_getMusicInfo', '_malloc', '_free']"   -o htdocs/xmp.js  -s SINGLE_FILE=0 -s EXTRA_EXPORTED_RUNTIME_METHODS="['ccall', 'Pointer_stringify']"  -s BINARYEN_ASYNC_COMPILATION=1 -s BINARYEN_TRAP_MODE='clamp' && copy /b shell-pre.js + htdocs\xmp.js + shell-post.js htdocs\webXmp3.js && del htdocs\xmp.js && copy /b htdocs\webXmp3.js + xmp_adapter.js htdocs\backend_xmp.js && del htdocs\webXmp3.js

::set "OPT= -s WASM=0 -s ASSERTIONS=0 -s SAFE_HEAP=0  -Wno-pointer-sign -s VERBOSE=0 -s TOTAL_MEMORY=100663296 -DHAVE_MKSTEMP=1 -I ../include -I ../src -I ../src/hvl -Os -O3 "
::if not exist "built/xmp.bc" (
::	call emcc.bat %OPT% ../src/hvl/hvl_tables.c ../src/hvl/hvl_replay.c ../src/depackers/readhuff.c ../src/depackers/ppdepack.c ../src/depackers/unsqsh.c ../src/depackers/mmcmp.c ../src/depackers/readrle.c ../src/depackers/readlzw.c ../src/depackers/unarc.c ../src/depackers/arcfs.c  ../src/depackers/inflate.c ../src/depackers/muse.c ../src/depackers/unlzx.c ../src/depackers/s404_dec.c ../src/depackers/unzip.c ../src/depackers/gunzip.c ../src/depackers/uncompress.c ../src/depackers/unxz.c ../src/depackers/bunzip2.c ../src/depackers/unlha.c ../src/depackers/xz_dec_lzma2.c ../src/depackers/xz_dec_stream.c ../src/depackers/oxm.c ../src/depackers/vorbis.c ../src/depackers/crc32.c ../src/depackers/readhuff.c  ../src/loaders/common.c ../src/loaders/iff.c ../src/loaders/itsex.c ../src/loaders/asif.c ../src/loaders/voltable.c ../src/loaders/sample.c ../src/loaders/xm_load.c ../src/loaders/mod_load.c ../src/loaders/s3m_load.c ../src/loaders/stm_load.c ../src/loaders/669_load.c ../src/loaders/far_load.c ../src/loaders/mtm_load.c ../src/loaders/ptm_load.c ../src/loaders/okt_load.c ../src/loaders/ult_load.c ../src/loaders/mdl_load.c ../src/loaders/it_load.c ../src/loaders/stx_load.c ../src/loaders/pt3_load.c ../src/loaders/sfx_load.c ../src/loaders/flt_load.c ../src/loaders/st_load.c ../src/loaders/emod_load.c ../src/loaders/imf_load.c ../src/loaders/digi_load.c ../src/loaders/fnk_load.c ../src/loaders/ice_load.c ../src/loaders/liq_load.c ../src/loaders/ims_load.c ../src/loaders/masi_load.c ../src/loaders/amf_load.c ../src/loaders/psm_load.c ../src/loaders/stim_load.c ../src/loaders/mmd_common.c ../src/loaders/mmd1_load.c ../src/loaders/mmd3_load.c ../src/loaders/rtm_load.c ../src/loaders/dt_load.c ../src/loaders/no_load.c ../src/loaders/arch_load.c ../src/loaders/sym_load.c ../src/loaders/med2_load.c ../src/loaders/med3_load.c ../src/loaders/med4_load.c ../src/loaders/dbm_load.c ../src/loaders/umx_load.c ../src/loaders/gdm_load.c ../src/loaders/pw_load.c ../src/loaders/gal5_load.c ../src/loaders/gal4_load.c ../src/loaders/mfp_load.c ../src/loaders/asylum_load.c ../src/loaders/hmn_load.c ../src/loaders/mgt_load.c ../src/loaders/chip_load.c ../src/loaders/abk_load.c  ../src/loaders/prowizard/prowiz.c ../src/loaders/prowizard/ptktable.c ../src/loaders/prowizard/tuning.c ../src/loaders/prowizard/ac1d.c ../src/loaders/prowizard/di.c ../src/loaders/prowizard/eureka.c ../src/loaders/prowizard/fc-m.c ../src/loaders/prowizard/fuchs.c ../src/loaders/prowizard/fuzzac.c ../src/loaders/prowizard/gmc.c ../src/loaders/prowizard/heatseek.c ../src/loaders/prowizard/ksm.c ../src/loaders/prowizard/mp.c ../src/loaders/prowizard/np1.c ../src/loaders/prowizard/np2.c ../src/loaders/prowizard/np3.c ../src/loaders/prowizard/p61a.c ../src/loaders/prowizard/pm10c.c ../src/loaders/prowizard/pm18a.c ../src/loaders/prowizard/pha.c ../src/loaders/prowizard/prun1.c ../src/loaders/prowizard/prun2.c ../src/loaders/prowizard/tdd.c ../src/loaders/prowizard/unic.c ../src/loaders/prowizard/unic2.c ../src/loaders/prowizard/wn.c ../src/loaders/prowizard/zen.c ../src/loaders/prowizard/tp1.c ../src/loaders/prowizard/tp3.c ../src/loaders/prowizard/p40.c ../src/loaders/prowizard/xann.c ../src/loaders/prowizard/theplayer.c ../src/loaders/prowizard/pp10.c ../src/loaders/prowizard/pp21.c ../src/loaders/prowizard/starpack.c ../src/loaders/prowizard/titanics.c ../src/loaders/prowizard/skyt.c ../src/loaders/prowizard/novotrade.c ../src/loaders/prowizard/hrt.c ../src/loaders/prowizard/noiserun.c ../src/tempfile.c ../src/mix_paula.c ../src/lutgen.c ../src/virtual.c ../src/format.c ../src/period.c ../src/player.c ../src/read_event.c ../src/dataio.c ../src/mkstemp.c ../src/md5.c ../src/lfo.c ../src/scan.c ../src/control.c ../src/med_extras.c ../src/filter.c ../src/fmopl.c ../src/effects.c ../src/mixer.c ../src/mix_all.c  ../src/load_helpers.c ../src/load.c ../src/memio.c ../src/hio.c ../src/hmn_extras.c ../src/extras.c ../src/smix.c -o built/xmp.bc 
::	IF !ERRORLEVEL! NEQ 0 goto :END
::)
::emcc.bat %OPT% --memory-init-file 0 --closure 1 --llvm-lto 1 -s FORCE_FILESYSTEM=1 built/xmp.bc adapter.c -s EXPORTED_FUNCTIONS="['_initXmp', '_loadXmpModule', '_startXmpPlayer', '_playXmpFrame', '_getXmpSampleRate', '_getXmpCurrentPosition', '_seekXmpPosition', '_getXmpMaxPosition', '_getXmpLoopCount', '_getXmpSoundBufferLen', '_getXmpSoundBuffer', '_endXmp', '_getMusicInfo', '_malloc', '_free']"   -o htdocs/xmp.js  -s SINGLE_FILE=0 -s EXTRA_EXPORTED_RUNTIME_METHODS="['ccall', 'Pointer_stringify']"  -s BINARYEN_ASYNC_COMPILATION=1 -s BINARYEN_TRAP_MODE='clamp' && copy /b shell-pre.js + htdocs\xmp.js + shell-post.js htdocs\webXmp3.js && del htdocs\xmp.js && copy /b htdocs\webXmp3.js + xmp_adapter.js htdocs\backend_xmp.js && del htdocs\webXmp3.js

::END