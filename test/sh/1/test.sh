#!/bin/bash

svn_up_fun()
{
	svn up
	#svn up -r 16666
}

update_fun()
{
	echo [update_fun]
	echo "Updating..."
	cd $svn_code_pathway
	svn_up_fun
	echo "update code complete..."
	cd $svn_logo_pathway
	svn up
	echo "update logo complete..."
	cd $svn_sdk_pathway
	svn up
	echo "update sdk complete..."
	cd $svn_NewWeb_pathway
	svn up
	echo "update ie complete..."
}

init_fun()
{
	echo [init_fun]
	if test $UI_edition -eq 4;then
		export svn_code_pathway=$svn_code4_pathway_pathway
		export svn_NewWeb_pathway=$svn_NewWeb4_pathway
		export APP="app"
		export GUI="gui-4.0"
	elif test $UI_edition -eq 5;then
		export svn_code_pathway=$svn_code5_pathway
		if [ $product == "D21DX" ] || [ $product == "D31DX" ] || [ $product == "D31D-2CX" ];then
			export svn_NewWeb_pathway=$svn_NewWeb5_pathway_265
		else
			export svn_NewWeb_pathway=$svn_NewWeb5_pathway
		fi
		export APP="APP"
		export GUI="GUI"
	else
		echo "UI edition error!!!(UI4.0/UI5.0)"
		exit 1
	fi
	
	if [ $product == D1004NR ];then
		export svn_sdk_pathway=$svn_20D_pathway
	elif [ $product == D1104NR ] || [ $product == D1108NR ] || [ $product == D2104NR ];then
		export svn_sdk_pathway=$svn_21A_sdk_pathway
	elif [ $product == D1116NR ] || [ $product == D2108NR ];then
		export svn_sdk_pathway=$svn_31A_sdk_pathway
	elif [ $product == D2116NR ];then
		export svn_sdk_pathway=$svn_31A_two_sdk_pathway
	elif [ $product == D21DX ];then
		export svn_sdk_pathway=$svn_21D_sdk_pathway
	elif [ $product == D31DX ];then
		export svn_sdk_pathway=$svn_31D_sdk_pathway
	elif [ $product == D31D-2CX ];then
		export svn_sdk_pathway=$svn_31D_two_sdk_pathway
	else
		echo "The product is error!!!"
		exit 2
	fi
	
}

export_code_fun()
{
	echo [export_code_fun]
	#cd /home/lidongwei/nfs
	cd $svn_code_pathway
	export lastBuildNumber=$(svn info | grep -w Rev | cut -d ' ' -f 4)
	export buildNumber=$(svn info | grep Revision | cut -d ' ' -f 2)
	
	if [ $update_flag -ne 1 ];then
		echo "Don't need to export!"
		
		export currentDate=$(cat $svn_nfs_pathway/log.txt | grep Date | cut -d ':' -f 2)
		echo $currentDate
		export currentBuildNumber=$(cat $svn_nfs_pathway/log.txt | grep buildNumber | cut -d ':' -f 2)
		
	else
		
		echo "Exporting..."
		
		nowTime=`date +%y%m%d`

		export logInfoFile=$svn_nfs_pathway/log.txt
		mkdir $svn_nfs_pathway -p
		if [ -e $logInfoFile ];then
			rm $logInfoFile
		fi
		echo "buildNumber:"$buildNumber >> $logInfoFile
		echo "Date:"$nowTime >> $logInfoFile
		echo $nowTime
		read key
		
		export currentDate=$(cat $svn_nfs_pathway/log.txt | grep Date | cut -d ':' -f 2)
		export currentBuildNumber=$(cat $svn_nfs_pathway/log.txt | grep buildNumber | cut -d ':' -f 2)
		
		svn export $svn_code_pathway/$APP $svn_nfs_pathway/app&
		svn export $svn_code_pathway/$GUI $svn_nfs_pathway/gui
		wait
		echo "Export complete"
	fi
}

