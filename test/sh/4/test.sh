#!/bin/bash

HOSTNAME="172.18.6.148"                                
PORT="3306"
USERNAME="root"
PASSWORD="123456"

DBNAME="test"                                                    
TABLENAME="work_db"                                                  

product=$1

MYSQL="mysql -h"$HOSTNAME" -u"$USERNAME" -p"$PASSWORD" -D"$DBNAME" --default-character-set=utf8 -A -N"

sql="create table if not exists $TABLENAME(id int not null primary key, product text)"
$MYSQL -e "$sql"

sql="select product from $TABLENAME where id=1"
result=$($MYSQL -e "$sql")

if [ -n "$product" ] && [[ $result != $product ]];then
	sql="delete from $TABLENAME where id=1"
	$MYSQL -e "$sql"
	sql="insert into $TABLENAME value(1, '"$product"')"
	$MYSQL -e "$sql"
fi

sql="select product from $TABLENAME where id=1"
result=$($MYSQL -e "$sql")

echo $result

