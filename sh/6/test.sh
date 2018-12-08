#!/bin/bash

file_time=$(ls --full-time test.sh | cut -d" " -f6-7 | cut -c1,2,3,4,6,7,9,10,12,13,15,16,18,19)
echo $file_time
getAppTime="ls --full-time $app_file | cut -d' ' -f6-7 | cut -c1,2,3,4,6,7,9,10,12,13,15,16,18,19"
#echo $getAppTime
eval $getAppTime







