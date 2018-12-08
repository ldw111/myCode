
#ifndef __VERSION_H__
#define __VERSION_H__

#define LHP

/***************************************************
	    客户订制 选择<至多选1 项, 不选为中性>
 ***************************************************/
//#define RAYSHARP
//#define Q_SEE
//#define OWL
//#define ZMODO
//#define COP
//#define KGUARD
//#define SOYO
//#define SWANN
//#define URMET
//#define LOREX
//#define J2000
//#define BOLIDE
//#define SECURITY
//#define DAYS30
//#define PANDA
//#define PROTECTRON
//#define DEAPA
//#define ZENON
//#define FLIR
//#define HIVIEW
//#define ELKRON
//#define ALPHATECH
//#define HONEYWELL
//#define GTC
//#define VIDEOTECNOLOGIE
//#define VC
//#define DEFENDER
//#define IQCCTV
//#define BRIGHT
//#define THOMSON
//#define SAMSUNG_IPC
//#define SUPPORTED_PROTO  0x15   /* open samsung protocol*/
//#define  ZHUOWEI_IPC
//#define SUPPORTED_PROTO  273  /*按位取PROTO_TYPE_E*/
//#define NOVUS
//#define SAMSUNG
//#define DENAVO
//#define ITEX
//#define CDOUBLES 
//#define LG
//#define DAAPLER
//#define VDCARE
//#define BASCOM
//#define BALTER
//#define RCI
//#define LEGRAND
//#define COMMAX
//#define LUXVISION
//#define INDEXA
//#define CARROT
//#define RAYDIN
//#define ABC_PROJECT/*农行项目*/
//#define PINETRON
//#define REDLINE
#define MERX
//#define LUX
//#define BPL
//#define WISENET
//#define VALUETOP
//#define APRO
//#define SMARTVIEW
//#define SMARTEYE
//#define GOLMAR
//#define MAXXONE
//#define ART
//#define TOASTCAM
//#define SUPERVISION
//#define OPTIMUS
//#define CUBITECH
//#define TOP
//#define ACURA
//#define LIVEZON

/*******************************************************
	                   系统信息
 ******************************************************/
#define APP_VER_OF_DISPLAY   	"V8.1.0-20180211"	/*UI 上显示的版本号*/
#define APP_VER_OF_UPDATA   	        "V180211"	/*系统升级时需要校验的版本号*/
#define LOGO_VER			            "V180211"
#define IE_VER_OF_UPDATA                "V180211"

/*******************************************************
	                 功能编译开关
*******************************************************/
/*区别是纯DVR还是混合DVR*/
//#define DVR_NO_IPC  

/*开启多用户的时候开机使用默认用户登录*/
#define DEFAULT_USER_LOGIN  

/*安联V2云存储*/
#if defined(OWL) || defined(LG) || defined(DEFENDER) || defined(TELETEK)
#else
    #define CLOUDSTORAGEV2
#endif

/*支持通用的扩展分区*/
#define EXTEND_HDD_PARTITION

/* 邮件发送测试 */
#define EMAIL_TEST

/* DDNS测试 */
#define DDNS_TEST

#define PTZ_AD_CONVER

/*new web server*/
#define MINI_HTTP_SERVER

//#define PIR_FOR_BEJIIN_2016 /*北京展样机使用*/
#if defined(PIR_FOR_BEJIIN_2016)
	#define PIR_MOTION
#endif

#if defined(D1008) || defined(D1004)
	#define AHD_EQ_DETECT_NO_VI_AUTO_DETECT /* 与VI_AUTO_DETECT 互斥*/
#endif

/*
  * VO 设备使用RS_VO_PART_MODE_SINGLE 模式(并且使用vpss), 解决最大视频分屏数受硬件限制
  * (比如: RS_VO_PART_MODE_MULTI 模式只能有16 分屏, 但RS_VO_PART_MODE_SINGLE 模式可以有32 分屏)
  */
#if defined(D1016NR)
	#define USE_VO_PART_MODE_SINGLE_AND_VPSS
#endif

/* 改变码流分辨率不重启编码通道, 减少mmz 的内存碎片*/
#if defined(D1108NR) || defined(D1104NR) || defined(D1104) || defined(D1108)
	#define MEDIA_DYNAMIC_CHANGE_VE_RES
#endif

