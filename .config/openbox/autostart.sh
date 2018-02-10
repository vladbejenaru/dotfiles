# compton --config ~/.config/compton/compton.conf & # --shadow-exclude 'n:a:Conky' -b &
compton &
xscreensaver -nosplash &
nitrogen --restore &

sleep 1;

tint2 &
# bmpanel2 &
# bmpanel2 --config ~/.config/bmpanel2/bmpanel2rc_mon1 &
# bmpanel2 --config ~/.config/bmpanel2/bmpanel2rc_mon2 &
/home/derek/.conky/conky_start_rings &

