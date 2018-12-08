#!/bin/bash
#172.18.1.216
#codeFlg天内不使用新代码（0代表一天内的程序不更新服务器代码，可根据实际情况修改;按十进制来的，不是按月来的）
export 		      codeFlg=6660
#####################------返包什么的,由这些项互相配合使用------###################
#是否编译UI/APP，1-编译 0-不编译
export       	 bianyiUI=1
export      	bianyiAPP=1
#编译前是否先删除该型号的 release文件，1-删除 0-不删除(font、language和配置文件等都不会被自动处理了,需注意！！！)
export 	   appReleaseFlag=1
#是否需要重新获取IE包并压缩，1-更新，0-使用现有的
export       	 bianyiIE=0
if test $bianyiIE -eq 1;then
	#IE包获取，0-自动拿包，自动处理；1-手动拿包，自动处理（解压，删除无用文件）；2-手动拿包，手动处理（解压，删除无用文件）
	#自动处理的包需要赋值： webLanguage （IE语言默认只有英语，客户需求需要添加）
	export toObtainIE=0
fi
#只需要重新压app文件（修改配置文件,语言等，这些需要手动处理的项）
export 			  newBack=1
if test $newBack -eq 1;then
	bianyiUI=0
	bianyiAPP=0
	appReleaseFlag=0
	bianyiIE=0
fi
####################################################################################
#makeClean
export makeClean=1
#debug模式
export appdebugFlg=0
#是否带pos机编译
export posFlg=0
#是否带WIFI编译
export wifiFlg=0

#svn up
svn_up_fun()
{
	svn up
	#svn up -r 16412
}

#languageNumFlg为客户专用多国语言数目标记，少于这个数就加入中性多国语言
export languageNumFlg=2
#UI版本默认值UI4.0/UI5.0 (4 or 5)
export m_UI_edition=4
#语言默认值
export m_language=M

#编译线程数
export xc=32