/*EQ开关控制宏*/
#if defined(D9904) || defined(D9904NR) || defined(D9908) || defined(D9908NR) || defined(D9908AHD) || \
	defined(D9916NR) || defined(D9916NRAHD) || defined(D1104) || defined(D1108NR) || defined(D1008) || \
	defined(D1008NR) || defined(D1004) || defined(D1104NR) || defined(D1116NR) || defined(D1032NR) || \
	defined(D1016NR) || defined(D1004NR) || defined(D1108) || defined(D1116) || defined(D1124) || \
	defined(D1132NR) || defined(D2108NR) || defined(D2104NR) || defined(D2116NR) || defined(D2108) || \
	defined(D2104) || defined(D1116P) || defined(D3108NR) || defined(D3104NR) || defined(D3116NR)
	#if !defined(OWL)
	#define AHDEQ_CONTROL
	#endif
#endif

/*新型号采用备份关键区存取参数*/
/*ui5.0全部打开*/
#define SUPPORT_NEW_RWPARAM_METHOD

#if defined(SUPPORT_NEW_RWPARAM_METHOD) && defined(HI)
#define CAMERA_SETUP
#endif

/*超级密码生成新规则(用户名+时间日期+MAC地址)*/
#if !defined(BALTER)
	#define NEW_SUPPERUSERPASSWORK
#endif

/* 按小时覆盖 */
//#define DEL_REC_BY_HOUR

//#define SUPPORT_UI4_1    /* 海康界面的控制宏  */

/*DVD 刻录*/
#define DVD_CDRECORD

/*支持E-SATA录像*/
#if defined(N5004) || defined(N5004N) || defined(N5104) || defined(N5104N) || defined(N5008) || defined(N5008N)\
        || defined(N5208E) || defined(N5208EN) || defined(N5016) || defined(N5016N) || defined(N5216) || defined(N5216N)\
        || defined(N5316) || defined(N5316N) || defined(N5032) || defined(N5032N) || defined(N5032P) || defined(N5032PN)\
        || defined(N5332) || defined(N5332N) || defined(N5332P) || defined(N5332PN)
    #define ESATA_RECORD
#endif

/*非实时机型跳帧*/
//#define SUPPORT_JUMP_FRAME

/*主码流根据vi 来改变*/ 
#if !defined(OWL)
#define MODE_CHANGE_WHEN_RESTART_VI
#endif

#if defined(OWL) || defined(LG)
#elif defined(SUPPORT_NEW_RWPARAM_METHOD)
/*支持N/P  制枪机盲插*/
#define AUTO_DETECT_CHN_VIDEO_FORMAT
#endif

#if !defined(OWL)
/*支持多国OSD*/
//#define OSD_SUPPORT_MULIT_LANGUAGE
#endif
  
//矢量字库
#define OSD_SUPPORT_VECTOR_FONT

/* D1132NR 支持32编32解,不支持1080P及以上分辨率枪机*/
//#define MAX_32ENC_AND_DEC_720P 
   
//波斯历显示
//#define HUI_LI  

/*备份自带播放器*/
//#define COPY_PLAYER

/*支持将播放器导入到硬盘，需同时开启COPY_PLAYER*/
//#define PLAYER_IMPORT

/*客户端日志搜索功能*/
//#define REMOTE_SEARCH_LOG

/*VGA 做SPOT输出的功能*/
//#define VGA_SPOT

#if defined(SUPPORT_NEW_RWPARAM_METHOD)
#define CAMERA_TYPE /*目前只有AD芯片为2823C和2853C支持*/
#endif

/*修改录像结束时间不准的问题*/
#define MODIFY_END_TIME

/* 2016-06-20 支持DST1 DST2显示，按写入时间排序*/
/* 2016-07-22 屏蔽该宏，并且改回硬盘文件系统，排序方式仍按照录像文件的时间排序*/
//#define NEW_DST_SHOW_AND_RECORD_SORT

/*新邮件机制*/
#define NEW_EMAIL

#if defined(D3104NR) || defined(D3108NR) || defined(D3116NR)
	#define ANALOG_SUPPORT_H265
	#define SUPPORT_RECORD_MODE_CHANGE
#endif

/*鼠标中键滚动电子放大*/
#if !defined(SWANN) && !defined(OWL) && !defined(SAMSUNG) && !defined(LOREX)
    #define USE_NEW_ZOOM_METHOD
