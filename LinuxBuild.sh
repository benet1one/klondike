#!/bin/sh
echo -ne '\033c\033]0;Klondike\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/LinuxBuild.x86_64" "$@"
