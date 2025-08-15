#!/usr/bin/env bash

#setting variables
index_last=$(ls -v /home/tomi/logs | grep day | tail -1 | cut -d'_' -f2)
index_yesterday=$((index_last + 1))
filename=day_$index_yesterday

#downloading the files
wget xx.xxx.xx.xxx/jds_march_2025/$filename -P /home/tomi/logs

#sorting them into folders
cat /home/tomi/logs/$filename | grep 'registration' > /home/tomi/registrations/$filename
cat /home/tomi/logs/$filename | grep 'free_tree' > /home/tomi/free_tree/$filename
cat /home/tomi/logs/$filename | grep 'super_tree' > /home/tomi/super_tree/$filename

#copying the data into SQL tables
psql -U tomi -d postgres -c "COPY registrations FROM '/home/tomi/registrations/$filename' DELIMITER ' ';"
psql -U tomi -d postgres -c "COPY free_tree FROM '/home/tomi/free_tree/$filename' DELIMITER ' ';"
psql -U tomi -d postgres -c "COPY super_tree FROM '/home/tomi/super_tree/$filename' DELIMITER ' ';"