#!/bin/sh
#
# File: gather.sh
# Author: Brad Dobson
# Description:
#
# Reddit image gatherer, nice for screen backgrounds. I use it with GeekTool.
# Inspired by http://www.reddit.com/r/EarthPorn/comments/gtdeu/howto_set_rearthporn_to_be_your_desktop_wallpaper/ 
# Download rss xml and grab the title and link subsections from the <description> sections
# Download the image if possible, use php to place title on image, name it titled_imagename
# Delete original image.
# 
# Doesn't re-download stuff that's already done. You are responsible for cleaning up the directory
# periodically. 
# 
cd reddit_image_gatherer
curl -so /tmp/$$_tmp1.txt 'http://www.reddit.com/r/EarthPorn+SpacePorn+AutumnPorn+WinterPorn+WaterPorn+ArchitecturePorn/search.rss?q=1920x1200&restrict_sr=on&limit=100' 
xmllint --pretty 1 /tmp/$$_tmp1.txt >/tmp/$$_tmp2.txt
grep '\<description\>' /tmp/$$_tmp2.txt | awk -F= '{ for ( i=1; i < NF; i++) { printf("%s\n",$i); } }' | egrep '(" title|link])' | awk -F\" '{ print $2; }'  >/tmp/$$_tmp3.txt
cd images
while  read line 
do
	#/bin/echo -n "#TITLE#"$line"##"
	title=$line
	read line
	#echo "#IMAGE#"$line"##"
	image=$line
	echo $image | grep http | grep -v flickr |egrep '(png|jpg|jpeg)' >&/dev/null
	if [ $? -eq 0 ]; then
		filename=`echo $image | awk -F/ '{ print $NF; }'`
		/bin/echo -n "Download and process [$image:$title]... "
		if [ -f titled_$filename ]; then
			echo already done.
		else
			curl -so $filename $image
			if [ -f $filename ]; then
				php ../imgedit.php $filename "$title" 
				rm $filename
				echo done.
			else
				echo failed.
			fi
		fi
	else
		echo Not processing $image, could not find image name in URL
	fi
done </tmp/$$_tmp3.txt
rm /tmp/$$_tmp*
