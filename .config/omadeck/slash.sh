#!/bin/sh
# Types the given slash command and presses Enter. Usage: slash.sh '/command'
wtype "$1"
wtype -k Return