#endif

#if defined(D2104NR) || defined(D2108NR) || defined(D2116NR) || defined(D2104) || defined(D2108) || \
	defined(D3104NR) || defined(D3108NR) || defined(D3116NR)
	/*子码流增加VGA分辨率UI也有该宏*/
	//#define SUBSTREAM_SUPPORT_VGA
	/*模拟通道支持智能分析*/
	#define SUPPORT_ANALOG_ALG
	/*子码流支持D1和432*320分辨率*/
	#define SUBSTREAM_MULTIPLE_RES
	/*VGA 做SPOT输出的功能*/
	#if defined(CUBITECH) && defined(D2104NR)
	#else
		#define VGA_SPOT
	#endif
#else
	//#define SUBSTREAM_SUPPORT_VGA
	//#define SUBSTREAM_MULTIPLE_RES
	//#define SUPPORT_ANALOG_ALG
#endif

/*新RTSP机制*/
#define NEW_RTSP

/*采用CRC校验系统参数区*/
#define CRC_CHECK_SYSTEM_PARAM

/*提供给工厂进行U盘直接升级*/
//#define WORKSHOP_UDISK_OPERATOR

/*提供给工厂进行U盘的格式化硬盘与恢复出厂设置*/
//#define WORKSHOP_UDISK_OPERATOR

/*硬盘S.M.A.R.T.检测功能开关*/
#if !defined(WISENET) && !defined(IQCCTV)
#define ENABLE_DISK_SMART
#endif

/*POS机功能*/
//#define ENABLE_POS

/*PIR枪机识别*/
//#define PIR_MOTION

/*超级密码生成新规则(用户名+时间日期+MAC地址)*/
//#define NEW_SUPPERUSERPASSWORK

/*动态录像(触发motion或I/O报警时,以UI上最大编码参数录像)*/
//#define ACT_MOTION_REC

/*录像回放抓拍*/
#define PLAYBACK_CAPTURE

#if defined(N5004N) ||defined(N5008N) ||defined(N5016N) ||defined(N5032N) ||\
	defined(N5104N) ||defined(N5208N) ||defined(N5216N) ||defined(N5232N) ||\
	defined(N5316N) ||defined(N5332N) ||defined(N5016PN)||defined(N5032PN)||\
    defined(N5316PN)||defined(N5332PN)||defined(N6708) ||defined(N5208EN)
	/*鱼眼模式:NVR型号加了N后缀的，表示flash类型为NAND，需用到glibc库*/
    #define FISHEYE_MODE
	/*双目*/
	//#define BINOCULARS
#endif

/*红外侦测PIR功能*/
#if !defined(H1104W) && !defined(N5004) && !defined(N5004N) && !defined(N5008) &&\
    !defined(N5008N) && !defined(N5016) && !defined(N5016N) && !defined(N5016P) &&\
    !defined(N5016PN) && !defined(N5032) && !defined(N5032N) && !defined(N5032P) &&\
    !defined(N5032PN) && !defined(N5104) && !defined(N5104N) && !defined(N5208E) &&\
    !defined(N5208EN) && !defined(N5216) && !defined(N5216N) && !defined(N5316) &&\
    !defined(N5316N) && !defined(N5316P) && !defined(N5316PN) && !defined(N5332) &&\
    !defined(N5332N) && !defined(N5332P) && !defined(N5332PN) && !defined(N6004) &&\
    !defined(N6008) && !defined(N6104) && !defined(N6208) && !defined(N6708) &&\
    !defined(N6816) && !defined(N4XXX) && !defined(N5464N) && !defined(N57XX)
#define SUPPORTED_NORMAL_PIR
#endif

/*USB DONGLE*/
//#define WIFI_CONNECTOR

/*可添加多通道设备*/
//#define MULTICHANNEL 

/*在录像搜索时，是否搜索M与I的交集部分*/
//#define MO_AND_IO_INTERSECTION

//#define EVENT_STREAM  //该报警碼流功能不能与ACT_MOTION_REC功能同时开启

/*机器起来后判断输出分辨率与显示器支持的最高分辨率是否一致,UI也需要打开此功能宏*/
#define CONFIG_MONITOR_RESOLUTION

//#define SUPPORT_REMOTE_DESKTOP   //远程桌面TEAMVIEWER功能

