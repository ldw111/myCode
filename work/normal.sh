#!/bin/bash

if test $# -eq 0;then
	echo "Parameter less!!!"
	exit 1
fi

product=$1

export path_app=$(pwd)
#echo $path_app
cd ../../..
if [ -e APP ];then
	export UI_version=5
	cd GUI
elif [ -e app ];then
	export UI_version=4
	cd gui-4.0
else
	echo "pathname err!!"
	exit 1
fi
export path_gui=$(pwd)

if [ $product == "D1004NR" ];then
	export platform="HI-V100"
	export parasize="MAX_32"
	export fproduct=$product"-"$flash
elif [ $product == "D1008NR" ];then
	if test $UI_version -eq 5;then
		export platform="HI-V300A7"
	else
		export platform="HI3521A"
	fi
	export parasize="MAX_32"
	export fproduct=$product"-"$flash
elif [ $product == "D1016NR" ];then
	if test $UI_version -eq 5;then
		export platform="HI-V300A7"
	else
		export platform="HI3521A"
	fi
	export parasize="MAX_64"
	export fproduct=$product"-"$flash
elif [ $product == "D1104NR" ];then
	if test $UI_version -eq 5;then
		export platform="HI-V300A7"
	else
		export platform="HI3521A"
	fi
	export parasize="MAX_32"
	export fproduct=$product"-"$flash
elif [ $product == "D1108NR" ];then
	if test $UI_version -eq 5;then
		export platform="HI-V300A7"
	else
		export platform="HI3521A"
	fi
	export parasize="MAX_32"
	export fproduct=$product"-"$flash
elif [ $product == "D1116NR" ];then
	if test $UI_version -eq 5;then
		export platform="HI-V300A9"
	else
		export platform="HI3531A"
	fi
	export parasize="MAX_64"
	export fproduct=$product"-"$flash
elif [ $product == "D1132NR" ];then
	if test $UI_version -eq 5;then
		export platform="HI-V300A9"
	else
		export platform="HI3531A"
	fi
	export parasize="MAX_64"
	export fproduct=$product
elif [ $product == "D2104NR" ];then
	if test $UI_version -eq 5;then
		export platform="HI-V300A7"
	else
		export platform="HI3521A"
	fi
	export parasize="MAX_32"
	if test $flash -eq 16;then
		export fproduct=$product
	else
		export fproduct=$product"-"$flash
	fi
elif [ $product == "D2108NR" ];then
	if test $UI_version -eq 5;then
		export platform="HI-V300A9"
	else
		export platform="HI3531A"
	fi
	export parasize="MAX_32"
	if test $flash -eq 16;then
		export fproduct=$product
	else
		export fproduct=$product"-"$flash
	fi
elif [ $product == "D2116NR" ];then
	if test $UI_version -eq 5;then
		export platform="HI-V300A9"
	else
		export platform="HI3531A"
	fi
	export parasize="MAX_32"
	export fproduct=$product
elif [ $product == "D20DV400X" ];then
	export platform="HI-V500A7"
	export parasize="MAX_32"
	export fproduct=$product
elif [ $product == "D21DX" ];then
	export platform="HI-V500A7"
	export parasize="MAX_32"
	export fproduct=$product
elif [ $product == "D31DX" ];then
	export platform="HI-V500A9"
	export parasize="MAX_64"
	export fproduct=$product
elif [ $product == "D31D2CX" ];then
	export platform="HI-V500A9"
	export parasize="MAX_32"
	export fproduct="D31D-2CX"
else
	echo $product
	echo "Parameter error!!!"
	exit 1
fi

if test $# -eq 1;then
	export app_flag=1
	export gui_flag=1
	export app_clean="make clean;"
	export gui_clean="make clean;"
elif [ $2 == "app" ];then
	export app_flag=1
	export gui_flag=0
	if [ -n "$3" ];then
		:
	else
		export app_clean="make clean;"
	fi
elif [ $2 == "gui" ];then
	export app_flag=0
	export gui_flag=1
	if [ -n "$3" ];then
		:
	else
		export gui_clean="make clean;"
	fi
elif [ $2 == 0 ];then
	export app_flag=0
	export gui_flag=0
else
	echo "Parameter error!!!"
	exit 1
fi

cnt=0
name=1
flag=0
while [ -n "$name" ]
do
	((cnt++))
	name=$(echo $product_name | cut -d " " -f $cnt)
	#echo $name
	if [[ $name == $product ]];then
		flag=1
	fi
	if [[ $product_name =~ " " ]];then
		:
	else
		cnt=2
		break
	fi
