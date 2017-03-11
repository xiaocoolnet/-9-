//
//  ChatWithVideoViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 17/3/7.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit

class ChatWithVideoViewController: UIViewController,EMChatManagerDelegate, EMCallManagerDelegate, EMCallBuilderDelegate {
    
    var callSession:EMCallSession?
    var ringPlayer:AVAudioPlayer?
    var timeLength = Int()
    var timeTimer:NSTimer?
    let timeLabel = UILabel()
    var isDismissing:Bool = false
    var isCaller = Bool()
    let endButton = UIButton()
    let OKButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        EMClient.sharedClient().callManager.addDelegate!(self, delegateQueue: nil)
        self.endButton.frame = CGRectMake(200, 500, 80, 30)
        self.endButton.backgroundColor = NavColor
        self.endButton.setTitle("结束", forState: .Normal)
        self.endButton.addTarget(self, action: #selector(self.endButtonAction), forControlEvents: .TouchUpInside)
        self.view.addSubview(self.endButton)
        self.OKButton.frame = CGRectMake(100, 500, 80, 30)
        self.OKButton.backgroundColor = NavColor
        self.OKButton.setTitle("接听", forState: .Normal)
        self.OKButton.addTarget(self, action: #selector(self.OKButtonAction), forControlEvents: .TouchUpInside)
        self.view.addSubview(self.OKButton)

        // Do any additional setup after loading the view.
    }
    
    init(callSession:EMCallSession,isCaller:Bool){
        
        
        super.init(nibName: nil, bundle: nil)
        self.callSession = callSession
        self.view.backgroundColor = UIColor.redColor()
        if isCaller{
            self.isCaller = isCaller
            self.setupLocalVideoView()
        }
        
    }
    func setupRemoteVideoView(){
        if self.callSession?.type == EMCallTypeVideo && self.callSession!.remoteVideoView == nil{
            self.callSession!.remoteVideoView = EMCallRemoteView.init(frame: CGRectMake(0, 0, WIDTH, HEIGHT))
            self.callSession?.remoteVideoView.backgroundColor = UIColor.clearColor()
            self.callSession?.remoteVideoView.scaleMode = EMCallViewScaleModeAspectFill
            self.callSession!.remoteVideoView.hidden = true
            self.view.addSubview(self.callSession!.remoteVideoView)
            self.view.sendSubviewToBack(self.callSession!.remoteVideoView)
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1), dispatch_get_main_queue(), {
                self.callSession?.remoteVideoView.hidden = false
            })
            
            
            
            
        }
    }
    
    func setupLocalVideoView(){
        self.callSession!.localVideoView = EMCallLocalView.init(frame: CGRectMake(WIDTH-80, 20, 80,self.view.bounds.height/self.view.bounds.width*80))
        self.view.addSubview((self.callSession?.localVideoView)!)
        self.view.bringSubviewToFront((self.callSession?.localVideoView)!)
    }
    
    
    func beginRing(){
        
        if self.ringPlayer != nil{
           self.ringPlayer!.stop()
        }
        
        
        let musicPath = NSBundle.mainBundle().pathForResource("", ofType: "")
        let url =  NSURL.init(fileURLWithPath: musicPath!)
        do{
            try self.ringPlayer = AVAudioPlayer.init(contentsOfURL: url)
        }catch{
            NSLOG("AVAudioPlayer error")
        }
        self.ringPlayer!.numberOfLoops = 1
        self.ringPlayer!.volume = 1
        if self.ringPlayer!.prepareToPlay(){
            self.ringPlayer!.play()
        }
    }
    func stopRing(){
        if self.ringPlayer != nil{
            self.ringPlayer!.stop()
        }
        
    }
    
    
    func startTimeTimer(){
        self.timeLength = 0
        self.timeTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(self.timeTimerAction), userInfo: nil, repeats: true)
        
    }
    
    func stopTimeTimer(){
        if self.timeTimer != nil{
            self.timeTimer!.invalidate()
            self.timeTimer = nil

        }
    }
    func timeTimerAction(){
        self.timeLength += 1
        let hour = self.timeLength / 3600
        let m = (self.timeLength - hour * 3600) / 60
        let s = self.timeLength - hour * 3600 - m * 60
        if hour>0{
            timeLabel.text = String(format: "%i:%i:%i", hour, m, s)
        }else if m>0{
            timeLabel.text = String(format: "%i:%i",  m, s)
        }else{
            timeLabel.text = String(format: "00:%i",   s)
        }
        
        
    }
    
    func clearData(){
        
        let audioSession = AVAudioSession.sharedInstance()
        do{
            try audioSession.overrideOutputAudioPort(.None)
            try audioSession.setActive(true)
        }catch{
            
        }
        
        if self.callSession?.remoteVideoView != nil{
            self.callSession?.remoteVideoView.hidden = true
            self.callSession?.remoteVideoView = nil
            self.callSession = nil
            self.stopTimeTimer()
            self.stopRing()
        }
        
        
    }
    
    //视频对方接听后
    func stateToAnswered(){
        self.startTimeTimer()
        if self.callSession!.type == EMCallTypeVideo{
            let audioSession = AVAudioSession.sharedInstance()
            do{
                try audioSession.overrideOutputAudioPort(.Speaker)
                try audioSession.setActive(true)
            }catch{
                
            }
        }
        var connectStr = "None"
        if self.callSession?.connectType == EMCallConnectTypeRelay{
            connectStr = "转媒体服务器连接"
        }else if self.callSession?.connectType == EMCallConnectTypeDirect{
            connectStr = "直连"
        }
        NSLOG(connectStr)
        self.setupRemoteVideoView()
        
    }
    
    /*!
     *  设置使用前置摄像头还是后置摄像头,默认使用前置摄像头
     *
     *  @param  aIsFrontCamera    是否使用前置摄像头, YES使用前置, NO使用后置
     */
    
    func switchCameraPosition(isahead:Bool){
        self.callSession!.switchCameraPosition(isahead)
    }
    
    //MARK:-----ACTION
    func endButtonAction(){
        
        CallManager.shareManager.endCall((self.callSession?.callId)!, aReason: EMCallEndReasonHangup)
        self.clearData()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func OKButtonAction(){
        CallManager.shareManager.answerIncomingCall((self.callSession?.callId)!)
        self.setupLocalVideoView()
        self.setupRemoteVideoView()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
