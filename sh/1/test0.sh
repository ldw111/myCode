#!/bin/bash

svn_up_fun()
{
	svn up
	#svn up -r 16666
}

update()
{
	cd $svn_code_pathway
	svn_up_fun&
	wait
	
	cd $svn_logo_pathway
	svn up&
	wait
	
	cd $svn_sdk_pathway
	svn up&
	wait
	
	cd $svn_NewWeb_pathway
	svn up&
	wait
}

config_code()
{
	echo [update_code]
	cd /home/lidongwei/nfs
	if [[ -e $svn_nfs_pathway && $updateflag -eq 1 ]];then
		echo "Don't need to update"
	else
		#svn export $svn_code_pathway $dcustomer
		echo "The update is successful!"
	fi
}

para_manage_fun()
{
	echo [para_manage_fun]
	
}

lastBuildNumber=$(svn info | grep -w Rev | cut -d ' ' -f 4)
buildNumber=$(svn info | grep Revision | cut -d ' ' -f 2)

nowTime=`date +%y%m%d`
export product=$1
export dcustomer=$2
export UI_edition=$3


svn_nfs_pathway="/home/lidongwei/nfs/20"$nowTime"_"$dcustomer"_UI"$UI_edition".0"
svn_logo_pathway="/home/lidongwei/svnwork/logo"
svn_20D_sdk_pathway="/home/lidongwei/svnwork/sdk_image/Hi3520D/051_AHD_QT"
svn_21A_sdk_pathway="/home/lidongwei/svnwork/sdk_image/Hi3521A/Hi3521A_050"
svn_31A_sdk_pathway="/home/lidongwei/svnwork/sdk_image/Hi3531A/040"
svn_31A_two_sdk_pathway="/home/lidongwei/svnwork/sdk_image/Hi3531A/040_two"
svn_NewWeb4_pathway="/home/lidongwei/svnwork/newWeb/DVR"
svn_NewWeb5_pathway="/home/lidongwei/svnwork/newWeb/UI5.0/DVR"
svn_NewWeb5_pathway_265="/home/lidongwei/svnwork/newWeb/UI5.0/DVR265"
svn_code4_pathway_pathway="/home/lidongwei/svnwork/hybrid_tmp"
svn_code5_pathway="/home/lidongwei/svnwork/hybrid_UI5.0"
if test $UI_edition -eq 4;then
	svn_code_pathway=$svn_code4_pathway_pathway
elif test $UI_edition -eq 5;then
	svn_code_pathway=$svn_code5_pathway
else
	echo "UI edition error!!!(UI4.0/UI5.0)"
	exit 1
fi









