#!/bin/bash

date_version="000000"
echo $date_version
if [ $date_version == 0 ];then
	echo "0"
elif [ $date_version == 000000 ];then
	echo "000000"
elif [ $date_version == "000000" ];then
	echo "***"
fi

