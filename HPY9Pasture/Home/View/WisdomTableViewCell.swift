//
//  WisdomTableViewCell.swift
//  HPY9Pasture
//
//  Created by purepure on 16/11/18.
//  Copyright © 2016年 xiaocool. All rights reserved.
//

import UIKit

class WisdomTableViewCell: UITableViewCell {
    
    let mainTitle = UILabel()
    let classifyButtonBackView = UIView()
    let lookMoreButton = UIButton()
    let remoteVidioImageView = UIImageView()
    let watchVidioImageView = UIImageView()
    
    let messageCell = UIImageView()
    let messageCellButton = UIButton()
    
    
    
    
    var targets = UIViewController()
    var lookAllButton = UIButton()
    let lineView = UIView()
    let footView = UIView()
    var isAll = Bool()
    
    
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    init(myDIC:NSDictionary,isAlll:Bool){
        super.init(style: UITableViewCellStyle.Default , reuseIdentifier: "WisdomTableViewCell")
        self.backgroundColor = UIColor.whiteColor()
        let lineView = UIView()
        lineView.backgroundColor = LGBackColor
        self.sd_addSubviews([mainTitle,lookAllButton,footView,remoteVidioImageView,watchVidioImageView,lineView,messageCell,messageCellButton])
        mainTitle.frame = CGRectMake(10, 0, width, 88*px)
        mainTitle.backgroundColor = UIColor.whiteColor()
        mainTitle.text = myDIC.objectForKey("mainTitle") as? String
        mainTitle.font = MainFont
        mainTitle.textColor = UIColor.blackColor()
        mainTitle.textAlignment = .Left
        
        footView.backgroundColor = LGBackColor
        footView.sd_layout()
            .heightIs(10)
            .widthIs(WIDTH)
            .leftSpaceToView(self,0)
            .bottomSpaceToView(self,0)
        
        var classifyArray = NSArray()
        
        if myDIC.objectForKey("classify") != nil {
            classifyArray = (myDIC.objectForKey("classify") as? NSArray)!
        }
        var counts = Int()
        
        if  isAlll {
            counts = classifyArray.count
        }else{
            if classifyArray.count < 8 {
                counts = classifyArray.count
            }else{
                counts = 7
                
            }
        }
        
        
        
        classifyButtonBackView.frame = CGRectMake(0, mainTitle.height, WIDTH, (WIDTH/4)*(CGFloat((counts)/4)+1))
        classifyButtonBackView.backgroundColor = UIColor.whiteColor()
        self.addSubview(classifyButtonBackView)
        NSLOG(CGFloat((counts)/4)+1)
        NSLOG(WIDTH/4)
        
        for indexs in 0...counts {
            if indexs == counts {
                
                if isAlll {
                    let classifyButton = MainImageAndTextButton.init(frame: CGRectMake(WIDTH/4*CGFloat((indexs)%4), WIDTH/4*CGFloat((indexs)/4), WIDTH/4, WIDTH/4), imageFrame: CGRectMake((WIDTH/4-38*px)/2, 5*px, 38*px, 38*px), textFrame: CGRectMake(0, 43*px, WIDTH/4, WIDTH/4-43*px), imageName: "shouhui", labelText: "收起")
                    classifyButton.downTextLable.font = UIFont.systemFontOfSize(13)
                    lookAllButton = classifyButton
                    
                    classifyButtonBackView.addSubview(classifyButton)
                }else{
                    let classifyButton = MainImageAndTextButton.init(frame: CGRectMake(WIDTH/4*CGFloat((indexs)%4), WIDTH/4*CGFloat((indexs)/4), WIDTH/4, WIDTH/4), imageFrame: CGRectMake((WIDTH/4-38*px)/2, 5*px, 38*px, 38*px), textFrame: CGRectMake(0, 43*px, WIDTH/4, WIDTH/4-43*px), imageName: "zhankai", labelText: "展开")
                    classifyButton.downTextLable.font = UIFont.systemFontOfSize(13)
                    lookAllButton = classifyButton
                    
                    classifyButtonBackView.addSubview(classifyButton)
                }
                
            }else{
                let classifyButton = MainImageAndTextButton.init(frame: CGRectMake(WIDTH/4*CGFloat((indexs)%4), WIDTH/4*CGFloat((indexs)/4), WIDTH/4, WIDTH/4), imageFrame: CGRectMake((WIDTH/4-38*px)/2, 5*px, 38*px, 38*px), textFrame: CGRectMake(0, 43*px, WIDTH/4, WIDTH/4-43*px), imageName: classifyArray[indexs].objectForKey("image") as! String, labelText: classifyArray[indexs].objectForKey("text") as! String)
                classifyButton.downTextLable.font = UIFont.systemFontOfSize(13)
                
                classifyButton.tag = indexs
                
                classifyButton.addTarget(self, action: #selector(self.classifyButtonAction(_:)), forControlEvents: .TouchUpInside)
                classifyButtonBackView.addSubview(classifyButton)
            }
            
            
            
            
        }
        
        
        if  isAlll {
            remoteVidioImageView.sd_layout()
                .heightIs(190*px)
                .widthIs(WIDTH-10*px)
                .topSpaceToView(classifyButtonBackView,5*px)
                .leftSpaceToView(self,5*px)
            remoteVidioImageView.layer.masksToBounds = true
            remoteVidioImageView.layer.cornerRadius = 10
            remoteVidioImageView.userInteractionEnabled = true
            remoteVidioImageView.backgroundColor = UIColor.blackColor()
            
            let titleLabel1 = UILabel.init(frame: CGRectMake(10*px, 0, WIDTH/2-5*px, 40))
            titleLabel1.backgroundColor = UIColor.clearColor()
            titleLabel1.text = "退休远程认证"
            titleLabel1.textColor = UIColor.whiteColor()
            titleLabel1.font = MainFont
            
            let certificationLabel = UILabel.init(frame: CGRectMake(WIDTH-90*px, 10*px, 60*px, 20*px))
            certificationLabel.backgroundColor = UIColor.whiteColor()
            certificationLabel.layer.masksToBounds = true
            certificationLabel.layer.cornerRadius = 10*px
            certificationLabel.text = "⦁未认证"
            certificationLabel.font = UIFont.systemFontOfSize(13)
            certificationLabel.textColor = UIColor.orangeColor()
            
            
            let certificationButton = UIButton.init(frame: CGRectMake(WIDTH/2-55*px, 75*px, 100*px, 35*px))
            certificationButton.layer.masksToBounds = true
            certificationButton.layer.cornerRadius = 35*px/2
            certificationButton.layer.borderColor = UIColor.whiteColor().CGColor
            certificationButton.layer.borderWidth = 1
            certificationButton.setTitle("点击预约", forState: .Normal)
            certificationButton.titleLabel?.font = UIFont.systemFontOfSize(14)
            certificationButton.addTarget(self, action: #selector(self.certificationButtonAction), forControlEvents: .TouchUpInside)
            
            let timeLabel = UILabel.init(frame: CGRectMake(10*px, remoteVidioImageView.height-30*px, WIDTH-20*px, 20*px))
            timeLabel.textColor = UIColor.whiteColor()
            timeLabel.font = UIFont.systemFontOfSize(13)
            timeLabel.text = "截止日期:2016.06.12 08:25"
            timeLabel.backgroundColor = UIColor.clearColor()
            
      
            remoteVidioImageView.addSubview(titleLabel1)
            remoteVidioImageView.addSubview(certificationLabel)
            remoteVidioImageView.addSubview(certificationButton)
            remoteVidioImageView.addSubview(timeLabel)
            
            
            
            watchVidioImageView.sd_layout()
                .heightIs(190*px)
                .widthIs(WIDTH-10*px)
                .topSpaceToView(remoteVidioImageView,10*px)
                .leftSpaceToView(self,5*px)
            
            watchVidioImageView.layer.masksToBounds = true
            watchVidioImageView.layer.cornerRadius = 10
            watchVidioImageView.userInteractionEnabled = true
            watchVidioImageView.backgroundColor = UIColor.blackColor()
            
            
            let titleLabel2 = UILabel.init(frame: CGRectMake(10*px, 0, WIDTH/2-5*px, 40))
            titleLabel2.backgroundColor = UIColor.clearColor()
            titleLabel2.text = "社区晚会活动"
            titleLabel2.textColor = UIColor.whiteColor()
            titleLabel2.font = MainFont
            
            let onlineLabel = UILabel.init(frame: CGRectMake(WIDTH-90*px, 10*px, 60*px, 20*px))
            onlineLabel.backgroundColor = UIColor.whiteColor()
            onlineLabel.layer.masksToBounds = true
            onlineLabel.layer.cornerRadius = 10*px
            onlineLabel.text = "⦁看直播"
            onlineLabel.font = UIFont.systemFontOfSize(13)
            onlineLabel.textColor = UIColor.greenColor()
            
            
            let watchOnlineButton = UIButton.init(frame: CGRectMake(WIDTH/2-55*px, 75*px, 100*px, 35*px))
            watchOnlineButton.layer.masksToBounds = true
            watchOnlineButton.layer.cornerRadius = 35*px/2
            watchOnlineButton.layer.borderColor = UIColor.whiteColor().CGColor
            watchOnlineButton.layer.borderWidth = 1
            watchOnlineButton.setTitle("点击观看", forState: .Normal)
            watchOnlineButton.titleLabel?.font = UIFont.systemFontOfSize(14)
            watchOnlineButton.addTarget(self, action: #selector(self.watchOnlineButtonAction), forControlEvents: .TouchUpInside)
            
            let timeLabel2 = UILabel.init(frame: CGRectMake(10*px, watchVidioImageView.height-30*px, WIDTH-20*px, 20*px))
            timeLabel2.textColor = UIColor.whiteColor()
            timeLabel2.font = UIFont.systemFontOfSize(13)
            timeLabel2.text = "开始日期:2016.06.12 08:25"
            timeLabel2.backgroundColor = UIColor.clearColor()
            
            
            watchVidioImageView.addSubview(titleLabel2)
            watchVidioImageView.addSubview(onlineLabel)
            watchVidioImageView.addSubview(watchOnlineButton)
            watchVidioImageView.addSubview(timeLabel2)
            
            lineView.sd_layout()
            .heightIs(2*px)
            .widthIs(WIDTH)
            .topSpaceToView(watchVidioImageView,10*px)
            .leftSpaceToView(self,0)
            
            messageCell.sd_layout()
                .heightIs(65*px)
                .widthIs(WIDTH)
                .topSpaceToView(watchVidioImageView,13*px)
                .leftSpaceToView(self,0)
            messageCellButton.sd_layout()
                .heightIs(65*px)
                .widthIs(WIDTH)
                .topSpaceToView(watchVidioImageView,13*px)
                .leftSpaceToView(self,0)
            messageCell.backgroundColor = UIColor.whiteColor()
            messageCellButton.backgroundColor = UIColor.clearColor()
            messageCellButton.addTarget(self, action: #selector(self.messageCellButtonAction), forControlEvents: .TouchUpInside)
            
            messageCell.image = UIImage(named:"xinxiqiang-1")
        }
        
        
        
        
        
        
        
        
        
    }
    
    
    func classifyButtonAction(sender:UIButton){
        
        
        if mainTitle.text ==  "智慧社区"{
            switch sender.tag {
            case 0:
                break
            case 1:
                let vc = CommunityOlderCareViewController()
                targets.navigationController?.pushViewController(vc, animated: true)
                break
            case 2:
                let vc = PushToTalkViewController()
                targets.navigationController?.pushViewController(vc, animated: true)
                break
            case 5:
                let vc = PropertyTableViewController()
                targets.navigationController?.pushViewController(vc, animated: true)
                break
            case 4:
                let vc = FamilyKitchenViewController()
                targets.navigationController?.pushViewController(vc, animated: true)
                break
                
                
            default:
                break
            }

        }else if mainTitle.text ==  "居家养老"{
            
            switch sender.tag {
            case 0:
                let vc = HealthRecordsAndKindViewController()
                targets.navigationController?.pushViewController(vc, animated: true)
                break
            case 1:
                break
            case 2:
                break
                
                
            default:
                break
            }

            
        }else if mainTitle.text ==  "机构养老"{
            
        }else if mainTitle.text ==  "时尚生活"{
            
        }
    }
    
    func lookAllButtonAction(sender:UIButton){
        self.height = 500
    }
    
    func certificationButtonAction(){
        
    }
    func watchOnlineButtonAction(){
        let watchMovieVC = DeviceViewController()
        let openApi = OpenApiService()
        
        let ServerInfo = "openapi.lechange.cn:443"
        let m_strAppId = "lc80db01e1cb4142dd"//appid
        let m_strAppSecret = "643ec05b22714e9080e1cd5a5dba36"//AppSecret
        let m_strSrv = parseServerIp(ServerInfo)
        let m_iPort = parseServerPort(ServerInfo)
        let phone = "18678959897"
        var accessTok:NSString?
        var errCode : NSString?
        var errMsg : NSString?
        
        
        let ret = openApi.getAccessToken(m_strSrv, port: m_iPort, appId: m_strAppId, appSecret: m_strAppSecret, phone: phone, token: &accessTok, errcode: &errCode, errmsg: &errMsg)
        if ret < 0 {
            if errCode == "TK1006" {
                alert("该号码不是开发者账号的手机号码，开发者创建应用后，可在开放平台网站>开发中心>应用详情页中找到管理员账号。", delegate: self)
            }else if errMsg != nil{
                alert(errMsg as! String, delegate: self)
            }else{
                alert("网络超时，请重试", delegate: self)
            }
        }
        let m_strAccessTok = accessTok as!String
        NSLOG(m_strAccessTok)
        watchMovieVC.setAdminInfo(m_strAccessTok, address: m_strSrv, port: m_iPort, appId: m_strAppId, appSecret: m_strAppSecret)
        watchMovieVC.hidesBottomBarWhenPushed = true
        self.targets.navigationController?.pushViewController(watchMovieVC, animated: true)
    }
    func messageCellButtonAction(){
        
    }
    
    
    func parseServerPort(svrInfo:String)->NSInteger{
        var arr = NSArray()
        arr = svrInfo.componentsSeparatedByString(":")
        if arr.count <= 1 {
            if ((arr.objectAtIndex(0)).rangeOfString("https")).location != NSNotFound {
                return 443
            }else{
                return 80
            }
        }else{
            return (arr.objectAtIndex(1)).integerValue
        }
    }
    
    func parseServerIp(svrInfo:String)->String{
        var arr = NSArray()
        arr = svrInfo.componentsSeparatedByString(":")
        return arr.objectAtIndex(0) as! String
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
