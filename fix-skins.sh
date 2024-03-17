#!/usr/bin/env bash
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

if [ ! -f "$SCRIPT_DIR/fix-skin/build/fix-skin" ]; then
	if [ -f "$SCRIPT_DIR/fix-skin/build.sh" ]; then
		"$SCRIPT_DIR/fix-skin/build.sh"
		if (( $? != 0 )); then
			echo "Unable to build fix-skin"
			exit
		fi
		if [ -f "$SCRIPT_DIR/fix-skin/build/fix-skin" ]; then
			echo "fix-skin found: $SCRIPT_DIR/fix-skin/build/fix-skin"
		fi
	else
	echo "fix-skin executable not found (did you checkout and build?)"
	exit
	fi
fi

mkdir -p "$SCRIPT_DIR/skins_fixed"
readarray -t skins < <(find "$SCRIPT_DIR/skins" -type f -name "*.png")
for i in "${skins[@]}"; do
	size=($(identify -ping -format '%w %h' -regard-warnings "$i"))
	status=$?
#	echo "$i" "$SCRIPT_DIR/skins_fixed/$(basename "$i")"
	if [ ! -f "$SCRIPT_DIR/skins_fixed/$(basename "$i")" ]; then
		if (( status || "${size[0]}" % 8 || "${size[1]}" % 8 )); then
                        echo "Fixing skin $(basename "$i")"
                        "$SCRIPT_DIR/fix-skin/build/fix-skin" "$i" "$SCRIPT_DIR/skins_fixed/$(basename "$i")"
		else
			ln -s "$i" "$SCRIPT_DIR/skins_fixed/$(basename "$i")"
		fi
	fi
done
