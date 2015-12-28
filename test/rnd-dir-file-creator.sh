#!/bin/bash

#############################################################################################
#											    #
# THE LINUX RANDOM DIRECTORY & FILE GENERATOR						    #
# Author: Ben H. Watson									    #
# Twitter: @WhatsOnStorage								    #
# Blog: http://whatsonstorage.azurewebsites.net						    #
# Date crafted: March 2014								    #
#											    #
# Please feel free to use, share, edit etc. this script, all feedback and callouts are	    #
# appreciated!										    #
#											    #
#############################################################################################

## User prompted inputs

read -p "Please specify a log directory  #  " ourlog
while true
do read -p "
Shall we output the dd command stats to our log file?

Bear in mind this may be quite a lot depending on the # of files & directories we create...  #  " ddoutput
case $ddoutput in
        [Yy]* ) ddoutput="yes"
        break ;;
        [Nn]* ) ddoutput="no"
        break ;;
        * ) echo "Please enter 'Yes' or 'No'...  " ;;
esac
done
/bin/echo ""
read -p "What directory shall we create this stuff in? Please don't include a trailing slash.  #  " tgtdir
/bin/echo "
"
read -p "How many directories do you want to create?  #  " numdirs
/bin/echo "
"
/bin/echo "Maximum and minimums now...
"
/bin/echo "This script will produce a randomly generated number of files in each directory based on your following definitions.
"
read -p "What's the fewest number of files we should create in each directory?  #  " minfiles
read -p "What's the greatest number of files we should create in each directory?  #  " maxfiles
/bin/echo "
This script will produce randomly sized files based on your following definitions.
"
read -p "Let's have a low input for the sizing, in KB?  #  " smallfile
read -p "Now let's have a high input for the sizing, in KB?  #  " largefile
/bin/echo ""
read -p "And finally, the block size in KB?  #  " setblksize
/bin/echo "
"
while true
do
        read -p "Do you want the files to be:
        1.) Compressible?
        2.) Non-compressible?

        Please enter the corresponding value: 1.) or 2.)  #  " comp
case $comp in
        [1]* ) comp="zero"
                break ;;
        [2]* ) comp="urandom"
                break ;;
#       [3]* ) comp="***TBC--MIXED--TBC***"
#                break ;;
        * ) echo "Please enter the corresponding value: 1 or 2...  #  " ;;
esac
done

## Processing user inputs

if [ $comp == "zero" ]
then compr="Compressible"
elif [ $comp == "urandom" ]
then compr="Non-compressible"
fi
if [ $ddoutput == "yes" ]
then ddoutput=$ourlog
elif [ $ddoutput == "no" ]
then ddoutput="/dev/null"
fi

## Logging input options

/bin/echo "
#########################################################################
#                                                                       #
#               THE LINUX RANDOM DIRECTORY & FILE GENERATOR             #
#                     `/bin/date`             #
#                                                                       #
#                Author: Ben H. Watson (@WhatsOnStorage)                #
#           Blog Site: http://whatsonstorage.azurewebsites.net		#
#########################################################################


________________________________________________________________________
|VARIABLE                               |VALUE
|---------------------------------------|-------------------------------
|Target Mount Point                     |$tgtdir
|Number of directories                  |$numdirs
|Minimum # of files per directory       |$minfiles
|Maximum # of files per directory       |$maxfiles
|Smallest file to be created (in KB)    |$smallfile
|Largest file to be created (in KB)     |$largefile
|Compressability                        |$compr
|Block size set for dd command          |$setblksize
------------------------------------------------------------------------

Before we create our stuff:

`/bin/df -h`

------------------------
Now let's get creating!
" >> $ourlog


## Directory & file creation starts here:

dircount="1"
filecount="1"

while [ $dircount -le $numdirs ]
do /bin/mkdir -p $tgtdir/directory-$dircount
numfiles=$(( RANDOM% ($maxfiles - $minfiles) + $minfiles ))
for (( c=1; c<=$numfiles; c++ ))
do /bin/dd if=/dev/$comp of=$tgtdir/directory-$dircount/file-$filecount bs=$setblksize count=`echo $(( $smallfile+(RANDOM )%($largefile-$smallfile+1) *1024 ))` >> $ddoutput 2>&1 &
(( filecount ++ ))
done
(( dircount ++ ))
done 

## Upon completion, dd PIDs will be spawned but processes may well still be running
## Allow time for the data to be completely written

/bin/echo "
And we're done creating!
------------------------

"


read -p "The directories and files have been created. Hit enter once the commands have finished for the most accurate log reports.

Otherwise, hit enter to get back to a prompt but note the log reports may be inaccurate."

/bin/echo "
"

## Logging statistics following the creation phase:

/bin/echo "
After we have created our stuff:

`/bin/df -h`

And let's look at the listings:

`/usr/bin/du -h --max-depth=1 $tgtdir`

And a bit more detail:

`/bin/ls -l -h $tgtdir/dir*`

#########################################################################
#                                                                       #
#                               END                                     #
#                  `/bin/date`                     #
#                         		                                #
#                                                                       #
#########################################################################
" >> $ourlog

