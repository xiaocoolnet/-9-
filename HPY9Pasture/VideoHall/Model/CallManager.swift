//
//  CallManager.swift
//  HPY9Pasture
//
//  Created by purepure on 17/3/7.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit

class CallManager: NSObject,EMChatManagerDelegate, EMCallManagerDelegate, EMCallBuilderDelegate {
    
    var callLock = NSObject()
    var timer:NSTimer?
    var currentSession:EMCallSession?
    var currentController:ChatWithVideoViewController?
    
    //单例
    static let shareManager = CallManager()
    private override init() {
        super.init()
        self.initManager()
    }
    
    deinit{
        EMClient.sharedClient().callManager.removeDelegate!(self)
        EMClient.sharedClient().chatManager.removeDelegate(self)
    }
    
    func aplVideoWidh(username:String,ext:String){
        EMClient.sharedClient().callManager.startCall!(EMCallTypeVideo, remoteName: "xiaocool", ext: "123") { (callsession, error) in
            self.currentSession = callsession
            self.currentController = ChatWithVideoViewController.init(callSession: callsession,isCaller: true)
            
            if self.getPresentedViewController() != UIApplication.sharedApplication().keyWindow?.rootViewController!{
                let topvc = self.getPresentedViewController()
                topvc.dismissViewControllerAnimated(false, completion: nil)
            }
            UIApplication.sharedApplication().keyWindow?.rootViewController!.presentViewController(self.currentController!, animated: false, completion: nil)
        }
    }

    
    func initManager(){
        callLock = NSObject.init()
        currentSession = nil
        currentController = nil
        EMClient.sharedClient().chatManager.addDelegate(self, delegateQueue: nil)
        EMClient.sharedClient().callManager.addDelegate!(self, delegateQueue: nil)
        EMClient.sharedClient().callManager.setBuilderDelegate!(self)
    }
    
    
    //MARK:-----EMCallManagerDelegate
    
    func callDidReceive(aSession: EMCallSession!) {
        
        
        if aSession == nil||aSession.callId.characters.count == 0{
            return
        }
        
        objc_sync_enter(self)
        self.startCallTimer()
        self.currentSession = aSession
        self.currentController = ChatWithVideoViewController.init(callSession: self.currentSession!,isCaller: false)
        self.currentController?.modalPresentationStyle = .OverFullScreen
        dispatch_async(dispatch_get_main_queue()) {
            
            if self.getPresentedViewController() != UIApplication.sharedApplication().keyWindow?.rootViewController!{
                let topvc = self.getPresentedViewController()
                topvc.dismissViewControllerAnimated(false, completion: nil)
            }
            UIApplication.sharedApplication().keyWindow?.rootViewController!.presentViewController(self.currentController!, animated: false, completion: nil)
        }
        objc_sync_exit(self)
    }
    
    func callDidConnect(aSession: EMCallSession!) {
        if aSession.callId == self.currentSession?.callId{
            NSLOG("会话通道建立")
        }
    }
    
    func callDidAccept(aSession: EMCallSession!) {
        if aSession.callId == self.currentSession?.callId{
            NSLOG("对方已同意接听")
            self.stopCallTimer()
            self.currentController!.stateToAnswered()
        }
    }
    
    func callDidEnd(aSession: EMCallSession!, reason aReason: EMCallEndReason, error aError: EMError!) {
        switch aReason {
        case EMCallEndReasonHangup:
            Alert.shareManager.alert("对方挂断", delegate: self.currentController!)
            break
        case EMCallEndReasonNoResponse:
             Alert.shareManager.alert("对方没有响应", delegate: self.currentController!)
            break
        case EMCallEndReasonDecline:
             Alert.shareManager.alert("对方拒接", delegate: self.currentController!)
            break
        case EMCallEndReasonBusy:
             Alert.shareManager.alert("对方占线", delegate: self.currentController!)
            break
        case EMCallEndReasonFailed:
             Alert.shareManager.alert("失败", delegate: self.currentController!)
            break
        case EMCallEndReasonUnsupported:
             Alert.shareManager.alert("功能不支持", delegate: self.currentController!)
            break
        case EMCallEndReasonRemoteOffline:
             Alert.shareManager.alert("对方不在线", delegate: self.currentController!)
            break
        default:
            break
        }
        self.currentController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    //MARK:-----time
    func startCallTimer(){
        self.timer = NSTimer.scheduledTimerWithTimeInterval(50, target: self, selector: #selector(self.timeoutBeforeCallAnswered), userInfo: nil, repeats: false)
    }
    func stopCallTimer(){
        if self.timer == nil{
            return
        }
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func timeoutBeforeCallAnswered(){
        self.hangupCallWithReason(EMCallEndReasonNoResponse)
    }
    
    func hangupCallWithReason(aReason:EMCallEndReason){
        self.stopCallTimer()
        if self.currentSession != nil{
            EMClient.sharedClient().callManager.endCall!(self.currentSession?.callId, reason: aReason)
        }
        self.clearCurrentCallViewAndData()
    }
    
    func clearCurrentCallViewAndData(){
        objc_sync_enter(self)
        self.currentSession = nil
        self.currentController!.isDismissing = true
        self.currentController!.clearData()
        self.currentController?.dismissViewControllerAnimated(false, completion: nil)
        self.currentController = nil
        objc_sync_exit(self)
    }
    //被叫方同意时事通话
    func answerIncomingCall(acallId:String){
        let error = EMClient.sharedClient().callManager.answerIncomingCall!(acallId)
        if error == nil{
            NSLOG("同意接听")
        }
    }
    //结束通话（可选择结束原因）
    /*
 
     typedef enum{
     EMCallEndReasonHangup   = 0,    /*! 对方挂断 */
     EMCallEndReasonNoResponse,      /*! 对方没有响应 */
     EMCallEndReasonDecline,         /*! 对方拒接 */
     EMCallEndReasonBusy,            /*! 对方占线 */
     EMCallEndReasonFailed,          /*! 失败 */
     EMCallEndReasonUnsupported,     /*! 功能不支持 */
     }EMCallEndReason;
 
     */
    func endCall(aCallId:String,aReason:EMCallEndReason){
        EMClient.sharedClient().callManager.endCall!(aCallId, reason: aReason)
        self.currentController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //通过回调通知应用当前实时通话网络状态。
    /*!
     *  用户A和用户B正在通话中，用户A的网络状态出现不稳定，用户A会收到该回调
     *
     *  @param aSession  会话实例
     *  @param aStatus   当前状态
     
     
     typedef enum{
     EMCallNetworkStatusNormal = 0,  /*! 正常 */
     EMCallNetworkStatusUnstable,    /*! 不稳定 */
     EMCallNetworkStatusNoData,      /*! 没有数据 */
     }EMCallNetworkStatus;
     */
    func callNetworkDidChange(aSession: EMCallSession!, status aStatus: EMCallNetworkStatus) {
        switch aStatus {
        case EMCallNetworkStatusNormal:
            NSLOG("正常")
        case EMCallNetworkStatusUnstable:
            NSLOG("不稳定")
        case EMCallNetworkStatusNoData:
            NSLOG("没有数据")
        default:
            break
        }
    }
    
    
    //MARK:-----获取当前屏幕present出来的viewcontroller
    
    func getPresentedViewController() -> UIViewController{
        let appRootVC = UIApplication.sharedApplication().keyWindow?.rootViewController
        var topVC = appRootVC
        if topVC?.presentedViewController != nil{
            topVC = topVC?.presentedViewController
            
        }
        return topVC!
    }
    
    

}
