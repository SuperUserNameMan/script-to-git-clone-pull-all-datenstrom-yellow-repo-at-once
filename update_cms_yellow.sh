#!/bin/bash

[[ ! -d "./yellow_cms" ]] && mkdir yellow_cms

cd ./yellow_cms


echo "Reading update_cms_yellow.ini"

subdir="."

while IFS=";" read -r line description
do
	line=`echo $line` # trim

	description=`echo $description` # trim

	if [[ "$line" =~ ^\[ ]]; then # [ SECTION_NAME ]
	
		echo -e "\e[36m$line\e[m"

		subdir="" # reset
	
	elif [[ "$line" =~ ^subdir= ]]; then

		arr=(${line//=/ })

		subdir=`echo ./${arr[1]}` # trim

		[[ ! -d "$subdir" ]] && mkdir $subdir

	elif [[ "$line" =~ ^http ]]; then

		echo -e "\e[32m- Updating $line :\e[m $description"

		url="$line.git"

		dstdir=$( basename $line )

		# In case we have duplicate extension names, we can provide an 
		# alternative name in the .ini file using a pipe as separator :

		if [[ $dstdir == *\|* ]]; then

			arr=(${line//|/ })

			url=`echo ${arr[0]}`
			dstdir=`echo ${arr[1]}`
		fi

		# Clone the repo or update the repo :

		echo git -C ".$subdir/$dstdir" clone "$url" 

		[[ ! -d "$subdir/$dstdir" ]] && git clone "$url" "$subdir/$dstdir" || git -C "$subdir/$dstdir" pull

		echo ""
	fi

done < ../update_cms_yellow.ini