/*亚马逊IOT功能*/
//#define SUPPORT_AWS_IOT

/* 数字通道支持smart motion功能，注意IPC也需要支持才可以搜索出录像 */
//#define SMART_SEARCH_FOR_DIGITAL
/*******************************************************
	                 客户特有功能或参数定制
 ******************************************************/
#if defined(RAYSHARP)/**********RAYSHARP客户**********/
	//#define DDNS_ANLIAN
	#define UI_LANG_MASK			0x1
	#define UI_LANG_EXTEND_MASK 	0x0
	#define UI_CUR_LANG 			0
	#define IE_LANG_MASK			0x1
	#define IE_CUR_LANG 			0
	#define IE_CUSTOM				4
	#define IE_LOGO				    4
	
#elif defined(Q_SEE)/**********Q_SEE客户**********/
	#define DDNS_QSEE
	
#elif defined(OWL)/**********OWL客户**********/
	#define DDNS_OWL
	#define PUSH_HOST_DOMAIN

	#define MANUFACTURER "Night Owl"

	#define DVR_NO_IPC  //纯DVR
	//#define P2P_SOFTWARE_OWL_OWNS_NOT_RS
	//#define OWL_DEMO //OWL 广告机视频
#if defined(OWL_DEMO)
#if defined(D1008NR)
	#define DEMO_DEFAULT_CHN_NAME
#endif
#if defined(D1004NR)
	//#define DEFAULT_DEMO_VIDEO_NAME_IS_DKIT_CL_HDA84_720
#endif
#endif
	//#define PIR_MOTION
	//#define OWL_FTP_PATH "NVR10-8CH-A"
	//#define MOTION_AUTO_ON

#elif defined(ZMODO)/**********ZMODO客户**********/

#elif defined(COP)/**********COP客户**********/
	#define DDNS_COP
	#define DDNS_ANLIAN

#elif defined(KGUARD)/**********KGUARD客户**********/
	#define SONIX_IPC
	#define SUPPORTED_PROTO 0x2011
	
	#define NEW_FTP_AUTO_UPGRADE
	/*PUSH EVENT*/
	#define PUSH_EVENT

	#define DDNS_KGUARD
	#define MANUFACTURER "KGUARD"
	#define MODE_CHANGE_WHEN_RESTART_VI   /*主码流根据vi 来改变*/
#elif defined(SOYO)/**********SOYO客户**********/
	
#elif defined(SWANN)/**********SWANN客户**********/
	#define DDNS_SWANN
	#define EXIT_ASK_SAVE			//退出页面提示保存功能
	#define DHCP_REFRESH			//DHCP手动刷新功能
	#define MOUSE_SENSITIVITY		//鼠标灵敏度设置
	#define SUB_STREAM_SET_RULE		//子码流设置规则
	#define MAX_TOTAL_SUB_FPS_PAL  ((MAX_SYSTEM_CHN_NUM- 1)*5 + 25)
	#define MAX_TOTAL_SUB_FPS_NTSC ((MAX_SYSTEM_CHN_NUM - 1)*6 + 30)
	#define DVR_NO_IPC
	#define WORKSHOP_UDISK_OPERATOR
	#define ENABLE_DISK_SMART
#elif defined(URMET)       /**********URMET客户*********/
	/* RSSP*/
	//#define RSSP_OF_URMET
	/*DDNS_URMET*/
	#define DDNS_URMET
	#define ENCODE_ENABLE/*IE 加密开关*/
	#define URMET_IPC
	#define SUPPORTED_PROTO 0x131 /*按位取PROTO_TYPE_E*/
	#define ZHUOWEI_IPC
	#define CUSTOM_PROTOCOL
	#define DEL_REC_BY_HOUR
#elif defined(ELKRON)      /*********ELKRON客户**********/
	/* RSSP*/
	#define RSSP_OF_URMET
#elif defined(LOREX)/**********LOREX客户**********/
	#define DDNS_LOREX
	/*LOREX_P2P功能*/
	#define SUPPORT_LOREX_P2P
	
#elif defined(FLIR)	
	#define DDNS_FLIR
#elif defined(J2000)/**********J2000客户**********/
	
#elif defined(BOLIDE)/**********BOLIDE客户**********/
	
#elif defined(SECURITY)/**********SECURITY客户**********/
		
#elif defined(DAYS30)/**********DAYS30客户**********/
	
