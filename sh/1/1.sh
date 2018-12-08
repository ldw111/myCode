#!/bin/bash
name="asBhJ_lUFIh"
typeset -u n
n=$name
echo $n
echo $name
echo "************"
mkdir 00
cd 00

a="123456"
b="23"
if [[ $a =~ $b ]];then
	echo "yes"
fi

cd -
rm -rf 00
