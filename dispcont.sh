# dispcont: A simple script to display directory contents
#
# Copyright 2017 (c) Dimitrios Gravanis
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# input:	user-specified path
# output:	path contents

#!/bin/bash

OPT="$1"
declare FILES

COUNTF=0
COUNTD=0
COUNTU=0
COUNT=0

function inpath() {
	# check input
	read -p "directory path (q to quit): " FILEPATH
	cd $FILEPATH > /dev/null 2>&1
	while [ "$?" -ne "0" ]; do
		if [[ "$FILEPATH" = "q" || "$FILEPATH" = "Q" ]]; then
			echo "--stopped--"
			return 1
		else
			read -p "re-enter path (q to quit): " FILEPATH
		fi
		cd $FILEPATH > /dev/null 2>&1
	done

	return 0
}

function counter() {
	# check for hidden option
	if [ "$OPT" == "--hidden" ]; then
		FILES=$(ls -1a)
	else
		FILES=$(ls -1)
	fi
	# index input path
	for FILE in $FILES
	do
		if [ -d $FILE ]; then
			((COUNTD++))
		elif [ -f $FILE ]; then
			((COUNTF++))
		else
			((COUNTU++))
		fi
		((COUNT++))
	done

	return 0
}

function display() {
	# show contents
	echo "------------------------"
	echo "CONTENTS"
	echo "------------------------"
	echo "total items: ${COUNT}"
	echo "directories: ${COUNTD}"
	echo "      files: ${COUNTF}"
	echo "unspecified: ${COUNTU}"
	echo "------------------------"

	return 0
}

while [ true ]; do
	inpath
	if [ "$?" -ne "0" ]; then
		break
		exit 1
	fi
	counter
	display
done