#elif defined(PANDA)/**********PANDA客户**********/
	#define SUPPORT_HYBRID_DVR_CONFIG
	/*实时机型支持SPOT 输出*/
	#if defined(D1108) || defined(D1116) || defined(D1116P)
		#define VGA_SPOT
	#endif
	
#elif defined(PROTECTRON)/**********PROTECTRON客户**********/

	#if defined (D9704I)
		#define DEVICE_TYPE         "PR-57104HDMI"
	#elif defined(D9704X)
		#define DEVICE_TYPE         "PR-57204HDMI"
	#elif defined(D9708SLF)
		#define DEVICE_TYPE         "PR-57608HDMI"
	#elif defined(D9716LF)
		#define DEVICE_TYPE         "PR-57616HDMI"
	#endif

#elif defined(DEAPA)

#elif defined(HIVIEWER)
	
#elif defined(LEGRAND)
	/*格式化硬盘时不格式化日志*/
	#define NOT_FORMAT_LOG
	
#elif defined(HONEYWELL)	
	#define SUPPORTED_PROTO 0x13 /*按位取PROTO_TYPE_E*/

	#define MANUFACTURER "HoneyWell"
	#define PLATFORM_SHENGUANG /*霍尼深广平台报警信息上报*/
#elif defined(TONGFANG)		      /**********TONGFANG客户**********/
	#define SUPPORTED_PROTO 0x18 /*按位取PROTO_TYPE_E*/
	
#elif defined(GTC)                /**********GTC客户**********/
	#define DDNS_GTC
	
#elif defined(VIDEOTECNOLOGIE)    /*******VIDEOTECNOLOGIE客户**********/
	#define ESATA_RECORD
	
#elif defined(VC)                 /*************VC客户************/
	//#define AMTK_IPC
	//#define SHANY_IPC
	#define MINGJING_IPC
	#define SUPPORTED_PROTO 0x215 /*按位取PROTO_TYPE_E*/
	#define SAMSUNG_IPC 
	#define CUSTOM_PROTOCOL
	#define MANUFACTURER "BRIGHTVISION"
	#define REMOTE_SEARCH_LOG

#elif defined(DEFENDER)          /**********DEFENDER客户**********/
	#define DVR_NO_IPC

#elif defined(IQCCTV)            /**********IQCCTV客户**********/
	#define FSAN_IPC
	#define ESATA_RECORD
	#define DOUBLE_STREAM
	#define SUPPORTED_PROTO 0x411 /*按位取PROTO_TYPE_E*/
	#define UI_LANG_MASK			0xffffffff
	#define UI_LANG_EXTEND_MASK 	0x0
	#define UI_CUR_LANG 			4
	#define IE_LANG_MASK			0x10
	#define IE_CUR_LANG 			4
	#define IE_CUSTOM				42
	#define IE_LOGO				    42
	
#elif defined(BRIGHT)             /**********BRIGHT客户**********/
	#define HUI_LI
	#define DDNS_ANLIAN
#elif defined(THOMSON)           /**********THOMSON客户**********/
	#define CLOUD_DROPBOX
#elif defined(CDOUBLES)          /**********CDOUBLES客户**********/
	#define CLOUD_DROPBOX
	#define ESATA_RECORD
#if defined(D1116NR)
	#define VGA_SPOT
#endif
#elif defined(NOVUS)            /**********NOVUS客户**********/
	#define CLOUD_DROPBOX

#elif defined(ITEX)             /**********ITEX客户**********/
	#define CLOUD_DROPBOX
	#define HUI_LI
#elif defined(LG)               /**********LG客户**********/
	/*HDMI临时认证程序才开此宏*/
	#define HDMI_AUTHENTICATE
	#define DVR_NO_IPC
#elif defined(DAAPLER)          /**********DAAPLER客户**********/
	#define HUI_LI  //波斯历显示
#elif defined(BALTER)           /**********BALTER客户**********/

#elif defined(INDEXA)           /**********INDEXA客户**********/
    #define ESATA_RECORD
#elif defined(COMMAX)           /**********COMMAX客户**********/
    #define DVR_NO_IPC
#elif defined(RAYDIN)			/**********RAYDIN客户**********/
	#define UI_LANG_MASK            0xffffffff
	#define UI_LANG_EXTEND_MASK     0x0
	#define UI_CUR_LANG             4
	#define IE_LANG_MASK            0x02000010
	#define IE_CUR_LANG             4
	#define IE_CUSTOM               144
	#define IE_LOGO 				144
	#define ACT_MOTION_REC
