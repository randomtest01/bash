#!/bin/bash
########################################################################################
# What this file does:                                                                 #
# It renames all files to remove special characters                                    #
# It then creates a tmp directory                                                      #
# All mp4, mkv & webm files are converted to mp3 and placed in the tmp directory       #
# Requirements: ffmpeg                                                                 #
########################################################################################

#Rename files to regain sanity

for file in ./*
do
  infile=`echo "${file:2}"|sed  \
         -e 's|"\"|"\\"|g' \
         -e 's| |\ |g' -e 's|!|\!|g' \
         -e 's|@|\@|g' -e 's|*|\*|g' \
         -e 's|&|\&|g' -e 's|]|\]|g' \
         -e 's|}|\}|g' -e 's|"|\"|g' \
         -e 's|,|\,|g' -e 's|?|\?|g' \
         -e 's|=|\=|g'  `
  outfileNOSPECIALS=`echo "${file:2}"|sed -e 's|[^A-Za-z0-9._-]|_|g'`
  outfileNOoe=`echo $outfileNOSPECIALS| sed -e 's|ö|oe|g'`
  outfileNOae=`echo $outfileNOoe| sed -e 's|ä|ae|g'`
  outfileNOue=`echo $outfileNOae| sed -e 's|ü|ue|g'`
  outfileNOOE=`echo $outfileNOue| sed -e 's|Ö|OE|g'`
  outfileNOAE=`echo $outfileNOOE| sed -e 's|Ä|AE|g'`
  outfileNOUE=`echo $outfileNOAE| sed -e 's|Ü|UE|g'`
  outfileNOss=`echo $outfileNOUE| sed -e 's|ß|ss|g'`
  outfile=${outfileNOss}
  if [ "$infile" != "${outfile}" ]
  then
        echo "filename changed for " $infile " in " $outfile
        mv "$infile" ${outfile}
  fi
done


# Check to see if there is a tmp directory, if not, create it

if [ ! -d tmp ]; then
  mkdir -p tmp;
fi


# Convert mp4 to mp3 and copy to tmp dir

MP4FILE=$(ls * |grep .mp4)
for filename in $MP4FILE
do 
 name=`echo "$filename" | sed -e "s/.mp4$//g"`
 ffmpeg -i $filename -b:a 192K -vn tmp/$name.mp3
done
echo "mp4 done"

# Convert mkv to mp3 and copy to tmp dir

MKVFILE=$(ls * |grep .mkv)
for filename in $MKVFILE
do 
 name=`echo "$filename" | sed -e "s/.mkv$//g"`
 ffmpeg -i $filename -b:a 192K -vn tmp/$name.mp3
done

echo "mkv done"

# Convert WEBM to mp3 and copy to tmp dir

WEBMFILE=$(ls * |grep .webm)
for filename in $WEBMFILE
do 
 name=`echo "$filename" | sed -e "s/.webm$//g"`
 ffmpeg -i $filename -b:a 192K -vn tmp/$name.mp3
done

echo "All done"
exit
