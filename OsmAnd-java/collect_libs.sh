#!/bin/bash
SCRIPT_LOC="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_LOC="$SCRIPT_LOC/../.."
function copyLibs {
	if [ -d "$ROOT_LOC/binaries/$1/$2" ]; then 
		echo "Copy binaries $1 $2";
		cp "$ROOT_LOC"/binaries/$1/$2/libOsmAndJNI.$4 bin/OsmAndJNI-$1-$3.lib
		cp "$ROOT_LOC"/binaries/$1/$2/libOsmAndCoreUtils.$4 bin/OsmAndCoreUtils-$1-$3.lib
		cp "$ROOT_LOC"/binaries/$1/$2/libOsmAndCore.$4 bin/OsmAndCore-$1-$3.lib
		cp "$ROOT_LOC"/core/externals/qtbase-desktop/upstream.patched.$1.$2/lib/libQt5Core.$4.5.0.2 bin/Qt5Core-$1-$3.lib
	fi
}

function compile {
	"$ROOT_LOC/core/externals/configure.sh"
	"$ROOT_LOC/core/externals/qtbase-desktop/build.sh"
	"$ROOT_LOC/tools/map-viewer/externals/freeglut/configure.sh"
	if [ ! -d "$ROOT_LOC/amd64-linux-gcc-release.makefile" ]; then 
		"$ROOT_LOC/build/amd64-linux-gcc.sh" release
	fi
	(cd "$ROOT_LOC/baked/amd64-linux-gcc-release.makefile" && make -j`nproc` OsmAndJNI)
	if [ ! -d "$ROOT_LOC/baked/i686-linux-gcc-release.makefile" ]; then 
		"$ROOT_LOC/build/i686-linux-gcc.sh" release
	fi
	(cd "$ROOT_LOC/baked/i686-linux-gcc-release.makefile" && make -j`nproc` OsmAndJNI)
}

compile
copyLibs linux amd64 amd64 so
copyLibs linux i686 x86 so