#elif defined(ABC_PROJECT)
	#define UI_LANG_MASK			0xffffffff
	#define UI_LANG_EXTEND_MASK 	0x0
	#define UI_CUR_LANG 			0
	#define IE_LANG_MASK			0x1
	#define IE_CUR_LANG 			0
	#define IE_CUSTOM				23
	#define IE_LOGO				    23
    #define SEPORT_DOUBLE_PHY
	#define ESATA_RECORD
	#define SUPPORT_ANALOG_ALG
#elif defined(PINETRON)
	#define UI_LANG_MASK			0xffffffff
	#define UI_LANG_EXTEND_MASK 	0x0
	#define UI_CUR_LANG 			4
	#define IE_LANG_MASK			0x020188D0
	#define IE_CUR_LANG 			4
	#define IE_CUSTOM				23
	#define IE_LOGO				    23
#elif defined(HIVIEW)					/**********HIVIEW客户**********/
#if defined(D1108NR) || defined(D1116NR) || defined(D1104NR)
	#define SUBSTREAM_MULTIPLE_RES
#endif
	#define UI_LANG_MASK			0xffffffff
	#define UI_LANG_EXTEND_MASK 	0x0
	#define UI_CUR_LANG 			4
	#define IE_LANG_MASK			0x10
	#define IE_CUR_LANG 			4
	#define IE_CUSTOM				29
	#define IE_LOGO				    29
#elif defined(REDLINE)					/**********REDLINE客户**********/
	#define UI_LANG_MASK			0xffffffff
	#define UI_LANG_EXTEND_MASK 	0x0
	#define UI_CUR_LANG 			15
	#define IE_LANG_MASK			0x8000
	#define IE_CUR_LANG 			15
	#define IE_CUSTOM				118
	#define IE_LOGO				    118
	#define CONFIG_MONITOR_RESOLUTION
	#if defined(D1116NR) || defined(D1104NR) || defined(D1108NR)
		#if defined(D1116NR)
			#define VGA_SPOT
		#endif
		#define DOUBLE_STREAM
		#define SUBSTREAM_MULTIPLE_RES
		#define SUPPORT_ANALOG_ALG
	#elif defined(D2104NR) || defined(D2104) || defined(D2108NR) || defined(D2108) ||\
		defined(D2116NR)
		#define ESATA_RECORD
	#endif
#elif defined(MERX)					/**********REDLINE客户**********/
	/*可添加多通道设备*/
	#define MULTICHANNEL
	
	#define UI_LANG_MASK			0xffffffff
	#define UI_LANG_EXTEND_MASK 	0x0
	#define UI_CUR_LANG 			4
	#define IE_LANG_MASK			0x10
	#define IE_CUR_LANG 			4
	#define IE_CUSTOM				107
	#define IE_LOGO				    107
#elif defined(LUX)					/**********LUX客户**********/	
	#define UI_LANG_MASK			0xffffffff
	#define UI_LANG_EXTEND_MASK 	0x0
	#define UI_CUR_LANG 			4
	#define IE_LANG_MASK			0x10
	#define IE_CUR_LANG 			4
	#define IE_CUSTOM				171
	#define IE_LOGO				    171
	//#define SUPPORT_REMOTE_DESKTOP   //TEAMVIEWER 远程桌面
#elif defined(BPL)					/**********BPL客户**********/	
	#define UI_LANG_MASK			0xffffffff
	#define UI_LANG_EXTEND_MASK 	0x0
	#define UI_CUR_LANG 			4
	#define IE_LANG_MASK			0x10
	#define IE_CUR_LANG 			4
	#define IE_CUSTOM				173
	#define IE_LOGO				    173
#elif defined(VALUETOP)					/**********VALUETOP**********/
#if defined(D2104NR) || defined(D2108NR) || defined(D2116NR)
	#define VGA_SPOT
#endif
	#define UI_LANG_MASK			0xffffffff
	#define UI_LANG_EXTEND_MASK 	0x0
	#define UI_CUR_LANG 			4
	#define IE_LANG_MASK			0x10
	#define IE_CUR_LANG 			4
	#define IE_CUSTOM				124
	#define IE_LOGO				    124
