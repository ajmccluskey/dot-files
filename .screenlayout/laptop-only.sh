#!/bin/sh

mode="laptopOnly"
modeline=""

host=$(hostname)
case $(hostname) in
  hermes)
    modeline='172.80  1920 2040 2248 2576  1080 1081 1084 1118  -HSync +Vsync'
    ;;
  stevie)
    modeline='197.97  2048 2184 2408 2768  1152 1153 1156 1192  -HSync +Vsync'
    ;;
  *)
    echo "Unknown host: ${host}"
    exit 1
    ;;
esac

xrandr --rmmode $mode
xrandr --newmode  $mode $modeline
xrandr --addmode eDP1 laptopOnly
xrandr --output VIRTUAL1 --off --output eDP1 --mode $mode --pos 0x0 --rotate normal --output DP1 --off --output HDMI2 --off --output HDMI1 --off --output DP2 --off --output DP1-2 --off --output DP1-1 --off
