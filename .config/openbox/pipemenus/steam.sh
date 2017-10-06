#!/bin/bash

STEAMAPPS=/home/derek/.steam/steam/steamapps
echo '<openbox_pipe_menu>'
echo '<item icon="/home/derek/.config/openbox/square-open.png" label="Steam"><action name="Execute"><execute>steam</execute></action></item>'
echo '<separator/>'
for file in $(ls $STEAMAPPS/*.acf -1v); do
ID=$(cat "$file" | grep '"appID"' | head -1 | sed -r 's/[^"]*"appID"[^"]*"([^"]*)"/\1/')
NAME=$(cat "$file" | grep '"name"' | head -1 | sed -r 's/[^"]*"name"[^"]*"([^"]*)"/\1/')
echo "<item icon=\"/home/derek/.config/openbox/square-open.png\" label=\"$NAME\"><action name=\"Execute\"><execute>steam steam://run/$ID</execute></action></item>"
done
echo '</openbox_pipe_menu>'
