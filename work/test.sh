#!/bin/bash
#DVR编译脚本
#将本文件置于APP下的main目录中
export product_name="D1108NR" #需编译的型号，中间用空格隔开
export custom_name=""               #客户名，编译时需要带客户名时，才赋值，否则为空
export flash=16                     #flash大小，16或者32
export wifi=0                       #是否带wifi功能 1:支持 0：不支持
export pos=0                        #是否带pos功能  1:支持 0：不支持
export debug_gdb=0                  #是否开启gdb调试(UI5.0 app) 1:开启 0:不开启
export date_version=000000          #日期，打包的日期版本 000000表示当前日期
export lang_flag=M                  #语言，C：纯中文，不为 C：多国
export custom_define=""             #客户宏
export del_tran_flag=0              #删除语言标签标志位，1：删除 0：不删除


para1=$1
para2=$2
para3=$3


~/db.sh $para1 $para2 $para3
