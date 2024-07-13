#!/usr/bin/sh

cd /home/streamripper/destination

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
		#ALBUM=${ALBUM//[$'\t\r\n']}	# ZEILENUMBRUECHE ENTFERNEN
		rm -f " - ${ALBUM} - "*.mp3
	done < "LISTING_REMOVE.txt"
	#done < "../ZYX.txt"
	
	rm "LISTING_REMOVE.txt"
	rm "LISTING.txt"

fi

# delete older incomplete files
cd /home/streamripper/destination/incomplete
find . -name "*.mp3" -type f -mtime +1 -print0 | xargs -0 rm -f
