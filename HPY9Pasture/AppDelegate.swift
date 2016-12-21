//
//  AppDelegate.swift
//  ASwiftProduct
//
//  Created by xiaocool on 16/4/15.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,BMKGeneralDelegate ,NIMNetCallManagerDelegate{

    var window: UIWindow?
    var _mapManager: BMKMapManager?
    let NAVC = HPYRootController()
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = NAVC
        window!.makeKeyAndVisible()
        //set Style
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().barTintColor = NavColor
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), forBarMetrics:.Default)
        UITabBar.appearance().translucent = false
        
        let ud = NSUserDefaults.standardUserDefaults()
        if ud.boolForKey("ISLogin") {//判断是否需要登录
            
        }else{
            //为登录跳转登录页面
            let NAV1 = UINavigationController.init(rootViewController: HPYLoginController())
            NAVC.presentViewController(NAV1, animated: true, completion: {
            
            })
        }
        /***********************网易云信********************************/
        
        NIMSDK.sharedSDK().registerWithAppID("34d065a1b06fb569380c94d4c55841ec", cerName: "快乐9号")
        //视频通话接听回调添加代理
        NIMSDK.sharedSDK().netCallManager.addDelegate(self)
        
        /***********************百度地图********************************/
        // 要使用百度地图，请先启动BaiduMapManager
        _mapManager = BMKMapManager()
        // 如果要关注网络及授权验证事件，请设定generalDelegate参数
        let ret = _mapManager?.start("ZYrOi8YPt6NoNBvaYV5b2RxC1r0z0Bxv", generalDelegate: self)
        if ret == false {
            NSLog("manager start failed!")
        }
        
        return true
    }
    //MARK:-- NIMNetCallManagerDelegate//视频通话接听回调代理
    func onReceive(callID: UInt64, from caller: String, type: NIMNetCallType, message extendMessage: String?) {
        
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
 
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        
       
            
        return true
        
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        
        return true
    }
}

