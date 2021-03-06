//
//  HPY9Pasture－Bridging－Header.h
//  HPY9Pasture
//
//  Created by purepure on 16/10/20.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//


#ifndef HPY9Pasture_Bridging_Header_h
#define HPY9Pasture_Bridging_Header_h
#import <Foundation/Foundation.h>

#import "UIBounceButton.h"
#import "SDAutoLayout.h"
#import "GXAlertView.h"
#import "MJRefresh.h"
#import "SDCycleScrollView.h"
#import "FXLabel.h"
#import "ColorfulNameLabel.h"//自定义头像
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVAudioSession.h>

#import "JQIndicatorView.h"//正在加载。。。


//大华设备
#import "openApiService.h"
#import "DeviceViewController.h"

//阿里云推送
#import <CloudPushSDK/CloudPushSDK.h>

//图片上传
#import "ConnectModel.h"

//数据库访问FMDB
#import "FMDB.h"
#import "DataBase.h"

//带默认文字的textview
#import "PlaceholderTextView.h"

#import <Hyphenate/EMSDKFull.h>


/*百度地图*/

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件

#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

#endif /* HPY9Pasture_Bridging_Header_h */
