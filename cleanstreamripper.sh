#!/usr/bin/bash


cd /home/streamripper/destination

FREESPACE_THRESHOLD_MB=1900
# Verfügbaren Speicherplatz ermitteln
availableSpace=$(df --output=avail . | tail -n 1)
currentTimestamp=$(date)

echo "${currentTimestamp}: availableSpace=$((availableSpace/1024)) MB" >> /var/log/cron.log


if [ -f "zyx.txt" ]; then

	ls -A1 ./*.mp3 | while read SOURCETRACKFILENAME; do
	
		ALBUM="${SOURCETRACKFILENAME#*- }"
		ALBUM="${ALBUM%% - *mp3}"
		#ALBUM="(?<=^- )\S.*?(?= - )"
		echo "${ALBUM}" >> "LISTING.txt"	# mit Windows-Newline \n für Vergleichbarkeit mit ZYX.txt
		
	done
	
	grep -Fx -f "LISTING.txt" "zyx.txt" > "LISTING_REMOVE.txt"
	
	while read ALBUM
	do
		ALBUM=${ALBUM//[$'\t\r\n']}	# ZEILENUMBRUECHE ENTFERNEN
		rm -f " - ${ALBUM} - "*.mp3
	done < "LISTING_REMOVE.txt"
	
	rm "LISTING_REMOVE.txt"
	rm "LISTING.txt"

fi



# ggf. Platz machen
if [ "$availableSpace" -lt "$((FREESPACE_THRESHOLD_MB * 1024))" ]; then
	#mv -f *.mp3 /home/streamripper/storage/
 	for tempfilename in "*.mp3"; do
	 	cp -f --no-preserve=mode,ownership "$tempfilename" /home/streamripper/storage/ && rm "$tempfilename"
   	done
    echo "- moved files to storage" >> /var/log/cron.log
fi




# delete older incomplete files
cd /home/streamripper/destination/incomplete
find . -name "*.mp3" -type f -mmin +30 -print0 | xargs -0 rm -f

