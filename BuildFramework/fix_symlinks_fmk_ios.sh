#!/bin/bash
##########################################################
# Fix Symlinks
#
# Usage : Copy this file into the Framework directory,
# Execute it passing the Framework Name in argument.
#
##########################################################

if [ -z $1 ] ; then
  echo "Usage : $0 <Framework_Name>"
  exit -1
fi

if [ -f $1 ]
then
  echo "Framework Name symlink found : $1"
	
	echo "Removing current Symlinks files"
	rm Headers
	rm Resources
	rm $1
	rm Versions/Current
	
	echo "Creating new Symlinks"
	cd Versions
	ln -s A Current
	cd ..
	
	ln -s ./Versions/Current/Headers Headers
	ln -s ./Versions/Current/Resources Resources
	ln -s ./Versions/Current/$1 $1
	
	echo "Job done!"
else
	echo "The Framework Name is not correct."
fi