product_manage_fun()
{
	echo [product_manage_fun]
	echo [para_manage_fun]
	export Nflag=0 #0为实时，1为非实时
	export Sflag=0 #0为不带报警，1为带报警
	export Eflag=0 #0为不带esata，1为带esata
	export flash=16 #flash大小
	export isHR=0 #是否为HR外观的机型
	num=$cproduct
	num1=${num#*-*} #去掉第一个“-”及其前面的所有
	num2=${num1/N/Y} #将num1中的“N”用“Y”替换
	num3=${num1/S/Y} #将num1中的“S”用“Y”替换
	num4=${num1/F/Y} #将num1中的“F”用“Y”替换
	num5=${num1/E/Y} #将num1中的“E”用“Y”替换
	HRflag=${num:5:2} #从第5个开始取num的2个字符
	export product=${num:0:5} #从第1个开始取num5个字符
	
	if [ $num1 != $num4 ] || [ $product == D1132 ] || [ $product == D2116 ];then
		flash=32
	fi
	
	if [ $num1 != $num2 ];then
		product=${product}"NR"
		Nflag=1
	fi
	
	if [ $product == D3104NR ];then
		product=D21DX
		flash=32
	fi
	
	if [ $product == D3108NR ];then
		product=D31DX
		flash=32
	fi
	
	if [ $product == D3116NR ];then
		product=D31D-2CX
		flash=32
	fi
	
	if [ $num1 != $num3 ];then
		Sflag=1
	fi
	
	if [ $num1 != $num5 ];then
		Eflag=1
	fi
	
	if [ $HRflag == HR ] && [ $Eflag == 0 ];then
		isHR=1
	fi
	
	if [ $product == D1124 ]||[ $product == D1124NR ];then
		product=D1124
	fi
	if [ $product == D31D-2CX ];then
		export rscproduct=RS_${product%-*}${product#*-}
		echo $rscproduct
	else
		export rscproduct=RS_$product
	fi
	
	export dcustomer=$(echo $customer | tr '[a-z]' '[A-Z]') #大写的客户名
	export xcustomer=$(echo $customer | tr '[A-Z]' '[a-z]') #小写的客户名
	
	frist=${customer:0:1}
	dfrist=$(echo $frist | tr '[a-z]' '[A-Z]') #转大写
	export dxcustomer="$dfrist""${xcustomer:1}" #第一个字母大写其余小写的客户名
	
	
}

prepare_pack_fun()
{
	echo [prepare_pack_fun]
	#echo $update_flag
	if test $UI_edition -eq 4;then
		echo "************************************"
		echo "\"UI4.0!\""
		echo "customer:$customer"
		echo "product:$product"
		echo "flash:$flash"
		echo "Date:$currentDate"
		echo "BuildNumber:$currentBuildNumber"
		echo "************************************"
	else
		echo "************************************"
		echo "\"UI5.0!\""
		echo "customer:$customer"
		echo "product:$product"
		echo "flash:$flash"
		echo "Date:$currentDate"
		echo "BuildNumber:$currentBuildNumber"
		echo "************************************"
	fi
	read key
	export_code_fun
	wait
	read key
	while true
	do
		read key
	done
	if test $update_flag -eq 1;then
		#开客户宏
		if [ $dcustomer != NORMAL ];then
			cd $svn_nfs_pathway/app/dvr/modules/pub/include/
			kehuhong="#define $dcustomer"
			sed -i "3a ${kehuhong}" version.h
			cd $svn_nfs_pathway/gui/src/Adpter
			sed -i "2a ${kehuhong}" customeconfig.h
			cd $svn_code_pathway
		fi
	fi
	
	export app_main_pathway=""$svn_nfs_pathway"/app/dvr/main"
	echo $app_main_pathway
	export gui_main_pathway=""$svn_nfs_pathway"/gui"
	echo $gui_main_pathway
	
	if test $compileApp -eq 0 && test $compileGui -eq 0;then
		rm $app_main_pathway/app_V*
		cp $app_main_pathway/tools/$rscproduct/app_V* $app_main_pathway/
	fi
	
	cd $app_main_pathway/tools/
	if [ -e $rscproduct ];then
		echo "The $rscproduct is exist!"
	else
		mkdir $rscproduct
	fi
	pwd
	export app_product_pathway=$app_main_pathway/$product
	export tools_product_pathway=$app_main_pathway/tools/$rscproduct
	if [ -e $app_product_pathway ];then
		echo "The $product is exist!"
	else
		mkdir $app_product_pathway
		echo "create $product success!"
	fi
	cd $app_product_pathway
	if [ -e "./custom-config.ini" ];then
		echo "the file is exist!"
	else
		cproductFlg=$product
		flag=0
		cd $app_main_pathway/tools/config
		typeset -u pfileName
		for pfile in *
		do
			pfileName=$pfile
			if [ $dcustomer == NORMAL ];then
				pfile=standard
			elif [ $dcustomer == CDOUBLES ];then
				pfile=CDoubles
			fi
			if [ $pfileName == $dcustomer ];then
				cd $pfile
				flag=1
				if [ -e $cproductFlg ];then
					cp $app_main_pathway/tools/config/$pfile/$cproductFlg/custom-config.ini $app_product_pathway/
					break
				else
					cp $app_main_pathway/tools/config/standard/$cproductFlg/custom-config.ini $app_product_pathway/
					break
				fi
			fi
		done
		if test flag -eq 0;then
			cp $app_main_pathway/tools/config/standard/$cproductFlg/custom-config.ini $app_product_pathway/
		fi
	fi
}

custom_config_fun()
{
	echo [custom_config_fun]
	cd $app_product_pathway/
	#修改时间
	appDisplayVer=$(cat $app_product_pathway/custom-config.ini | grep AppDisplayVer)
	appDisplayVerFlg=${appDisplayVer:23:6}
	echo $appDisplayVerFlg
	echo $currentDate
	sed -i "s/"$appDisplayVerFlg"/"$currentDate"/g" custom-config.ini
	appUpdataVer=`cat "$app_product_pathway"/custom-config.ini | grep AppUpdataVer`
	appUpdataVerFlg=${appUpdataVer:14:6}
	sed -i "s/"$appUpdataVerFlg"/"$currentDate"/g" custom-config.ini
	logoVersion=`cat "$app_product_pathway"/custom-config.ini | grep LogoVersion`
	logoVersionFlg=${logoVersion:13:6}
	sed -i "s/"$logoVersionFlg"/"$currentDate"/g" custom-config.ini
	iEVersion=`cat "$app_product_pathway"/custom-config.ini | grep IEVersion`
	iEVersionFlg=${iEVersion:11:6}
	sed -i "s/"$iEVersionFlg"/"$currentDate"/g" custom-config.ini
	
	#修改升级包包名前缀
	upgradePacketPreFixName=`cat "$app_product_pathway"/custom-config.ini | grep UpgradePacketPreFix`
	upgradePacketPreFixFlg1=${upgradePacketPreFixName%% *} #升级包包名前缀
	upgradePacketPreFixFlg2=${upgradePacketPreFixFlg1#*-*}
	if test $flash -eq 32;then
		if [[ $upgradePacketPreFixFlg2 == [0-9][0-9] ]];then
			if test $upgradePacketPreFixFlg2 -eq 16||test $upgradePacketPreFixFlg2 -eq 32||\
			[ "$product" == "D2104NR" ]||[ "$product" == "D2108NR" ];then
				upgradePacketPreFixFlg3="UpgradePacketPreFix=""$product"-32
				sed -i "s/"$upgradePacketPreFixFlg1"/"$upgradePacketPreFixFlg3"/g" custom-config.ini
			fi
		fi
	fi
	
	#不带报警处理
	if test $Sflag -eq 0;then
		alarmEnable=`cat "$app_product_pathway"/custom-config.ini | grep AlarmEnable`
		alarmEnableFlg1=${alarmEnable%%	*}
		alarmEnableFlg2="AlarmEnable=0"
		sed -i "s/"$alarmEnableFlg1"/"$alarmEnableFlg2"/g" custom-config.ini
		audioNum=`cat "$app_product_pathway"/custom-config.ini | grep AudioNum`
		audioNumFlg1=${audioNum%% *}
		audioNumFlg2="AudioNum=4"
		sed -i "s/"$audioNumFlg1"/"$audioNumFlg2"/g" custom-config.ini
	fi
	
	#纯中文默认语言为简体中文
	#if [ $language == C ];then
	#	sed -i "s/"IELangMask=16"/"IELangMask=1"/g" custom-config.ini
	#	sed -i "s/"IELanguage=4"/"IELanguage=0"/g" custom-config.ini
	#	sed -i "s/"Language=4"/"Language=0"/g" custom-config.ini
	#fi
	
	#21系列默认打开智能分析
	if test $UI_edition -eq 5;then
		if [ "$cproduct" = "D2104NR" ]||[ "$cproduct" = "D2108NR" ]||[ "$cproduct" = "D2116NR" ]\
		||[ "$cproduct" = "D2108" ]||[ "$cproduct" = "D2104" ];then
			sed -i "s/"EnableAlg=0"/"EnableAlg=1"/g" custom-config.ini
		fi
	else
		IECustom=`cat "$app_product_pathway"/custom-config.ini | grep IECustom`
		IECustom_2=${IECustom%% *}
export IECustom_3=${IECustom_2#*=*}
	fi
	echo $isHR
	if test $isHR -eq 1;then
		sed -i "s/DiskGroupEnable=1/DiskGroupEnable=0/g" custom-config.ini
	else
		sed -i "s/DiskGroupEnable=0/DiskGroupEnable=1/g" custom-config.ini
	fi
}
add_web_fun()
{
	echo [add_web_fun]
	
	cd $svn_NewWeb_pathway
	for filename in *
	do
		if [ $filename == $dcustomer ] || [ $filename == $xcustomer ] || [ $filename == $dxcustomer ];then
			export customerFlg=$filename
			echo $filename
			break
		else
			export customerFlg=Normal
		fi
	done
	
	cd $customerFlg
	number=0
	newWebName=web
	
	if test $UI_edition -eq 4;then
		yy=0
		for x in *
		do
			xflag=${x:7}
			xflag_3=${xflag%%_*}
			if [[ $xflag_3 == [0-9][0-9] ]];then
				if test $yy -le $xflag_3;then
					yy=$xflag_3
				fi
			fi
		done
		
		y=0
		for x in www-v1_"$yy"_*
		do
			xflag=${x:9}
			xflag_2=${xflag%%_*}
			if test $y -le $xflag_2;then
				y=$xflag_2
			fi
		done
		
		for newWeb in www-v1_"$yy"_"$y"_*
		do
			xflag=${newWeb:11}
			xflag_2=${xflag%%_*}
			if test $number -le $xflag_2;then
				number=$xflag_2
				newWebName=$newWeb
			fi
		done
	elif test $UI_edition -eq 5;then
		y=0
		for x in *
		do
			xflag=${x:9}
			xflag_2=${xflag%%_*}
			if [[ $xflag_2 == [0-9][0-9] ]];then
				if test $y -le $xflag_2;then
					y=$xflag_2
				fi
			fi
		done
		for newWeb in www-v2_0_"$y"*
		do
			newWebFlag=${newWeb:11}
			newWebFlag_1=${newWebFlag%%.*}
			newWebFlag_2=${newWebFlag_1%%_*}
			newWebLen=${#newWeb}
			if test $number -le $newWebFlag_2&&test $newWebLen -le 190;then
				number=$newWebFlag_2
				newWebName=$newWeb
			fi
		done
	fi
	
	echo $newWebName
	
	if [ $newWebName == web ];then
		echo "web error!!!"
		read key
	else
		rm -rf $svn_nfs_pathway/www*
		if [ -d $newWebName ];then
			cd $newWebName
			if [ -e "$newWebName"_no265_compression.zip ];then
				cp "$newWebName"_no265_compression.zip $svn_nfs_pathway
			elif [ -e "newWebName"_no265_compress.zip ];then
				cp "$newWebName"_no265_compress.zip $svn_nfs_pathway
			elif [ -e "newWebName"_no265.zip ];then
				cp "$newWebName"_no265.zip $svn_nfs_pathway
			else
				cp "$newWebName"* $svn_nfs_pathway
			fi
		else
			cp $newWebName $svn_nfs_pathway
		fi
	fi
}

www_fun()
{
	echo [www_fun]
	rm $tools_product_pathway/www_*
	cd $svn_nfs_pathway
	if [ -e www ];then
		rm www -rf
	fi
	unzip www-*
	if test $? -ne 0;then
		echo "unzip error!!!"
		read key
	fi
	if test $UI_edition -eq 5;then
		cd
		#cd 00/test
		rm version.h
		cp $svn_nfs_pathway/app/dvr/modules/pub/include/version.h ./
		if [ $customerFlg == Normal ];then
			customerID=23
		else
			./getIEout
			customerID=$(cat IEID.txt | grep IEID)
			customerID_0=${customerID#*=}
		fi
		cd -
	fi
	
	echo "customerID:"$customerID_0
	cd $svn_nfs_pathway/www/
	if [ $xproduct == normal ];then
		for www_name in *
		do
			if [ ${www_name%%_*} == images ];then
				echo $www_name
				if [ -e $www_name/LOGO ];then
					cd $www_name/LOGO
					mv LOGIN_c$customerID_0.png ../
					mv LOGO_c$customerID_0.png ../
					rm -rf *
					mv ../LOGIN_c$customerID_0.png ../LOGO_c$customerID_0.png ./
					cd ..
				else
					echo "www error!!!"
					exit 3
				fi
			fi
			
			if [ $www_name == lg ];then
				if [ -e $www_name/ENU.xml ];then
					cd $www_name
					mv ENU.xml ../
					rm -rf *
					mv ../ENU.xml ./
					cd ..
				fi
			fi
		done
	fi
	cd $svn_nfs_pathway
	chmod 777 www -R
	rm www_V*
	echo $currentDate
	mksquashfs www www_V$currentDate -comp xz
	mv www_V$currentDate $tools_product_pathway/
	rm -rf /home/lidongwei/nfs/www/*
	cp www/* /home/lidongwei/nfs/www/ -rf
}

logo_fun()
{
	echo [logo_fun]
	rm $tools_product_pathway/logo_*
	cd $svn_logo_pathway
	logoName="logo"
	for logo_name in *
	do
		#echo $logo_name
		if [ -d "$logo_name" ];then
			cd $logo_name
			for logo_name_0 in `ls`
			do
				if [ "$logo_name_0" == "$dcustomer.jpg" ] || [ "$logo_name_0" == "$xcustomer.jpg" ] || [ "$logo_name_0" == "$dxcustomer.jpg" ];then
					cp $logo_name_0 $tools_product_pathway/logo_V$currentDate
					logoName=$logo_name_0
				fi
			done
		else
			if [ "$logo_name" == "$dcustomer".jpg ] || [ "$logo_name" == "$xcustomer".jpg ] || [ "$logo_name" == "$dxcustomer.jpg" ];then
				cd $svn_logo_pathway
				cp $logo_name $tools_product_pathway/logo_V$currentDate -rf
				logoName=$logo_name
			fi
		fi
	done
	if [ logoName == logo ];then
		echo "Failed to get the logo!!!"
		read key
	fi
}

sdk_fun()
{
	echo [sdk_fun]
	cd $svn_sdk_pathway
	#uboot
	rm $tools_product_pathway/uboot_*
	if [ $product == D1104NR ] || [ $product == D1008NR ];then
		ubootname="uboot_V[0-9][0-9][0-9][0-9][0-9][0-9]_[0-9][0-9]M_20DV300"
	else
		ubootname="uboot_V[0-9][0-9][0-9][0-9][0-9][0-9] uboot_V[0-9][0-9][0-9][0-9][0-9][0-9]_[0-9][0-9]M "
	fi
	new_time_file_flg1=0
	for uboot_file in $ubootname
	do
		new_time_file_flg2=${uboot_file:7:6}
		if [[ $new_time_file_flg2 == [0-9]*[0-9] ]];then
			if test $new_time_file_flg2 -ge $new_time_file_flg1;then
				new_time_file_flg1=$new_time_file_flg2
				flashsize=${uboot_file:14:2}
				if [ $flashsize =  ] || [ $flashsize = 32 ];then
					flashsize=32 #如果uboot没有带大小的后缀则默认32M,有需要再修改
				fi
				if test $flashsize -eq $flash;then
					uboot_new_time_file=$uboot_file
				fi
			fi
		fi
	done
	cp $uboot_new_time_file $tools_product_pathway/
	
	#kernel
	rm $tools_product_pathway/kernel_*
	new_time_file_flg1=0
	for kernel_file in kernel_V[0-9][0-9][0-9][0-9][0-9][0-9]
	do
	new_time_file_flg2=${kernel_file:8:6}
	if test $new_time_file_flg2 -ge $new_time_file_flg1;then
		new_time_file_flg1=$new_time_file_flg2
		kernel_new_time_file=$kernel_file
	fi
	done
	cp $kernel_new_time_file $tools_product_pathway/
	
	#rootfs
	rm $tools_product_pathway/rootfs_*
	new_time_file_flg1=0
	for rootfs_file in rootfs_V[0-9][0-9][0-9][0-9][0-9][0-9]
	do
	new_time_file_flg2=${rootfs_file:8:6}
	if test $new_time_file_flg2 -ge $new_time_file_flg1;then
		new_time_file_flg1=$new_time_file_flg2
		rootfs_new_time_file=$rootfs_file
	fi
	done
	cp $rootfs_new_time_file $tools_product_pathway/
	#doc
	rm -rf $tools_product_pathway/doc
	mkdir $tools_product_pathway/doc -p
	if [ "$cproduct" = "D1116NR" ];then
		if test $flash -eq 16;then
			cp 31A_16M_readme.txt $tools_product_pathway/doc/
		elif test $flash -eq 32;then
			cp 31A_32M_readme.txt $tools_product_pathway/doc/
		fi
	elif [ "$cproduct" = "D1104NR" ];then
		if [ $flash == 16 ];then
			cp D1104NR_16M_readme.txt $tools_product_pathway/doc/
		else
			cp D1104NR_32M_readme.txt $tools_product_pathway/doc/
		fi
	elif [ "$cproduct" = "D2116NR" ]||[ "$cproduct" = "D1116" ]||[ "$cproduct" = "D2108" ]||\
	[ "$cproduct" = "D1132NR" ]||[ "$cproduct" = "D1124" ];then
		cp 31A_32M_readme.txt $tools_product_pathway/doc/
	elif [ $dcustomer == SWAN ]&&test $flash -eq 16;then
		cp D1104NR_16M_readme_swan.txt $tools_product_pathway/doc/
	elif [ "$cproduct" = "D1004NR" ]&&test $flash -eq 16;then
		cp D1004NR_16M_huohu_readme.txt $tools_product_pathway/doc/
	elif [ $product == D21DX ];then
		cp 21D_32M_readme.txt $tools_product_pathway/doc/
	elif [ $product == D31DX ];then
		cp 31D_32M_readme_2G.txt $tools_product_pathway/doc/
	elif [ $product == D31D-2CX ];then
		cp 31D_two_32M_readme_2G.txt $tools_product_pathway/doc/
	else
		cp "$cproduct"_"$flash"M_readme.txt $tools_product_pathway/doc/
		if test $? -eq 1;then
			echo "------------------------------------------------"
			echo "no xxx.txt,please add!"
			echo "Are you ok?"
			echo "------------------------------------------------"
			read key
		fi
	fi
		
	cd $tools_product_pathway
	uboot_name=${uboot_new_time_file:0:13}
	if [ $uboot_new_time_file != $uboot_name ];then
		mv $uboot_new_time_file $uboot_name
	fi
	cd $tools_product_pathway
	tree
	ls -ls
}

#处理Release文件(UI4.0)
custom_Release_UI4_fun()
{
	echo [custom_Release_UI4_fun]
	cd $gui_main_pathway/Release/
	dcustomer_flg=$dcustomer
	xcustomer_flg=$xcustomer
	if [ $dcustomer_flg == XVISION ];then
		dcustomer_flg=IQCCTV
	fi
	
	if [ $xcustomer_flg == defender ];then
		xcustomer_flg=Defender
	fi
	
	if [ $xcustomer_flg == samsung ];then
		xcustomer_flg=Samsung
	fi
	#language
	dcustomer_xxx=$dcustomer_flg
	if [ $dcustomer_xxx == CDOUBLES ];then
		dcustomer_xxx=CDoubles
	fi
	
	for name in language_*
	do
		name1=${name#*_*} #去掉第一个“_”及其前面的所有
		name2=${name1%%_*} #去掉第一个“_”及其后面的所有
		if [ $name2 == $dcustomer_xxx ]||[ $name2 == $xcustomer_flg ];then
			languagefflg=1
			echo $name
			mv language language_xxx
			mv $name language
			
			i=0
			for namelanguage in language/*
			do
				i=`expr $i + 1`
			done
			if test $i -le $languageNumFlg;then
				cp -rf language/* language_xxx/
				mv language language_aaa
				mv language_xxx language
				languagefflg=0
			fi
		fi
	done
	rm -rf language_*
	#images
	for name in images_*
	do
		name1=${name#*_*} #去掉第一个“_”及其前面的所有
		name2=${name1%%_*} #去掉第一个“_”及其后面的所有
		if [ $name2 == $dcustomer_flg ]||[ $name2 == $xcustomer_flg ];then
			echo $name
			mv images images_xxx
			mv $name images
		fi
	done
	
	cd image_startup_logo
	for name in *
	do
		name1=${name#*_*} #去掉第一个“_”及其前面的所有
		name2=${name1%%.*} #去掉第一个“.”及其后面的所有
		if [ $name2 == $dcustomer_flg ]||[ $name2 == $xcustomer_flg ];then
			echo $name
			if [ $name2 == COMMAX ];then
				cp wizard-startup-logo_COMMAX.png ../images/
			else
				mv $name wizard-startup-logo.png
				cp wizard-startup-logo.png ../images/
			fi
		fi
	done
	cd ..
	
	cd image_videoloss
	for name in *
	do
		name1=${name#*eo_*} #去掉第一个“eo_”及其前面的所有
		name2=${name1%%.*} #去掉第一个“.”及其后面的所有
		if [ $name2 == $dcustomer_flg ]||[ $name2 == $xcustomer_flg ];then
			echo $name
			mv $name no_video.png
			cp no_video.png ../images/
		fi
	done
	cd ..
	
	rm -rf images_*
	rm -rf image_*
	
	#style
	for name in style_*
	do
		name1=${name#*_*} #去掉第一个“_”及其前面的所有
		name2=${name1%%_*} #去掉第一个“_”及其后面的所有
		if [ $name2 == $dcustomer_flg ]||[ $name2 == $xcustomer_flg ];then
			echo $name
			mv style style_xxx
			mv $name style
		fi
	done
	rm -rf style_*
	rm custom-config.ini
}

product_patameters_fun()
{
	echo [product_patameters_fun]
	export PARASIZE=MAX_32
	export PLATFORM=HI3521A
	if [ $product = D1004NR ];then
		PLATFORM=HI-V100
		PARASIZE=MAX_32
	elif [ $product == D1008NR ] || [ $product == D1104NR ] ||\
	[ $product == D1104 ] || [ $product == D1108NR ] || [ $product == D2104NR ];then
		PLATFORM=HI3521A
		PARASIZE=MAX_32
		if test $UI_edition -eq 5;then
			PLATFORM=HI-V300A7
		fi
	elif [ $product == D1016NR ];then
		PLATFORM=HI3521A
		PARASIZE=MAX_64
		if test $UI_edition -eq 5;then
			PLATFORM=HI-V300A7
		fi
	elif [ $product == D2104 ] || [ $product == D2108NR ] || [ $product == D1108 ];then
		PLATFORM=HI3521A
		PARASIZE=MAX_64
		if test $UI_edition -eq 5;then
			PLATFORM=HI-V300A7
		fi
	elif [ $product == D1116NR ] || [ $product == D1032NR ];then
		PLATFORM=HI3531A
		PARASIZE=MAX_64
		if test $UI_edition -eq 5;then
			PLATFORM=HI-V300A9
		fi
	elif [ $product == D2116NR ] || [ $product == D1116 ] || [ $product == D2108 ] || [ $product == D1124 ];then
		PLATFORM=HI3531A
		PARASIZE=MAX_32
		if test $UI_edition -eq 5;then
			PLATFORM=HI-V300A9
		fi
	elif [ $product == D1132NR ];then
		PLATFORM=HI3531A
		PARASIZE=MAX_64
		if test $UI_edition -eq 5;then
			PLATFORM=HI-V300A9
		fi
	elif [ $product == D21DX ];then
		PLATFORM=HI3521D
		PARASIZE=MAX_32
		if test $UI_edition -eq 5;then
			PLATFORM=HI-V500A7
		fi
	elif [ $product == D31DX ];then
		PLATFORM=HI3531D
		PARASIZE=MAX_64
		if test $UI_edition -eq 5;then
			PLATFORM=HI-V500A9
		fi
	elif [ $product == D31D-2CX ];then
		PLATFORM=HI3531D
		PARASIZE=MAX_32
		if test $UI_edition -eq 5;then
			PLATFORM=HI-V500A9
		fi
	else
		echo "product error!!"
	fi
	echo $PLATFORM
	echo $PARASIZE
}

compile_Gui()
{
echo [bianyi_gui]
echo $PLATFORM
	cd $svn_nfs_pathway/gui
	make clean && make PLATFORM=$PLATFORM PARASIZE=$PARASIZE -j32
	cp Release/* $app_product_pathway -rf
	rm -rf /home/lidongwei/nfs/release/*
	cp $app_product_pathway/* /home/lidongwei/nfs/release/
}

compile_App()
{
	cd $svn_nfs_pathway/app/dvr/main
	make clean && make PRODUCT=$product -j32
	cp release/* $app_product_pathway -rf
	rm -rf /home/lidongwei/nfs/release/*
	cp $app_product_pathway/* /home/lidongwei/nfs/release/
}

compile_fun()
{
	product_patameters_fun
	echo [compile_fun]
	if test $compileApp -eq 1;then
		compile_App&
	fi
	if test $compileGui -eq 1;then
		compile_Gui
	fi
	wait
}

pack_fun()
{
	echo [pack_fun]
	cd $app_main_pathway
	chmod 777 * -R
	
	cproductfilename=`cat "$app_product_pathway"/custom-config.ini | grep UpgradePacketPreFix`
	cproductflg=${cproductfilename#*=*}
	export upgradePacketPreFix=${cproductflg%% *} #升级包包名前缀
	if [ -e app_* ];then
		rm app_*
	fi
	mksquashfs $app_product_pathway app_V"$currentDate"_"$upgradePacketPreFix"_M -comp xz
	mv app_V"$currentDate"_"$upgradePacketPreFix"_M tools/$rscproduct/
	cd tools/
	./gr.sh $upgradePacketPreFix
}

wait_fun()
{
	echo "waiting..."
	read key
	while [[ $key != "Y" ]]
	do
		echo "waiting..."
		read key
	done
}


export cproduct=$1
export customer=$2
export UI_edition=$3
export update_flag=0
export compileApp=1
export compileGui=1
export wwwflag=0
export sdkflag=0
export logoflag=0
if test $# -eq 4;then
	if test $4 -eq 1;then
		update_flag=1
		wwwflag=1
		sdkflag=1
		logoflag=1
	elif test $4 -eq 0;then
		compileApp=0
		compileGui=0
	elif [ $4 == app ];then
		echo "Compile the app..."
		compileGui=0
	elif [ $4 == gui ];then
		echo "Compile the gui..."
		compileApp=0
	elif [ $4 == sdk ];then
		sdkflag=1
	elif [ $4 == www ];then
		wwwflag=1
	elif [ $4 == logo ];then
		logoflag=1
	else
		echo "Parameter error!!!"
		exit 3
	fi
fi
export nowTime=`date +%y%m%d`
#常用路径
export svn_nfs_pathway="/home/lidongwei/nfs/20"$nowTime"_"$customer"_UI"$UI_edition".0"
export svn_logo_pathway="/home/lidongwei/svnwork/logo"
export svn_20D_sdk_pathway="/home/lidongwei/svnwork/sdk_image/Hi3520D/051_AHD_QT"
export svn_21A_sdk_pathway="/home/lidongwei/svnwork/sdk_image/Hi3521A/Hi3521A_050"
export svn_31A_sdk_pathway="/home/lidongwei/svnwork/sdk_image/Hi3531A/040"
export svn_31A_two_sdk_pathway="/home/lidongwei/svnwork/sdk_image/Hi3531A/040_two"
export svn_21D_sdk_pathway="/home/lidongwei/svnwork/sdk_image/Hi3521D/040"
export svn_31D_sdk_pathway="/home/lidongwei/svnwork/sdk_image/Hi3531D/040"
export svn_31D_two_sdk_pathway="/home/lidongwei/svnwork/sdk_image/Hi3531D/040_two"
export svn_NewWeb4_pathway="/home/lidongwei/svnwork/newWeb/DVR"
export svn_NewWeb5_pathway="/home/lidongwei/svnwork/newWeb/UI5.0/DVR"
export svn_NewWeb5_pathway_265="/home/lidongwei/svnwork/newWeb/UI5.0/DVR265"
export svn_code4_pathway="/home/lidongwei/svnwork/hybrid_tmp"
export svn_code5_pathway="/home/lidongwei/svnwork/hybrid_UI5.0"

product_manage_fun
init_fun
update_fun
prepare_pack_fun
custom_config_fun
if test wwwflag -eq 1;then
	add_web_fun
	www_fun
elif test logoflag -eq 1;then
	logo_fun
elif test sdkflag -eq 1;then
	sdk_fun
fi
wait_fun
compile_fun
pack_fun