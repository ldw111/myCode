#!/bin/bash

para1=$1
para2=$2
para3=$3

if [[ $product_name =~ " " ]];then
	:
elif [[ $para1 != $product_name ]];then
	para1=$product_name
	para2=$1
	para3=$2
fi

HOSTNAME="172.18.6.148"                                
PORT="3306"
USERNAME="root"
PASSWORD="123456"

DBNAME="test"                                                    
TABLENAME="work_db"                                                  

MYSQL="mysql -h"$HOSTNAME" -u"$USERNAME" -p"$PASSWORD" -D"$DBNAME" --default-character-set=utf8 -A -N"

sql="create table if not exists $TABLENAME(id int not null primary key, para1 text, para2 text, para3 text)"
$MYSQL -e "$sql"

sql="select para1 from $TABLENAME where id=1"
result1=$($MYSQL -e "$sql")
sql="select para2 from $TABLENAME where id=1"
result2=$($MYSQL -e "$sql")
sql="select para3 from $TABLENAME where id=1"
result3=$($MYSQL -e "$sql")

wait_flag=0
if [[ $para1 == "app" ]] || [[ $para1 == "gui" ]] || [[ $para1 == "0" ]];then
	para3=$para2
	para2=$para1
	para1=$result1
	if [[ $para2 != 0 ]];then
		wait_flag=1
	fi
fi

if [[ -n "$para1" ]];then
	if [[ $result1 != $para1 ]] || [[ $result2 != $para2 ]] || [[ $result3 != $para3 ]];then
		sql="delete from $TABLENAME where id=1"
		$MYSQL -e "$sql"
		sql="insert into $TABLENAME value(1, '"$para1"', '"$para2"', '"$para3"')"
		$MYSQL -e "$sql"
	fi
fi

if [ -n "$para1" ];then
	result1=$para1
	result2=$para2
	result3=$para3
else
	sql="select para1 from $TABLENAME where id=1"
	result1=$($MYSQL -e "$sql")
	sql="select para2 from $TABLENAME where id=1"
	result2=$($MYSQL -e "$sql")
	sql="select para3 from $TABLENAME where id=1"
	result3=$($MYSQL -e "$sql")
fi

#echo $result

if [[ -n "$1" ]] && [[ $wait_flag != 1 ]];then
	echo "$result1 $result2 $result3"
else
	echo "$result1 $result2 $result3"
	read key
	if [ -n "$key" ];then
		exit 1
	fi
fi
#exit 0
~/normal.sh $result1 $result2 $result3