done
let "cnt=cnt-1"
if test $flag -eq 0;then
	echo "Parameter error!!"
	exit 1
fi

if [ -n "$custom_name" ];then
	custom="CUSTOM="$custom_name
fi

if test $wifi -eq 1;then
	wifi_function="WIFI=SUPPORT"
fi
if test $pos -eq 1;then
	pos_function="SUPPORT_POS=TRUE"
fi

app_file="raysharp_dvr"
gui_file="raysharp-hdvr-ui"

if test $debug_gdb -eq 1;then
	if test $UI_version -eq 5;then
		debug_function="DEBUG=DEBUG_GDB"
		app_file="raysharp_dvr_debug"
	fi
fi

if [[ -n "$custom_define" ]];then
	define_custom="DEFINES=$custom_define"
fi

export compileAppCmd=""$app_clean"make -j32 PRODUCT=$product $custom $wifi_function $pos_function $debug_function $define_custom"
export compileGuiCmd=""$gui_clean"make -j32 PLATFORM=$platform PARASIZE=$parasize $define_custom"
getAppTime="ls --full-time $path_app/release/$app_file | cut -d' ' -f6-7 | cut -c1,2,3,4,6,7,9,10,12,13,15,16,18,19"
getGuiTime="ls --full-time $path_gui/Release/$gui_file | cut -d' ' -f6-7 | cut -c1,2,3,4,6,7,9,10,12,13,15,16,18,19"

if [[ -e $path_app/release/$app_file ]];then
	app_file_time_old=`eval $getAppTime`
else
	app_file_time_old=0
fi
if [[ -e $path_gui/Release/$gui_file ]];then
	gui_file_time_old=`eval $getGuiTime`
else
	gui_file_time_old=0
fi

cd $path_app

get_release()
{
	i=0
	for rel in "$release"*
	do
		#echo $rel
		((i++))
	done
	if test $i -ne $cnt;then
		echo "$release file count err!!"
		exit 1
	fi
	i=1
	name=$(echo $product_name | cut -d " " -f $i)
	while [ -n "$name" ]
	do
		#echo $name
		if [ -e $release"_"$name ];then
			:
		else
			mv $release $release"_"$name
		fi
		if [[ $product_name =~ " " ]];then
			:
		else
			break
		fi

		((i++))
		name=$(echo $product_name | cut -d " " -f $i)
	done
	mv $release"_"$product $release
}

get_date()
{
	cd $path_app/release
	AppDisplayVer=$(grep AppDisplayVer custom-config.ini | cut -d = -f 2)
	AppUpdataVer=$(grep AppUpdataVer custom-config.ini | cut -d = -f 2)
	LogoVersion=$(grep LogoVersion custom-config.ini | cut -d = -f 2)
	IEVersion=$(grep IEVersion custom-config.ini | cut -d = -f 2)
	export app_date=${AppDisplayVer:9:6}
	export app_up_date=${AppUpdataVer:1:6}
	export logo_date=${AppUpdataVer:1:6}
	export www_date=${AppUpdataVer:1:6}
	if [[ $date_version == 000000 ]];then
		date_version=$(date +%y%m%d)
	fi
	updata_date_fun
	
}

compile_App()
{
	cd $path_app
	export release="release"
	get_release
	#compileAppCmd="make clean;make -j32 PRODUCT=$product $custom $wifi_function $pos_function $debug_function"
	if test $app_flag -eq 1;then
		eval $compileAppCmd
	fi
	#echo $compileAppCmd
}

compile_Gui()
{
	cd $path_gui
	export release="Release"
	get_release
	#compileGuiCmd="make clean;make -j32 PLATFORM=$platform PARASIZE=$parasize"
	if test $gui_flag -eq 1;then
		eval $compileGuiCmd
		chmod 777 * -R
		cp -rf $release/* $path_app/release
		if [[ $del_tran_flag == 1 ]];then
			delete_language_label
		fi
	fi
	#echo $compileGuiCmd
}

updata_date_fun()
{
	if [ -n "$date_version" ];then
		if [[ $app_date != $date_version ]];then
			sed -i "s/"$app_date"/"$date_version"/g" custom-config.ini
			sed -i "s/"$app_up_date"/"$date_version"/g" custom-config.ini
			sed -i "s/"$logo_date"/"$date_version"/g" custom-config.ini
			sed -i "s/"$www_date"/"$date_version"/g" custom-config.ini
			app_date=$date_version
		fi
	fi
}

delete_language_label()
{
	cd $path_app/release
	sed -i -e 's/label="[^"]*" //; s/[[:blank:]]*//' language/*.xml
}