#elif defined(APRO)					/**********APRO客户**********/
#if defined(D2104NR) || defined(D2108NR)
	#define ESATA_RECORD
#endif
	#define UI_LANG_MASK			0xffffffff
	#define UI_LANG_EXTEND_MASK 	0x0
	#define UI_CUR_LANG 			4
	#define IE_LANG_MASK			0x10
	#define IE_CUR_LANG 			4
	#define IE_CUSTOM				167
	#define IE_LOGO				    167
#elif defined(SMARTVIEW)					/**********SMARTVIEW**********/
	#define UI_LANG_MASK			0xffffffff
	#define UI_LANG_EXTEND_MASK 	0x0
	#define UI_CUR_LANG 			17
	#define IE_LANG_MASK			0x10
	#define IE_CUR_LANG 			4
	#define IE_CUSTOM				174
	#define IE_LOGO				    174
#elif defined(SMARTEYE)					/**********SMARTEYE**********/
	#define CONFIG_MONITOR_RESOLUTION
	//#define DOUBLE_STREAM
	#define UI_LANG_MASK			0xffffffff
	#define UI_LANG_EXTEND_MASK 	0x0
	#define UI_CUR_LANG 			17
	#define IE_LANG_MASK			0x800010
	#define IE_CUR_LANG 			4
	#define IE_CUSTOM				176
	#define IE_LOGO				    176
#elif defined(GOLMAR)					/**********GOLMAR**********/
	#define COPY_PLAYER

	#define UI_LANG_MASK			0xffffffff
	#define UI_LANG_EXTEND_MASK 	0x0
	#define UI_CUR_LANG 			16
	#define IE_LANG_MASK			0x1010010
	#define IE_CUR_LANG 			16
	#define IE_CUSTOM				66
	#define IE_LOGO				    66
#elif defined(MAXXONE)					/**********MAXXONE**********/
	#define UI_LANG_MASK			0xffffffff
	#define UI_LANG_EXTEND_MASK 	0x0
	#define UI_CUR_LANG 			4
	#define IE_LANG_MASK			0x10
	#define IE_CUR_LANG 			4
	#define IE_CUSTOM				159
	#define IE_LOGO				    159
#elif defined(ART)					/**********ART**********/
	#define UI_LANG_MASK			0xffffffff
	#define UI_LANG_EXTEND_MASK 	0x0
	#define UI_CUR_LANG 			4
	#define IE_LANG_MASK			0x2000010
	#define IE_CUR_LANG 			4
	#define IE_CUSTOM				184
	#define IE_LOGO				    184
#elif defined(SUPERVISION)					/**********SUPERVISION**********/	
	#define CONFIG_MONITOR_RESOLUTION
#elif defined(BASCOM)					/**********BASCOM**********/
    #define UI_LANG_MASK			0x10108D0
    #define UI_LANG_EXTEND_MASK 	0x0
    #define UI_CUR_LANG 			4
    #define IE_LANG_MASK			0x10890
    #define IE_CUR_LANG 			4
    #define IE_CUSTOM				120
    #define IE_LOGO				    120
#elif defined(OPTIMUS)
    #define UI_LANG_MASK			303142994
    #define UI_LANG_EXTEND_MASK 	0
    #define UI_CUR_LANG 			15
    #define IE_LANG_MASK			32784
    #define IE_CUR_LANG 			15
    #define IE_CUSTOM				148
    #define IE_LOGO				        148
    #define MANUFACTURER "Optimus"
#elif defined(CUBITECH)				/**********CUBITECH**********/ 
	#if defined(D1116NR)
		#define VGA_SPOT
	#endif
	#if defined(D2104NR) || defined(D2108NR) || defined(D2116NR)
		#define ESATA_RECORD
	#endif 
	#define UI_LANG_MASK			0xffffffff
	#define UI_LANG_EXTEND_MASK 	0x0
	#define UI_CUR_LANG 			4
	#define IE_LANG_MASK			0x10
	#define IE_CUR_LANG 			4
	#define IE_CUSTOM				185
	#define IE_LOGO				    185
