#! /bin/bash
 
# DEADBEEF by Version Dependency
nowplaying=`deadbeef --nowplaying "%n %a - %t - %b - %y" | sed -n '1p' | tr -d '"'`
tracktime=`deadbeef --nowplaying "%l" | sed -n '1p'`
playlist_dir=`/home/derek/.config/deadbeef/playlists/`
playlist_num=`ls -l /home/derek/.config/deadbeef/playlists/* | wc -l | sed -n '1p'`

echo "<openbox_pipe_menu>"
echo "<menu id=\"root-menu-325671\" label=\""Track Info"\">"
echo "<item label=\""$nowplaying"\"><action name=\"Execute\"><execute>deadbeef</execute></action></item>"
echo "<item label=\"Total Runtime: "$tracktime"\"><action name=\"Execute\"><execute>deadbeef</execute></action></item>"
echo "<separator/>"
echo "<item label=\"Open Music Player\"><action name=\"Execute\"><execute>deadbeef</execute></action></item>"
echo "</menu>"
echo "<menu id=\"root-menu-325676\" label=\"Playlists ($playlist_num)\">"
for file in $(ls /home/derek/.config/deadbeef/playlists/*.dbpl -1v); do
NAME=$(echo "$file" | rev | cut -d"/" -f1 | rev)
echo "<item label=\"$NAME\"><action name=\"Execute\"><execute>deadbeef $file</execute></action></item>"
done
echo "</menu>"
echo "<separator/>"
echo "<item label=\"Play\"><action name=\"Execute\"><execute>deadbeef --play</execute></action></item>"
echo "<item label=\"Pause\"><action name=\"Execute\"><execute>deadbeef --pause</execute></action></item>"
echo "<item label=\"Stop\"><action name=\"Execute\"><execute>deadbeef --stop</execute></action></item>"
echo "<item label=\"Next\"><action name=\"Execute\"><execute>deadbeef --next</execute></action></item>"
echo "<item label=\"Previous\"><action name=\"Execute\"><execute>deadbeef --prev</execute></action></item>"
echo "<separator/>"
echo "<item label=\"Quit\"><action name=\"Execute\"><execute>deadbeef --quit</execute></action></item>"
echo "</openbox_pipe_menu>"