strip_fun()
{
	cd $path_app/release
	if [ $product == "D1004NR" ];then
		arm-hisiv100nptl-linux-strip raysharp*
		#delete_language_label
	else
		arm-hisiv300-linux-strip raysharp*
	fi
}

pack_fun()
{
	#delete_language_label
	if test $UI_version -eq 4;then
		strip_fun
	fi
	get_date
	cd $path_app
	if [ -e tools/RS_"$product" ];then
		:
	else
		mkdir tools/RS_"$product"
	fi
	rm tools/RS_"$product"/app_*
	chmod 777 * -R
	if [[ $lang_flag != "C" ]];then
		mksquashfs release app_V"$app_date"_"$fproduct"_M -comp xz
		mv app_V"$app_date"_"$fproduct"_M tools/RS_$product
	else
		mksquashfs release app_V"$app_date"_"$fproduct"_C -comp xz
		mv app_V"$app_date"_"$fproduct"_C tools/RS_$product
	fi
	
	cd $path_app/tools/RS_$product
	for logo_name in logo_*
	do
		if [[ $logo_name == logo_V$app_date ]];then
			:
		else
			mv $logo_name logo_V$app_date
		fi
	done
	
	for www_name in www_*
	do
		if [[ $www_name == www_V$app_date ]];then
			:
		else
			mv $www_name www_V$app_date
		fi
	done
}

del_p2p()
{
	cd $path_app/release
	if [ -e P2PTunnelServer ];then
		rm P2PTunnelServer
	fi
	if [ -e P2PTunnelServerDeamon ];then
		rm P2PTunnelServerDeamon
	fi
}

check_fun()
{
	cd $path_app/release
	err=0
	mount_flag=0
	if test $app_flag -eq 1;then
		if [[ -e $path_app/release/$app_file ]];then
			app_file_time_new=`eval $getAppTime`
		else
			app_file_time_new=0
		fi
		echo $compileAppCmd
		if [[ $app_file_time_new > $app_file_time_old ]];then
			:
		elif [[ -n "$app_clean" ]];then
			err=1
			echo "compile app err!!"
		fi
		
		if [[ -n "$app_clean" ]];then
			:
		else
			mount_flag=1      
		fi
		
		if [[ $debug_gdb == 1 ]];then
			mount_flag=1
		fi
	fi
	cd $path_gui/Release
	if test $gui_flag -eq 1;then
		if [[ -e $path_gui/Release/$gui_file ]];then
			gui_file_time_new=`eval $getGuiTime`
		else
			gui_file_time_new=0
		fi
		echo $compileGuiCmd
		if [[ $gui_file_time_new > $gui_file_time_old ]];then
			:
		elif [[ -n "$gui_clean" ]];then
			err=1
			echo "compile gui err!!"
		fi
		
		if [[ -n "$gui_clean" ]];then
			:
		else
			mount_flag=1      
		fi
	fi
	cd $path_app/release
	if [[ $app_flag == 0 ]] && [[ $gui_flag == 0 ]];then
		if [ -e $app_file ];then
			:
		else
			err=1
			echo "raysharp_dvr is not exist!!"
		fi
		if [ -e $gui_file ];then
			:
		else
			err=1
			echo "raysharp-hdvr-ui is not exist!!"
		fi
		if [ -e custom-config.ini ];then
			:
		else
			err=1
			echo "custom-config.ini is not exist!!"
		fi
	fi
	if test $err -eq 1;then
		exit 1
	elif test $mount_flag -eq 1;then
		rm -rf ~/nfs/release/*
		cp -rf $path_app/release/* ~/nfs/release
		if [[ $debug_gdb == 1 ]];then
			cp $path_gui/gdb ~/nfs/release
		fi
		exit 0
	fi
}

get_sw()
{
	cd $path_app/tools

	tree RS_$product
	./gr.sh $fproduct

	rm /home/lidongwei/pack/hdvrupgrade/*
	cp hdvrupgrade/* /home/lidongwei/pack/hdvrupgrade
	cd /home/lidongwei/pack/hdvrupgrade
	for name in *
	do
		if [ -n "$name" ];then
			new_name=${name%.*}
			mv $name $new_name"_W.sw"
		fi
	done
}

compile_App&

compile_Gui

wait

check_fun
	
echo "pack(Y/sw)?"
read key

if [[ $custom_name == "LIVEZON" ]] || [[ $custom_define == "VALUETOP" ]];then
	del_p2p
fi

if [[ $key == "Y" ]];then
	pack_fun
elif [[ $key == "sw" ]];then
	:
else
	exit 0
fi

get_sw