#elif defined(TOP)                   /**********TOP**********/     
	#define ESATA_RECORD
	#define IE_SET_RESOLUTION
	#define CONFIG_MONITOR_RESOLUTION
	#define UI_LANG_MASK			0xffffffff
	#define UI_LANG_EXTEND_MASK 	0x0
	#define UI_CUR_LANG 			11
	#define IE_LANG_MASK			0x10
	#define IE_CUR_LANG 			4
	#define IE_CUSTOM				89
	#define IE_LOGO				    89
#elif defined ACURA
	#define YCX_IPC
	#define SUPPORTED_PROTO 0x4011
#elif defined(TOASTCAM)					/**********TOASTCAM**********/
	#define UI_LANG_MASK			0xffffffff
	#define UI_LANG_EXTEND_MASK 	0x0
	#define UI_CUR_LANG 			28
	#define IE_LANG_MASK			0x2000010
	#define IE_CUR_LANG 			4
	#define IE_CUSTOM				184
	#define IE_LOGO				    184	
#elif defined(LIVEZON)					/**********LIVEZON客户**********/
	#define UI_LANG_MASK			0xffffffff
	#define UI_LANG_EXTEND_MASK 	0x0
	#define UI_CUR_LANG 			4
	#define IE_LANG_MASK			0x10000010
	#define IE_CUR_LANG 			4
	#define IE_CUSTOM				169
	#define IE_LOGO				    169

#else
/**********通用版本**********/
#endif

#ifndef UI_LANG_MASK
	#define UI_LANG_MASK			0xffffffff
	#define UI_LANG_EXTEND_MASK 	0x0
	#define UI_CUR_LANG 			4
	#define IE_LANG_MASK			0x10
	#define IE_CUR_LANG 			4
	#define IE_CUSTOM				23
	#define IE_LOGO				    23
#endif

#if defined(VGA_SPOT) && defined(SUPPORT_ANALOG_ALG)
#define SPOT_AND_INTELLIGENT_MUTEX /*SPOT和智能互斥*/
#endif

#if defined(H1104W)
#define SUPPORTED_PROTO 0x1
#endif

#if defined(SUPPORT_SONIX_WIFI)
#define WORKSHOP_UDISK_OPERATOR
#endif

/* buffer内总是保留最后一个I帧之后的数据, 在下线不销毁解码通道的情况下，通道会保持显示最后一个I帧画面 */
#if defined(SUPPORT_SONIX_BATTERY)
#define KEEP_LAST_IFRAME
#endif

#ifndef MANUFACTURER
#define  MANUFACTURER "RaySharp"
#endif

#ifndef SUPPORTED_PROTO
#define SUPPORTED_PROTO 0x11 /*按位取PROTO_TYPE_E*/
#endif


#if !defined(H1104W) && !defined(DVR_NO_IPC)
/*支持纯DVR 混合切换*/
#define SUPPORT_HYBRID_DVR_CONFIG
#endif

#if defined(DVR_NO_IPC)
/*纯DVR与混合时同型号的最大通道数不一致，导致互升有问题*/
/* SAMSUNG  SWANN  DEFENDER 对此作处理*/
/* 以后新增型号如果纯DVR与混合通道数不一致，也在此做处理*/
#if defined(D1016NR) || defined(D1116NR) || defined(D1132NR)
	#if defined(SAMSUNG) || defined(SWANN) || defined(DEFENDER) || defined(NOVUS)
		#define EXTEND_PARAMETER_TO_64
	#endif
#elif defined(D1032NR)
	#define EXTEND_PARAMETER_TO_96
#endif
#endif

#if !defined(OWL) && !defined(SAMSUNG)
	#if defined(D1004NR) || defined(D1008NR)  || defined(D1016NR) || defined(D1032NR)
	#if defined(DVR_NO_IPC) || defined(SUPPORT_HYBRID_DVR_CONFIG)
		#define SUPPORT_JUMP_FRAME
	#endif
	#endif
#endif

#if defined(H1104W) || defined(DVR_NO_IPC)
#else
#define ONVIF_IPC
/*支持用户自定义协议,即直接rtsp连接ipc*/
#if !defined(OWL) && !defined(LOREX) \
	&& !defined(HONEYWELL) && !defined(GTC) && !defined(DEFENDER) && !defined(BRIGHT) && !defined(THOMSON)
	
#define CUSTOM_PROTOCOL
#endif
#endif

#if defined(LUXVISION)
	#define NEW_VVP2P_START_MODE/*只针对安联自驾微微服务器P2P ID*/
#endif

#endif
