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
if [ $# -ne 2 ]; then
    echo "Usage: gather.sh images_dirname URL"
    echo "  Make sure you quote things properly, e.g."
    echo "  gather.sh '/Users/my name/my images' 'http://www.reddit.com/r/EarthPorn+SpacePorn+AutumnPorn+WinterPorn+WaterPorn+ArchitecturePorn/search.rss?restrict_sr=on&limit=100'"
    exit
fi
echo $1 $2
cd "$1"
curl -so /tmp/$$_tmp1.txt $2
/usr/bin/xmllint --pretty 1 /tmp/$$_tmp1.txt | egrep '(\<title\>|\<description\>)' |grep -v 'media:title' |grep -v "multi: search">/tmp/$$_tmp3.txt
while  read line 
do
    #echo "######################"
    if [ "$line" = "<description/>" ]; then
	read line
    fi
	#/bin/echo "#TITLE#"$line"##"
	title=`echo $line | sed 's/\<title\>//g' | sed 's/\<\/title\>//g'`
	read line
	#echo "#IMAGE#"$line"##"
	image=`echo $line | awk -F= '{ for ( i=1; i < NF; i++) { printf("%s\n",$i); } }' | egrep 'link]' | awk -F\" '{ print $2; }'`
	if [ $? -eq 0 ]; then
  	    echo $image | egrep '(png|jpg|jpeg)' >&/dev/null
	    if [ $? -ne 0 ]; then
	        # sometimes imgur links are directly to the image
		image=${image}.jpg
	    fi
	fi
	# flickr galleries don't work, static flickr links do work
	echo $image | grep http | grep -v www.flickr.com |egrep '(png|jpg|jpeg)' >&/dev/null
	if [ $? -eq 0 ]; then
		filename=`echo $image | awk -F/ '{ print $NF; }'`
		/bin/echo -n "Download and process [$image:$title:$filename]... "
		if [ -f titled_$filename ]; then
			echo already done.
		else
			curl -so $filename $image
			if [ -f $filename ]; then
				php `dirname $0`/imgedit.php $filename "$title" 
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