#获取信息函数
get_information_fun()
{
echo [get_information_fun]
	CUSTOMER=NORMAL
	echo "**************************************************************"
	echo "usage: $0 [CUSTOMER] [PRODUCT] [LANGUAGE FLAG]"
	echo "CUSTOMER      : Neutral is NORMAL.(e:INDEXA)"
	echo "PRODUCT       : Complete product model.(e:D2108NH-NS)"
	echo "[UI_edition]  : The edition of the UI.(only 4 or 5)"
	echo "[LANGUAGE]    : M is multiLanguage, C is Chinese.(only M or C)"
	echo "**************************************************************"
	echo For example :
	echo "$0 $CUSTOMER D2108NH-NS"
	echo or
	echo "$0 $CUSTOMER D2108NH-NS [4(5)] [M(C)]"
	echo "**************************************************************"
}
#参数检查函数
parameter_limits_fun()
{
echo [parameter_limits_fun]
	customerl=${#customer} #客户名长度
	productl=${#product} #产品型号名长度
	productD=${product:0:1} #产品型号名的第一个字母
	
	if test $UI_edition -eq 5;then
		UI_edition=5
	else
		UI_edition=$m_UI_edition
	fi
	
	if [ $language == 'C' ]||[ $language == 'c' ];then
		language=C
	else
		language=$m_language
	fi
	
	if test $flg -lt 2;then
		get_information_fun
		echo "The execution parameter is less than 3!"
		exit 1
	elif test $customerl -lt 1;then
		get_information_fun
		echo "Customer name error!"
		exit 1
	elif test $productl -lt 5;then
		get_information_fun
		echo "productl error!"
		exit 1
	elif [ $productD != D ];then
		get_information_fun
		echo "productD error!"
		exit 1
	fi
}
#是否使用新代码
new_or_old_code_fun()
{
echo [new_or_old_code_fun]
export nowTime=`date +%y%m%d` #当前客户时间
export nowTimeT=$nowTime #最新时间
export new_code_flg=0 #是否是同一客户的标记
name_time=0
name_time_flag=0
	cd /home/lidongwei/nfs/
	for name in *
	do
		name_flg=${name#*_*}
		if [ $name_flg = $dcustomer"_UI"$UI_edition".0" ];then
			name_time_flag=$name_time
			name_time=${name:2:6}
			time_difference=`expr $nowTime - $name_time`
			if test $time_difference -le $codeFlg;then
				new_code_flg=1
				if test $name_time -ge $name_time_flag;then
					nowTime=$name_time
				else
					nowTime=$name_time_flag
				fi
			fi
			
			for buildNum in $name/a_*
			do
				buildNumFlg=${buildNum#*a_*}
				export buildNumber=$buildNumFlg #构建号
			done
		fi
	done
	
	if test $new_code_flg -eq 0;then
		echo "---------------"
		echo "\"New code!\""
		echo "---------------"
	else
		echo "---------------"
		echo "\"Old code!\""
		echo "---------------"
	fi
}
#参数处理函数
cproduct_manage_fun()
{
#方便烧录app
rm /home/lidongwei/nfs/20180999_IE/app_V*
rm /home/lidongwei/nfs/20180999_IE/*.txt

echo [cproduct_manage_fun]
export Nflog=0 #0为实时，1为非实时
export Sflog=0 #0为不带报警，1为带报警
export flash=16 #flash大小
export isHR=0  #是否为HR外观的机型，且不带ESATA的，只有一个硬盘不带盘组
	num=$product
	num1=${num#*-*} #去掉第一个“-”及其前面的所有
	#num2=${num1%%-*} #去掉第一个“-”及其后面的所有
	num3=${num1/N/Y} #将num1中的“N”用“Y”替换
	num4=${num1/S/Y} #将num1中的“S”用“Y”替换
	num5=${num1/F/Y} #将num1中的“F”用“Y”替换
	num6=${num1/E/Y} #将num1中的“E”用“Y”替换
	HRflag=${num:5:2} #从第5个开始取num的2个字符（注意下标是从0开始的）
export cproduct=${num:0:5} #从第一个开始取num五个字符（注意下标是从0开始的）

	if [ $num1 != $num3 ];then
		cproduct=${cproduct}"NR"
		Nflog=1
	fi
	
	if [ $num1 != $num4 ];then
		Sflog=1
	fi
	
	if [ $num1 != $num5 ];then
		flash=32
	fi
	
	if [ $HRflag == HR ]&&[ $num1 == $num6 ];then
		isHR=1
	fi
	
	if [ $cproduct == D1124 ]||[ $cproduct == D1124NR ];then
		cproduct=D1124
	fi
	
export rscproduct=RS_$cproduct
	
export dcustomer=$(echo $customer | tr '[a-z]' '[A-Z]') #大写的客户名
export xcustomer=$(echo $customer | tr '[A-Z]' '[a-z]') #小写的客户名
	
	frist=${customer:0:1}
	dfrist=$(echo $frist | tr '[a-z]' '[A-Z]') #转大写
export dxcustomer="$dfrist""${xcustomer:1}" #第一个字母大写其余小写的客户名
	
	new_or_old_code_fun
}
#打包准备工作,包括更新服务器代码、创建工作目录等
prepare_pack_fun()
{
echo [prepare_pack_fun]
	if test $new_code_flg -eq 0;then
		cd $svn_code_pathway
		if test $UI_edition -eq 4;then
			echo "---------------"
			echo "\"UI4.0!\""
			echo "---------------"
			echo "Update..."
			svn_up_fun
export buildNumber=`svn info | grep Revision | cut -d ' ' -f 2` #构建号
			mkdir $svn_nfs_pathway/a_$buildNumber -p
			echo "Export..."
			svn export app $svn_nfs_pathway/a_$buildNumber/app
			svn export gui-4.0 $svn_nfs_pathway/a_$buildNumber/gui

		elif test $UI_edition -eq 5;then
			echo "---------------"
			echo "\"UI5.0!\""
			echo "---------------"
			echo "Update..."
			svn_up_fun
export buildNumber=`svn info | grep Revision | cut -d ' ' -f 2` #构建号
			mkdir $svn_nfs_pathway/a_$buildNumber -p
			echo "Export..."
			svn export APP $svn_nfs_pathway/a_$buildNumber/app
			svn export GUI $svn_nfs_pathway/a_$buildNumber/gui
		fi
		
		#http库
			#cd ../core_lib/
			#svn up
			#cd -
			ln -s /home/lidongwei/svnwork/core_lib $svn_nfs_pathway/
		#开客户宏
		if [ $dcustomer != NORMAL ];then
			cd $svn_nfs_pathway/a_$buildNumber/app/dvr/modules/pub/include/
			kehuhong="#define $dcustomer"
			sed -i "3a ${kehuhong}" version.h
			cd $svn_nfs_pathway/a_$buildNumber/gui/src/Adapter
			sed -i "2a ${kehuhong}" customconfig.h
			cd $svn_code_pathway
		fi
	fi

	export app_main_pathway=""$svn_nfs_pathway"/"a_$buildNumber"/app/dvr/main" #main路径
	export gui_pathway=""$svn_nfs_pathway"/"a_$buildNumber"/gui" #gui路径

	if test $newBack -eq 0 && test $bianyiUI -eq 0 && test $bianyiAPP -eq 0 && test $appReleaseFlag -eq 0;then
		rm $app_main_pathway/app_V*
		cp $app_main_pathway/tools/$rscproduct/app_V* $app_main_pathway/
	fi
	
export oldProduct=0
	cd $app_main_pathway/tools/
		for pfile in `ls`
		do
			if [ "$pfile" == "$rscproduct" ];then
				oldProduct=1
			fi
		done
		
		if test $oldProduct -eq 0;then
			mkdir $rscproduct -p
		else
			rm $rscproduct/www_*
			rm $rscproduct/logo_*
			rm $rscproduct/app_*
		fi
	cd -
	
	rm -rf $svn_nfs_pathway/$product
	mkdir $svn_nfs_pathway/$product -p
	
	
	export client_product_pathway=$svn_nfs_pathway/$product
	export app_product_pathway=$app_main_pathway/$product
	export tools_product_pathway=$app_main_pathway/tools/$rscproduct
	
	release=0
	if test $appReleaseFlag -eq 0;then
		cd $app_main_pathway
		for filename in `ls`
		do
			if [ $filename == $product ];then
				release=1
			fi
		done
		if test $release -eq 0;then
			appReleaseFlag=1
		fi
		cd -
	fi
	
	if test $appReleaseFlag -eq 1;then
		rm -rf $app_main_pathway/$product
		mkdir $app_main_pathway/$product -p
		
		cproductFlg=$cproduct
		name=xxx
		if [ $dcustomer == NORMAL ];then
			name=standard
		elif [ $dcustomer == CDOUBLES ];then
			name=CDoubles
		fi
		
		cp $app_main_pathway/tools/config/$name/$cproductFlg/custom-config.ini $app_product_pathway/
		if test $? -eq 1;then
			cp $app_main_pathway/tools/config/$dcustomer/$cproductFlg/custom-config.ini $app_product_pathway/
			if test $? -eq 1;then
				cp $app_main_pathway/tools/config/$xcustomer/$cproductFlg/custom-config.ini $app_product_pathway/
				if test $? -eq 1;then
					cp $app_main_pathway/tools/config/standard/$cproductFlg/custom-config.ini $app_product_pathway/
					echo "-------------------------------"
					echo "custom-config.ini is NORMAL！"
					echo "Are you sure?"
					echo "-------------------------------"
					read key
				fi
			fi
		fi
		
	fi
	
	rm -rf $app_main_pathway/tools/RS_N*
}
#修改配置文件
custom_config_fun()
{
echo [custom_config_fun]
	cd $app_product_pathway/
	#修改时间
	appDisplayVer=`cat "$app_product_pathway"/custom-config.ini | grep AppDisplayVer`
	appDisplayVerFlg=${appDisplayVer:23:6}
	sed -i "s/"$appDisplayVerFlg"/"$nowTimeT"/g" custom-config.ini
	appUpdataVer=`cat "$app_product_pathway"/custom-config.ini | grep AppUpdataVer`
	appUpdataVerFlg=${appUpdataVer:14:6}
	sed -i "s/"$appUpdataVerFlg"/"$nowTimeT"/g" custom-config.ini
	logoVersion=`cat "$app_product_pathway"/custom-config.ini | grep LogoVersion`
	logoVersionFlg=${logoVersion:13:6}
	sed -i "s/"$logoVersionFlg"/"$nowTimeT"/g" custom-config.ini
	iEVersion=`cat "$app_product_pathway"/custom-config.ini | grep IEVersion`
	iEVersionFlg=${iEVersion:11:6}
	sed -i "s/"$iEVersionFlg"/"$nowTimeT"/g" custom-config.ini
	#修改升级包包名前缀
	upgradePacketPreFixName=`cat "$app_product_pathway"/custom-config.ini | grep UpgradePacketPreFix`
	upgradePacketPreFixFlg1=${upgradePacketPreFixName%% *} #升级包包名前缀
	upgradePacketPreFixFlg2=${upgradePacketPreFixFlg1#*-*}
	if test $flash -eq 32;then
		if test $upgradePacketPreFixFlg2 -eq 16||test $upgradePacketPreFixFlg2 -eq 32||\
		[ "$cproduct" == "D2104NR" ]||[ "$cproduct" == "D2108NR" ];then
			upgradePacketPreFixFlg3="UpgradePacketPreFix=""$cproduct"-32""
			sed -i "s/"$upgradePacketPreFixFlg1"/"$upgradePacketPreFixFlg3"/g" custom-config.ini
		fi
	fi
	#不带报警处理
	if test $Sflog -eq 0;then
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
	if [ $language == C ];then
		sed -i "s/"IELangMask=16"/"IELangMask=1"/g" custom-config.ini
		sed -i "s/"IELanguage=4"/"IELanguage=0"/g" custom-config.ini
		sed -i "s/"Language=4"/"Language=0"/g" custom-config.ini
	fi
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
	
	if test $isHR -eq 1;then
		sed -i "s/"DiskGroupEnable=1"/"DiskGroupEnable=0"/g" custom-config.ini
	fi
	
	
	cd -
}
#获取配置文件时间
custom_config_time_fun()
{
echo [custom_config_time_fun]
	cd $app_product_pathway/
	appDisplayVer=`cat "$app_product_pathway"/custom-config.ini | grep AppDisplayVer`
	appDisplayVerFlg=${appDisplayVer:23:6}
	nowTimeT=$appDisplayVerFlg
	if test $UI_edition -eq 5;then
		echo
	else
		IECustom=`cat "$app_product_pathway"/custom-config.ini | grep IECustom`
		IECustom_2=${IECustom%% *}
export IECustom_3=${IECustom_2#*=*}
	fi
	cd -
}
#拿IE包
add_web_fun()
{
echo [add_web_fun]
	oldPathway=`pwd`
	NewWebPathway=$svn_NewWeb_pathway/DVR
	if test $UI_edition -eq 5;then
		NewWebPathway=$svn_NewWeb_pathway/UI5.0/DVR
	fi
	cd $NewWebPathway
	svn up #--username lidongwei --password 111111
export customerFlag=Normal
	for fileName in *
	do
		if [ $fileName == $dcustomer ]||[ $fileName == $xcustomer ]||[ $fileName == $dxcustomer ];then
			customerFlag=$fileName
		fi
	done
	cd $customerFlag
	number=0
	newWebName=web
	if test $UI_edition -eq 4;then
		yy=0
		for x in *
		do
			xfalg=${x:7}
			xfalg_3=${xfalg%%_*}
			echo $xfalg_3
			if test $yy -le $xfalg_3;then
				yy=$xfalg_3
			fi
		done
		
		y=0
		for x in www-v1_"$yy"_*
		do
			xfalg=${x:9}
			xfalg_2=${xfalg%%_*}
			if test $y -le $xfalg_2;then
				y=$xfalg_2
			fi
		done
		for newWeb in www-v1_"$yy"_"$y"*
		do
			newWebFlag=${newWeb:11}
			newWebFlag_2=${newWebFlag%%_*}
			if test $number -le $newWebFlag_2;then
				number=$newWebFlag_2
				newWebName=$newWeb
			fi
		done
	elif test $UI_edition -eq 5;then
		y=0
		for x in *
		do
			xfalg=${x:9}
			xfalg_2=${xfalg%%_*}
			if test $y -le $xfalg_2;then
				y=$xfalg_2
			fi
		done
		for newWeb in www-v2_0_$y*
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
		
	if [ $newWebName == web ];then
		echo "web error!!!Please handle...1"
		read y
	else
		rm -rf $svn_nfs_pathway/www*
		cd $newWebName
		if test $? -eq 1;then
			cp "$newWebName" $svn_nfs_pathway
			if test $? -eq 1;then
				echo "web error!!!Please handle...2"
				read y
			fi
			echo -------------------------------
			IEpwd=`pwd`
			echo $newWebName
			echo -------------------------------
		else
			newWebNameflag=$newWebName
			if test $UI_edition -eq 5;then
				newWebNameflag="$newWebName"_no265
				newWebName="$newWebName"_no265_
			fi
			cp "$newWebName"compression.zip $svn_nfs_pathway
			if test $? -eq 1;then
				cp "$newWebName"compress.zip $svn_nfs_pathway
				if test $? -eq 1;then
					newWebName=$newWebNameflag
					cp "$newWebName".zip $svn_nfs_pathway
					if test $? -eq 1;then
						echo "web error!!!Please handle...3"
						read y
					else
						echo -------------------------------
						IEpwd=`pwd`
						echo "$newWebName".zip
						echo -------------------------------
					fi
				else
					echo -------------------------------
					IEpwd=`pwd`
					echo "$newWebName"compress.zip
					echo -------------------------------
				fi
			else
				echo -------------------------------
				IEpwd=`pwd`
				echo "$newWebName"compression.zip
				echo -------------------------------
			fi
		fi
	fi
	cd $oldPathway
}
#www文件处理
www_fun()
{
echo [www_fun]
	
	oldPathway=`pwd`
	cd $svn_nfs_pathway
	if test $toObtainIE -eq 2;then
		echo
	else
		rm www -rf
		unzip www-*
		if test $? -eq 1;then
			echo "unzip error!!!"
			exit 1
		fi
	fi
	
	if [ $customerFlag == Normal ]||test $toObtainIE -eq 1;then
		#获取客户数组编号
		if test $UI_edition -eq 5;then
			oldPathway_2=`pwd`
			cd /home/lidongwei/svnwork/sdk_image/LHP/
			rm version.h
			cp $svn_nfs_pathway/a_$buildNumber/app/dvr/modules/pub/include/version.h .
			sed -i "s/"include"/"define"/g" version.h
			sed -i "s/"\"commondefine.h\""/"LHP"/g" version.h
			rm getIEout IEID.txt
			gcc getIE.c -o getIEout
			./getIEout
			IEID=`cat IEID.txt | grep IEID`
			IECustom_3=${IEID#*=*}
			cd $oldPathway_2
		fi
		echo "---------------------"
		echo IEID=$IECustom_3
		echo "---------------------"
		
		cd www/images_black/LOGO
		if test $? -eq 1;then
			echo "cd www error!!!"
			exit 1
		fi
		for login in LOGIN_c*
		do
			loginName=${login#*_c*}
			loginName_2=${loginName%%.*}
			if test $loginName_2 -eq $IECustom_3;then
				echo $login
				cp "$login"* ../../
			fi
		done
		for logo in LOGO_c*
		do
			logoName=${logo#*_c*}
			logoName_2=${logoName%%.*}
			if test $logoName_2 -eq $IECustom_3;then
				echo $logo
				cp "$logo"* ../../
			fi
		done
		rm -rf ./*
		cd ../../
		mv *.png images_black/LOGO/
		mv *.svg images_black/LOGO/
		
		webLanguage="ENU.xml"
		if [ $dcustomer == ART ];then
			webLanguage="ENU.xml TUR.xml"
		elif [ $dcustomer == RCI ];then
			webLanguage="ENU.xml RUS.xml"
		fi
		cd lg
		cp $webLanguage ../
		rm -rf ./*
		cd ../
		mv $webLanguage lg/
	fi
	
	if test $UI_edition -eq 5;then
		cd $svn_nfs_pathway/www/images_black
		rm -rf tile*
	fi
	
	cd $svn_nfs_pathway
	chmod 777 www -R
	rm www_V*
	mksquashfs www www_V$nowTimeT -comp xz
	
	cd $oldPathway
}
#准备IE包和logo
IE_logo_fun()
{
echo [IE_logo_fun]
	
export IEpwd=xxx
	#IE包
	cd $svn_nfs_pathway/
	if test $bianyiIE -eq 0;then
		flag=0
		for i in www_V*
		do
			flag=1
		done
		if test $flag -eq 0;then
			bianyiIE=1
		fi
	fi
	if test $bianyiIE -eq 1;then
		if [ $dcustomer == URMET ];then
			toObtainIE=2
		fi
		if test $toObtainIE -eq 0&&[ $cproduct != D1004NR ]&&[ $cproduct != D1004 ];then
			add_web_fun
		else
			echo "------------------------------------------------"
			echo "Please put the IE package in this directory:"
			echo $svn_nfs_pathway/
			echo "Are you ready?"
			echo "------------------------------------------------"
			rm -rf www*
			read key
		fi
		www_fun
	else
		mv www_V* www_V$nowTimeT
	fi
	
	#logo包
	cd $svn_nfs_pathway/
	if test $new_code_flg -eq 0;then
		if [ $dcustomer == NORMAL ];then
			if [ $language == C ];then
				cp $svn_logo_pathway/system_chs.jpg .
			else
				cp $svn_logo_pathway/system_eng.jpg .
			fi
		else
			if [ $dcustomer == SUNELL ];then
				cp $svn_logo_pathway/SUNELL_new.jpg .
			else
				cp $svn_logo_pathway/$dcustomer.jpg .
				if test $? -eq 1;then
					cp $svn_logo_pathway/$xcustomer.jpg .
					if test $? -eq 1;then
						cp $svn_logo_pathway/$dcustomer.JPG .
						if test $? -eq 1;then
							cp $svn_logo_pathway/$xcustomer.JPG .
						fi
					fi
				fi
			fi
			echo "------------------------------------------------"
			echo "A failure is ok,two failures are a problem."
			echo "------------------------------------------------"
		fi
		
		IE_logo_flg2=NO
		for i in `ls`
		do
			if [ $i == system_chs.jpg ];then
				IE_logo_flg2=YES
			elif [ $i == system_eng.jpg ];then
				IE_logo_flg2=YES
			elif [ $i == SUNELL_new.jpg ];then
				IE_logo_flg2=YES
			elif [ $i == $dcustomer.jpg ];then
				IE_logo_flg2=YES
			elif [ $i == $xcustomer.jpg ];then
				IE_logo_flg2=YES
			elif [ $i == $dcustomer.JPG ];then
				IE_logo_flg2=YES
			elif [ $i == $xcustomer.JPG ];then
				IE_logo_flg2=YES
			fi
		done
		
		if [ $IE_logo_flg2 == YES ];then
			mv *.jpg logo_V$nowTimeT
			if test $? -eq 1;then
				mv *.JPG logo_V$nowTimeT
			fi
		else
			echo "------------------------------------------------"
			echo "logo errer,Please manually add!!!"
			echo "Are you ready?"
			echo "------------------------------------------------"
			read key
			mv *.jpg logo_V$nowTimeT
			if test $? -eq 1;then
				mv *.JPG logo_V$nowTimeT
			fi
		fi
	else
		mv logo_V* logo_V$nowTimeT
	fi
	
	cp www_V* $tools_product_pathway/
	cp logo_V* $tools_product_pathway/
}
#确定芯片型号及编译参数大小
product_parameters_fun()
{
echo [product_parameters_fun]
export PLATFORM=A
export PARASIZE=B
export HI3521A_flg=0 #21A还是20DV300
export HI3531A_flg=0 #单片还是双片
	if [ "$cproduct" = "D1004NR" ];then
		PLATFORM=HI-V100
		PARASIZE=MAX_32
	#21A平台 32路
	elif [ "$cproduct" = "D1008NR" ]||[ "$cproduct" = "D1104NR" ]||[ "$cproduct" = "D1104" ]||\
		  [ "$cproduct" = "D1108NR" ]||[ "$cproduct" = "D2104NR" ];then
		PLATFORM=HI3521A
		PARASIZE=MAX_32
		if [ "$cproduct" = "D1008NR" ]||[ "$cproduct" = "D1104NR" ];then
			HI3521A_flg=1 #20DV300
		fi
	#21A平台 64路
	elif [ "$cproduct" = "D1016NR" ];then
		PLATFORM=HI3521A
		PARASIZE=MAX_64
	#单片31A 32路
	elif [ "$cproduct" = "D2104" ]||[ "$cproduct" = "D2108NR" ]||[ "$cproduct" = "D1108" ];then
		PLATFORM=HI3531A
		PARASIZE=MAX_32
		HI3531A_flg=1
	#单片31A 64路
	elif [ "$cproduct" = "D1116NR" ]||[ "$cproduct" = "D1032NR" ];then
		PLATFORM=HI3531A
		PARASIZE=MAX_64
		HI3531A_flg=1
	#双片31A 32路
	elif [ "$cproduct" = "D2116NR" ]||[ "$cproduct" = "D1116" ]||[ "$cproduct" = "D2108" ]||[ "$cproduct" = "D1124" ];then
		PLATFORM=HI3531A
		PARASIZE=MAX_32
		HI3531A_flg=2
		flash=32
	#双片31A 64路
	elif [ "$cproduct" = "D1132NR" ];then
		PLATFORM=HI3531A
		PARASIZE=MAX_64
		HI3531A_flg=2
		flash=32
	else
		echo "product_parameters_fun error!please enter..."
		echo "PLATFORM="
		read PLATFORM
		echo "PARASIZE="
		read PARASIZE
		if [ $PLATFORM = HI3531A ];then
			echo "HI3531A_flg=(1 or 2)"
			read HI3531A_flg
		fi
	fi
	echo "PLATFORM="$PLATFORM",PARASIZE="$PARASIZE""
}
#拿sdk_image包
sdk_image_fun()
{
echo [sdk_image_fun]
	product_parameters_fun
	sdkOKflag=0
	if [ $PLATFORM = HI-V100 ];then
		echo $svn_20D_sdk_pathway
		cd $svn_20D_sdk_pathway
	elif [ $PLATFORM = HI3521A ];then
		if test $UI_edition -eq 5;then
			PLATFORM=HI-V300A7
		fi
		echo $svn_21A_sdk_pathway
		cd $svn_21A_sdk_pathway
	elif [ $PLATFORM = HI3531A ]&&test $HI3531A_flg -eq 1;then
		if test $UI_edition -eq 5;then
			PLATFORM=HI-V300A9
		fi
		echo $svn_31A_sdk_pathway
		cd $svn_31A_sdk_pathway
	elif [ $PLATFORM = HI3531A ]&&test $HI3531A_flg -eq 2;then
		if test $UI_edition -eq 5;then
			PLATFORM=HI-V300A9
		fi
		echo $svn_31A_two_sdk_pathway
		cd $svn_31A_two_sdk_pathway
	else
		sdkOKflag=1
		echo "------------------------------------------------"
		echo "sdk_image_fun update failed!!!"
		echo "Please update manually!"
		echo "Are you ready?"
		echo "------------------------------------------------"
		read key
	fi
	
	if test $sdkOKflag -eq 0 && test $oldProduct -eq 0;then
		echo sdk updating...
		svn up
	#uboot
		if test $HI3521A_flg -eq 1;then
			ubootname="uboot_V[0-9][0-9][0-9][0-9][0-9][0-9]_[0-9][0-9]M_20DV300"
		else
			ubootname="uboot_V[0-9][0-9][0-9][0-9][0-9][0-9]_[0-9][0-9]M uboot_V[0-9][0-9][0-9][0-9][0-9][0-9]"
		fi
	new_time_file_flg1=0
		for uboot_file in $ubootname
		do
			new_time_file_flg2=${uboot_file:7:6}
			if test $new_time_file_flg2 -ge $new_time_file_flg1;then
				new_time_file_flg1=$new_time_file_flg2
				flashsize=${uboot_file:14:2}
				if [ $flashsize =  ];then
					flashsize=32 #如果uboot没有带大小的后缀则默认32M,有需要再修改
				fi
				if test $flashsize -eq $flash;then
					uboot_new_time_file=$uboot_file
				fi
			fi
		done
		echo "It doesn't matter if you make a mistake here!"
		cp $uboot_new_time_file $tools_product_pathway/
	#kernel
	new_time_file_flg1=0
		for kernel_file in rootfs_V[0-9][0-9][0-9][0-9][0-9][0-9]
		do
		new_time_file_flg2=${kernel_file:8:6}
		if test $new_time_file_flg2 -ge $new_time_file_flg1;then
			new_time_file_flg1=$new_time_file_flg2
			kernel_new_time_file=$kernel_file
		fi
		done
		cp $kernel_new_time_file $tools_product_pathway/
	#rootfs
	new_time_file_flg1=0
		for rootfs_file in kernel_V[0-9][0-9][0-9][0-9][0-9][0-9]
		do
		new_time_file_flg2=${rootfs_file:8:6}
		if test $new_time_file_flg2 -ge $new_time_file_flg1;then
			new_time_file_flg1=$new_time_file_flg2
			rootfs_new_time_file=$rootfs_file
		fi
		done
		cp $rootfs_new_time_file $tools_product_pathway/
	#doc
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
	fi
	cd $tools_product_pathway
	tree
	ls -ls
}
#处理Release文件(UI4.0)
custom_Release_UI4_fun()
{
echo [custom_Release_UI4_fun]
	languagefflg=0 #0为中性语言，1为客户专用语言
	dcustomer_flg=$dcustomer
	xcustomer_flg=$xcustomer
	if test	$new_code_flg -eq 0;then

		if [ $dcustomer_flg == XVISION ];then
			dcustomer_flg=IQCCTV
		fi
		
		if [ $xcustomer_flg == defender ];then
			xcustomer_flg=Defender
		fi
		
		if [ $xcustomer_flg == samsung ];then
			xcustomer_flg=Samsung
		fi

		cd $gui_pathway/Release/
	#images文件夹处理
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
	#language文件夹处理
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
	#style文件夹处理
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
	fi
	
#font、language文件内容的处理
	if test $appReleaseFlag -eq 1;then
		cp -rf $gui_pathway/Release/* $app_product_pathway/
		cd $app_product_pathway/
		#font
		if test $flash -eq 16;then
			if [ $dcustomer_flg == DAAPLER ];then
				mv font/arial_bnazanin_gothic_unicode_19_50.qpf2 .
				rm -rf font/*
				mv arial_bnazanin_gothic_unicode_19_50.qpf2 font/
			elif [ $language == C ];then
				mv font/yahei_arial_gothic_unicode_19_50_[zh-cn]_[english].qpf2 font/syszuxpinyin .
				rm -rf font/*
				mv yahei_arial_gothic_unicode_19_50_[zh-cn]_[english].qpf2 syszuxpinyin font/
				mv font/yahei_arial_gothic_unicode_19_50_[zh-cn]_[english].qpf2 font/yahei_arial_gothic_unicode_19_50.qpf2
			else
				mv font/yahei_arial_gothic_unicode_19_50.qpf2 .
				rm -rf font/*
				mv yahei_arial_gothic_unicode_19_50.qpf2 font/
			fi
		elif test $flash -eq 32;then
			if [ $dcustomer_flg == DAAPLER ];then
				mv font/arial_bnazanin_gothic_unicode_19_50.qpf2 .
				rm -rf font/*.qpf2
				mv arial_bnazanin_gothic_unicode_19_50.qpf2 font/
			else
				if [ $dcustomer_flg == URMET ]||[ $dcustomer_flg == VC ];then #URMET客户程序32M程序用16M字库
					mv font/yahei_arial_gothic_unicode_19_50.qpf2 .
					rm -rf font/*
					mv yahei_arial_gothic_unicode_19_50.qpf2 font/
				else
					mv font/yahei_arial_gothic_unicode_19_50_32M.qpf2 .
					rm -rf font/*.qpf2
					mv yahei_arial_gothic_unicode_19_50_32M.qpf2 font/
					mv font/yahei_arial_gothic_unicode_19_50_32M.qpf2 font/yahei_arial_gothic_unicode_19_50.qpf2
				fi
			fi
		fi
		#language
		cd $app_product_pathway/language/
		#保留专用客户语言（中性语言包）
		for name in *
		do
			nameflg1=${name#*_*}
			nameflg2=${nameflg1#*_*}
			nameflg3=${nameflg2%%.*}
			nameflg4=${name%%_*}
			nameflg5=${nameflg1%%_*}
			if [ $nameflg3 == $dcustomer ]||[ $nameflg3 == $xcustomer ];then
				rm ""$nameflg4"_"$nameflg5".xml"
				mv $name ""$nameflg4"_"$nameflg5".xml"
			fi
		done
		#language小于17国语言默认为专用语言
		for languagenum in *
		do
			i=`expr $i + 1`
			if [ $languagenum == tran_korean.xml ];then
				rm tran_korean_32M.xml
			elif [ $languagenum == tran_japanese.xml ];then
				rm tran_japanese_32M.xml
			elif [ $languagenum == tran_chinese_complex.xml ];then
				rm tran_chinese_complex_32M.xml
			fi
		done
		if test $i -lt 17;then
			languagefflg=1
		fi
		#多余语言处理
		if test $languagefflg -eq 0;then
			language_16M="tran_arabic_* tran_chinese.xml tran_chinese_complex* tran_persion_* \
							tran_german_* tran_italian_* tran_japanese* tran_korean* \
							tran_polish_* tran_russian_* tran_turkey_* tran_vietnam.xml \
							tran_holland_* tran_spanish_* tran_english_* tran_french_* tran_svenska_* \
							tran_thai_*"
			language_32M="tran_arabic_* tran_chinese.xml tran_chinese_complex_* \
							tran_german_* tran_italian_* tran_japanese_* tran_persion_* \
							tran_polish_* tran_russian_* tran_turkey_* tran_vietnam.xml \
							tran_holland_* tran_spanish_* tran_english_* tran_french_* tran_korean_* tran_svenska_* \
							tran_thai_*"
			mv tran_chinese_complex_32M.xml tran_chinese_complex.xml
			mv tran_japanese_32M.xml tran_japanese.xml
			mv tran_korean_32M.xml tran_korean.xml
			if [ $language == C ];then
				mv tran_chinese.xml ../
				rm *
				mv ../tran_chinese.xml .
			else
				if test $flash -eq 32;then
					if [ $dcustomer_flg == "SMARTEYE" ];then
						cp tran_vietnam.xml ../
						rm $language_32M
						mv ../tran_vietnam.xml .
					else
						rm $language_32M
					fi
				else
					if [ $dcustomer_flg == "SMARTEYE" ];then
						cp tran_vietnam.xml ../
						rm $language_16M
						mv ../tran_vietnam.xml .
					else
						rm $language_16M
					fi
				fi
			fi
		else
			if test $flash -eq 16;then
				rm tran_chinese_complex* tran_japanese* tran_korean*
			else
				mv tran_chinese_complex_32M.xml tran_chinese_complex.xml
				mv tran_japanese_32M.xml tran_japanese.xml
				mv tran_korean_32M.xml tran_korean.xml
			fi
		fi
		#URMET客户需要添加播放器
		if [ $dcustomer == URMET ]||[ $dcustomer == VC ];then
			if test $flash -eq 32;then
				cp $app_main_pathway/tools/Player/* $app_product_pathway/
			fi
		fi
	fi
}
#处理Release文件(UI5.0)
custom_Release_UI5_fun()
{
echo [custom_Release_UI5_fun]
	languagefflg=0 #0为中性语言，1为客户专用语言
	dcustomer_flg=$dcustomer
	xcustomer_flg=$xcustomer
#各文件夹的处理
	if test	$new_code_flg -eq 0;then
		cd $gui_pathway/Release/
	#language文件夹处理
		for name in language_*
		do
			name1=${name#*_*} #去掉第一个“_”及其前面的所有
			name2=${name1%%_*} #去掉第一个“_”及其后面的所有
			if [ $name2 == $dcustomer_flg ]||[ $name2 == $xcustomer_flg ];then
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
	#images文件夹处理
		imagesFlag=0
		imagesNameFlag=images_5-0
		dcustomer_flg_flag=$dcustomer_flg
		if [ $dcustomer_flg_flag == IQCCTV ];then
			dcustomer_flg_flag=REDLINE
		fi
		if [ $dcustomer_flg == ART ] || [ $dcustomer_flg == ALTE ] || [ $dcustomer_flg == URMET ];then
			imagesNameFlag=images_5-2
		fi
		for name in "$imagesNameFlag"_*
		do
		if [ $dcustomer_flg == ART ] || [ $dcustomer_flg == ALTE ] || [ $dcustomer_flg == URMET ];then
			name1=${name#*2_*} #去掉第一个“2_”及其前面的所有
		else
			name1=${name#*0_*} #去掉第一个“0_”及其前面的所有
		fi
			name2=${name1%%_*} #去掉第一个“_”及其后面的所有
			if [ $name2 == $dcustomer_flg_flag ]||[ $name2 == $xcustomer_flg ];then
				imagesFlag=1
				echo $name
				rm -rf images
				mv $name images
			fi
		done
		if test $imagesFlag -eq 0;then
			rm -rf images
			mv $imagesNameFlag images
		fi
		
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
		
		cd image_welcome
		for name in *
		do
			name1=${name#*_*} #去掉第一个“_”及其前面的所有
			name2=${name1%%.*} #去掉第一个“.”及其后面的所有
			if [ $name2 == $dcustomer_flg ]||[ $name2 == $xcustomer_flg ];then
				echo $name
				mv $name wizard-welcome.png
				cp wizard-welcome.png ../images/
			fi
		done
		cd ..
		
		rm -rf images_*
		rm -rf image_*
	#style文件夹处理
		styleFlag=0
		styleNameFlag=style_5-0
		if [ $dcustomer_flg == ART ] || [ $dcustomer_flg == ALTE ] || [ $dcustomer_flg == URMET ];then
			styleNameFlag=style_5-2
		fi
		for name in "$styleNameFlag"_*
		do
		if [ $dcustomer_flg == ART ] || [ $dcustomer_flg == ALTE ] || [ $dcustomer_flg == URMET ];then
			name1=${name#*2_*} #去掉第一个“2_”及其前面的所有
		else
			name1=${name#*0_*} #去掉第一个“0_”及其前面的所有
		fi
			name2=${name1%%_*} #去掉第一个“_”及其后面的所有
			if [ $name2 == $dcustomer_flg ]||[ $name2 == $xcustomer_flg ];then
				styleFlag=1
				echo $name
				rm -rf style
				mv $name style
			fi
		done
		if test $styleFlag -eq 0;then
			rm -rf style
			mv $styleNameFlag style
		fi
		rm -rf style_*
	fi
	
#font、language文件内容的处理
	if test $appReleaseFlag -eq 1;then
		cp -rf $gui_pathway/Release/* $app_product_pathway/
		cd $app_product_pathway/
		#font
		cd font
		if test $flash -eq 16;then
			if [ $language == M ];then
				mv yahei_arial_gothic_unicode[no-cjk].ttf ../
				rm -rf ./*
				mv ../yahei_arial_gothic_unicode[no-cjk].ttf .
				mv yahei_arial_gothic_unicode[no-cjk].ttf yahei_arial_gothic_unicode.ttf
			elif [ $language == C ];then
				if [ $dcustomer_flg == SMARTEYE ];then
					mv yahei_arial_gothic_unicode[vietnam].ttf syszuxpinyin ../
					rm -rf ./*
					mv ../yahei_arial_gothic_unicode[vietnam].ttf ../syszuxpinyin .
					mv yahei_arial_gothic_unicode[vietnam].ttf yahei_arial_gothic_unicode.ttf
				else
				mv yahei_arial_gothic_unicode[en-chs].ttf syszuxpinyin ../
				rm -rf ./*
				mv ../yahei_arial_gothic_unicode[en-chs].ttf ../syszuxpinyin .
				mv yahei_arial_gothic_unicode[en-chs].ttf yahei_arial_gothic_unicode.ttf
				fi
			fi
		elif test $flash -eq 32;then
			if [ $dcustomer_flg == IQCCTV ] && test $wifiFlg -eq 1;then
				mv yahei_arial_gothic_unicode[no-cjk].ttf ../
				rm -rf ./*
				mv ../yahei_arial_gothic_unicode[no-cjk].ttf .
				mv yahei_arial_gothic_unicode[no-cjk].ttf yahei_arial_gothic_unicode.ttf
			else
				mv yahei_arial_gothic_unicode[full]_32M.ttf syszuxpinyin ../
				rm -rf ./*
				mv ../yahei_arial_gothic_unicode[full]_32M.ttf ../syszuxpinyin .
				mv yahei_arial_gothic_unicode[full]_32M.ttf yahei_arial_gothic_unicode.ttf
			fi
		fi
		cd ..
		#language
		cd language
		#保留专用客户语言（中性语言包）
		for name in *
		do
			nameflg1=${name#*_*}
			nameflg2=${nameflg1#*_*}
			nameflg3=${nameflg2%%.*}
			nameflg4=${name%%_*}
			nameflg5=${nameflg1%%_*}
			if [ $nameflg3 == $dcustomer_flg ]||[ $nameflg3 == $xcustomer_flg ];then
				rm ""$nameflg4"_"$nameflg5".xml"
				mv $name ""$nameflg4"_"$nameflg5".xml"
			fi
		done
		#language小于17国语言默认为专用语言
		for languagenum in *
		do
			i=`expr $i + 1`
			if [ $languagenum == tran_korean.xml ];then
				rm tran_korean_*
			elif [ $languagenum == tran_japanese.xml ];then
				rm tran_japanese_*
			elif [ $languagenum == tran_chinese_complex.xml ];then
				rm tran_chinese_complex_*
			fi
		done
		if test $i -lt 17;then
			languagefflg=1
		fi
		#多余语言处理
		if test $languagefflg -eq 0;then
			language_16M="tran_arabic_* tran_chinese.xml tran_chinese_complex* tran_persion_* \
							tran_german_* tran_italian_* tran_japanese* tran_korean* \
							tran_polish_* tran_russian_* tran_turkey_* tran_vietnam* \
							tran_holland_* tran_spanish_* tran_english_* tran_french_* tran_svenska_* \
							tran_thai_*"
			language_32M="tran_arabic_* tran_chinese.xml tran_chinese_complex_* \
							tran_german_* tran_italian_* tran_japanese_* tran_persion_* \
							tran_polish_* tran_russian_* tran_turkey_* tran_vietnam* \
							tran_holland_* tran_spanish_* tran_english_* tran_french_* tran_korean_* tran_svenska_* \
							tran_thai_*"
			mv tran_chinese_complex_32M.xml tran_chinese_complex.xml
			mv tran_japanese_32M.xml tran_japanese.xml
			mv tran_korean_32M.xml tran_korean.xml
			if [ $language == C ];then
				mv tran_chinese.xml ../
				rm *
				mv ../tran_chinese.xml .
			else
				if test $flash -eq 32;then
					if [ $dcustomer_flg == "SMARTEYE" ];then
						cp tran_vietnam.xml ../
						rm $language_32M
						mv ../tran_vietnam.xml .
					else
						rm $language_32M
					fi
				else
					if [ $dcustomer_flg == "SMARTEYE" ];then
						cp tran_vietnam.xml ../
						rm $language_16M
						mv ../tran_vietnam.xml .
					else
						rm $language_16M
					fi
				fi
			fi
		else
			if test $flash -eq 16;then
				rm tran_chinese_complex* tran_japanese* tran_korean*
			else
				mv tran_chinese_complex_32M.xml tran_chinese_complex.xml
				mv tran_japanese_32M.xml tran_japanese.xml
				mv tran_korean_32M.xml tran_korean.xml
			fi
		fi
		cd ..
	fi
}
#编译检查
compile_the_inspection_fun()
{
echo [compile_the_inspection_fun]

	uiAppFlag=$1
	uiAppName="raysharp-hdvr-ui"
	uiAppNameError="compiling  UI error!!!"
	if test $uiAppFlag -eq 0;then
		cd Release/
		uiAppName="raysharp-hdvr-ui"
		uiAppNameError="compiling  UI error!!!"
	elif test $uiAppFlag -eq 1;then
		cd release/
		uiAppName="raysharp_dvr"
		uiAppNameError="compiling  APP error!!!"
	else
		echo "compile_the_inspection_fun error!!!"
		exit 1
	fi
	
	errorFlag=0
	for name in *
	do
		if [ $name == $uiAppName ];then
			errorFlag=1
		fi
	done
	if test $errorFlag -eq 0;then
		echo "-----------------------------------------"
		echo $uiAppNameError
		echo "-----------------------------------------"
		exit 1
	else
		cd ..
	fi
}
#ui和app的编译
compile_ui_app_fun()
{
echo [compile_ui_app_fun]

#处理release文件
if test $UI_edition -eq 4;then
	custom_Release_UI4_fun
elif test $UI_edition -eq 5;then
	custom_Release_UI5_fun
fi

#准备工作完毕，请检查，修改需求代码，编译
	cd $svn_nfs_pathway
	cd ..
	chmod 777 *
	cd $svn_nfs_pathway
	chmod 777 * -R
	compilingUI="make -j"$xc" PLATFORM="$PLATFORM" PARASIZE="$PARASIZE""
	if test $posFlg -eq 1;then
		compilingAPP="make -j"$xc" PRODUCT="$cproduct" SUPPORT_POS=TRUE"
	elif [ $dcustomer == SATVISION ];then
		compilingAPP="make -j"$xc" PRODUCT="$cproduct" CUSTOM=SATVISION"
	elif [ $dcustomer == AVENTURA ];then
		compilingAPP="make -j"$xc" PRODUCT="$cproduct" CUSTOM=AVENTURA"
	elif test $wifiFlg -eq 1;then
		if [ $dcustomer == IQCCTV ];then
			compilingAPP="make -j"$xc" PRODUCT="$cproduct" WIFI=SUPPORT avbr=true 3G=SUPPORT"
		else
			compilingAPP="make -j"$xc" PRODUCT="$cproduct" WIFI=SUPPORT"
		fi
	elif test $appdebugFlg -eq 1;then
		compilingAPP="make -j"$xc" PRODUCT="$cproduct" debug=1"
	else
		compilingAPP="make -j"$xc" PRODUCT="$cproduct""
	fi
	if [ $dcustomer != NORMAL ];then
		if test $bianyiUI -eq 1 || test $bianyiAPP -eq 1;then
			echo "-----------------------------------------------------------------------"
			echo "Preparatory work completed!"
			echo "Please handle [configuration.ini], [languages], and [code changes]!!"
			echo "compiling  UI: "$compilingUI""
			echo "compiling APP: "$compilingAPP""
			echo "Can you start compiling? make clean(1/0)"
			echo "-----------------------------------------------------------------------"
			read makeClean
			if test $makeClean -eq 0;then
				echo
			else
				makeClean=1
			fi
		fi
	fi
#编译ui
	cd $gui_pathway/
	if test $bianyiUI -eq 1;then
		rm Release/raysharp-hdvr-ui
		if test $makeClean -eq 1;then
			make clean
		fi
		
		eval $compilingAPP
		compile_the_inspection_fun 0
		
		cp -rf Release/lib Release/raysharp-hdvr-ui ../app/dvr/main/$product/
	elif test $appReleaseFlag -eq 1;then
		#注意这里拿的ui是上一次编译生成的，要确认下
		cp -rf Release/lib Release/raysharp-hdvr-ui ../app/dvr/main/$product/
	fi
#编译app
	cd $app_main_pathway/
	if test $bianyiAPP -eq 1;then
		rm -rf release/lib release/raysharp-hdvr-ui
		mkdir release/lib -p
		rm raysharp_dvr
		rm release/raysharp_dvr
		if test $makeClean -eq 1;then
			make clean
		fi
		
		eval $compilingAPP
		compile_the_inspection_fun 1

		cp -rf release/* $app_product_pathway/
	
		if [ $dcustomer != BALTER ]&&[ $dcustomer != GM_PLATFORM ]&&[ $dcustomer != CLOUD_INTELLIGENCE ]&&\
		[ $dcustomer != GM ]&&[ $dcustomer != CLOUD ]&&[ $dcustomer != PLATFORM ]&&[ $dcustomer != INTELLIGENCE ]&&\
		[ $dcustomer != VC ];then
			rm -rf $app_product_pathway/start_webserv
		fi
	elif test $appReleaseFlag -eq 1;then
		#注意这里拿的app是上一次编译生成的，要确认下
		rm -rf release/lib release/raysharp-hdvr-ui
		cp -rf release/* $app_product_pathway/
		
		if [ $dcustomer != BALTER ]&&[ $dcustomer != GM_PLATFORM ]&&[ $dcustomer != CLOUD_INTELLIGENCE ]&&\
		[ $dcustomer != GM ]&&[ $dcustomer != CLOUD ]&&[ $dcustomer != PLATFORM ]&&[ $dcustomer != INTELLIGENCE ]&&\
		[ $dcustomer != VC ];then
			rm -rf $app_product_pathway/start_webserv
		fi
	fi
	#read yuaaaaaaaa
#压包
	cd $app_main_pathway/
	cproductfilename=`cat "$app_product_pathway"/custom-config.ini | grep UpgradePacketPreFix`
	cproductflg=${cproductfilename#*=*}
	export upgradePacketPreFix=${cproductflg%% *} #升级包包名前缀
	
#	if test $wifiFlg -eq 1;then
#		cd $product/lib
#		rm libnl-genl.so.2
#		rm libnl.so.2
#		ln -s libnl-genl.so.2.0.0 libnl-genl.so.2
#		ln -s libnl.so.2.0.0 libnl.so.2
#		cd -
#	fi
	
	if [ $cproduct == "D1004NR" ];then
		cd $product/;arm-hisiv100nptl-linux-strip raysharp-hdvr-ui;cd ..
	else
		cd $product/;arm-hisiv300-linux-strip raysharp-hdvr-ui;cd ..
	fi
	
	if test $newBack -eq 0 && test $bianyiUI -eq 0 && test $bianyiAPP -eq 0 && test $appReleaseFlag -eq 0;then
		echo "--------------------------"
		echo "app is old!"
		echo "--------------------------"
	else
		if [ $language == C ];then
			rm app_V*
			mksquashfs $product app_V"$nowTimeT"_"$upgradePacketPreFix"_C -comp xz
		else
			rm app_V*
			mksquashfs $product app_V"$nowTimeT"_"$upgradePacketPreFix"_M -comp xz
		fi
	fi
#方便烧录app
cp app_V* /home/lidongwei/nfs/20180999_IE/
cp tools/$rscproduct/doc/*.txt /home/lidongwei/nfs/20180999_IE/
	
	mv app_V* tools/$rscproduct/
	cd tools/genrelease_src/;make clean;make;cd ..
	./gr.sh $upgradePacketPreFix
	cp -rf hdvrupgrade $rscproduct $client_product_pathway/
	
	cd $client_product_pathway/
	mv $rscproduct image
	
	tree
	cd image
	ls -ls
	
	echo "compiling  UI: "$compilingUI""
	echo "compiling APP: "$compilingAPP""
	echo "IE Path: "$IEpwd""
	echo game over!
	exit 1
}
#打包
pack_fun()
{
echo [pack_fun]
	prepare_pack_fun
	if test $appReleaseFlag -eq 1;then
		#修改配置文件
		custom_config_fun
	elif test $appReleaseFlag -eq 0;then
		#获取配置文件里面时间
		custom_config_time_fun
	fi
	IE_logo_fun
	sdk_image_fun
	compile_ui_app_fun
}

#输入的参数
export flg=`echo $#`
export customer=$1
export product=$2
export UI_edition=$3
export language=$4

#参数检测
parameter_limits_fun

#参数处理
cproduct_manage_fun

#一些用到的固定路径
export svn_nfs_pathway="/home/lidongwei/nfs/20"$nowTime"_"$dcustomer"_UI"$UI_edition".0"
export svn_logo_pathway="/home/lidongwei/svnwork/logo"
export svn_20D_sdk_pathway="/home/lidongwei/svnwork/sdk_image/Hi3520D/051_AHD_QT"
export svn_21A_sdk_pathway="/home/lidongwei/svnwork/sdk_image/Hi3521A/Hi3521A_050"
export svn_31A_sdk_pathway="/home/lidongwei/svnwork/sdk_image/Hi3531A/040"
export svn_31A_two_sdk_pathway="/home/lidongwei/svnwork/sdk_image/Hi3531A/040_two"
export svn_NewWeb_pathway="/home/lidongwei/svnwork/newWeb"

if test $UI_edition -eq 4;then
	export svn_code_pathway="/home/lidongwei/svnwork/hybrid_tmp"
elif test $UI_edition -eq 5;then
	export svn_code_pathway="/home/lidongwei/svnwork/hybrid_UI5.0"
else
	echo "UI edition error!!!(UI4.0/UI5.0)"
	exit 1
fi



#打包
pack_fun





