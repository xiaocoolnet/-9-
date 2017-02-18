//
//  OutpatientClinicDetailsViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 17/2/8.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit
import SwiftyJSON

class OutpatientClinicDetailsViewController: UIViewController,SDCycleScrollViewDelegate {
    
    var userInfo:JSON?
    
    let mainSCView = UIScrollView()
    let functionTextArray = ["医护","门诊","统筹","大病","居家","长期"]
    let functionImageArray = ["ic_yihu","ic_menzhne","ic_tongchou","ic_dabing","ic_jvjia","ic_changqi"]
    let picArray = NSMutableArray()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = true
        self.view.backgroundColor = LGBackColor
        self.creatUI()
        self.getPicData()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
         self.navigationController?.navigationBar.hidden = true
    }
    
    func getPicData(){
        if self.userInfo!["id"].string != nil{
            AppRequestManager.shareManager.getPhotoListByOutpatientId(self.userInfo!["id"].string!) { (success, response) in
                if success{
                    let picInfo = JSON(data: response as! NSData)
                    if picInfo["data"].array != nil{
                        for pic in picInfo["data"].array!{
                            self.picArray.addObject(Happy_ImageUrl+pic["photo"].string!)
                        }
                    }
                    
                }else{
                    alert("数据请求失败", delegate: self)
                }
            }

        }
    }
    
    func creatUI(){
        self.mainSCView.frame = CGRectMake(0, -20, WIDTH, HEIGHT+20)
        self.mainSCView.backgroundColor = LGBackColor
        let myImageScroolView = SDCycleScrollView.init(frame: CGRectMake(0, 0, Screen_W, 165*px), delegate: self, placeholderImage: UIImage(named: "zhihui_tupainzanshiwufaxinashi"))
        
        myImageScroolView.imageURLStringsGroup = self.picArray as [AnyObject]
            
            
//            ["http://www.lagou.com/upload/webproduct/bd00394b005842dfa13364678d2ff6cd.jpg","http://imgsrc.baidu.com/forum/w%3D580/sign=35f5eb13f703738dde4a0c2a831ab073/80b0bd6eddc451da0d3f9858b7fd5266d1163219.jpg","http://s7.sinaimg.cn/mw690/005Xo3wSgy6WfLXd2n4c6&690","http://img5.duitang.com/uploads/item/201408/01/20140801115317_YSzEn.thumb.700_0.jpeg"]
        
        self.mainSCView.addSubview(myImageScroolView)
        
        let backButton = UIButton.init(frame: CGRectMake(10, 20, 30, 30))
        backButton.setImage(UIImage(named: "ic_fanhui"), forState: .Normal)
        backButton.backgroundColor = RGBACOLOR(50, g: 50, b: 50, a: 0.5)
        backButton.layer.masksToBounds = true
        backButton.layer.cornerRadius = 15
        backButton.addTarget(self, action: #selector(self.backButtonAction), forControlEvents: .TouchUpInside)
        
        let infoBackView = UIView.init(frame: CGRectMake(0, myImageScroolView.height, WIDTH, 100*px))
        infoBackView.backgroundColor = UIColor.whiteColor()
        let clinicName = AutoScrollLabel.init(frame: CGRectMake(10*px, 15*px, WIDTH-10*px, 25*px))
        
        if self.userInfo != nil && self.userInfo!["name"].string != nil{
            clinicName.text = self.userInfo!["name"].string
        }
        
        clinicName.textAlignment = .Left
        clinicName.font = UIFont.systemFontOfSize(14)
        infoBackView.addSubview(clinicName)
        
        let personHeaderImageView = UIImageView.init(image: UIImage(named:"ic_fuzeren" ))
        personHeaderImageView.frame = CGRectMake(10*px, clinicName.height+20*px, 14*px, 15*px)
        infoBackView.addSubview(personHeaderImageView)
        
        let personName = UILabel.init(frame: CGRectMake(30*px, personHeaderImageView.frame.origin.y, WIDTH/2-30*px, personHeaderImageView.height))
        
        if self.userInfo != nil && self.userInfo!["leader"].string != nil{
            personName.text = "负责人："+self.userInfo!["leader"].string!
        }
//        personName.text = "负责人："+"柳眉"
        personName.font = UIFont.systemFontOfSize(12)
        personName.textAlignment = .Left
        personName.textColor = MainTextBackColor
        infoBackView.addSubview(personName)
        
        let phoneName = UILabel.init(frame: CGRectMake(WIDTH/2, personHeaderImageView.frame.origin.y, WIDTH/2, personHeaderImageView.height))
        if self.userInfo != nil && self.userInfo!["phone"].string != nil{
            phoneName.text = self.userInfo!["phone"].string!
        }
//        phoneName.text = "15032587496"
        phoneName.font = UIFont.systemFontOfSize(12)
        phoneName.textAlignment = .Left
        phoneName.textColor = MainTextBackColor
        infoBackView.addSubview(phoneName)
        
        let adressHeaderImageView = UIImageView.init(image: UIImage(named:"ic_dizhi" ))
        adressHeaderImageView.frame = CGRectMake(10*px, personHeaderImageView.height+personHeaderImageView.frame.origin.y+5*px, 14*px, 15*px)
        infoBackView.addSubview(adressHeaderImageView)

        let adressName = UILabel.init(frame: CGRectMake(30*px, adressHeaderImageView.frame.origin.y, WIDTH-30*px, adressHeaderImageView.height))
        if self.userInfo != nil && self.userInfo!["address"].string != nil{
            adressName.text = self.userInfo!["address"].string!
        }
//        adressName.text = "山东省烟台市芝罘区上要花园"
        adressName.font = UIFont.systemFontOfSize(12)
        adressName.textAlignment = .Left
        adressName.textColor = MainTextBackColor
        infoBackView.addSubview(adressName)
        
        let featureSubjectHeaderLabel = UILabel.init(frame: CGRectMake(0, infoBackView.frame.height+infoBackView.frame.origin.y, WIDTH, 25*px))
        featureSubjectHeaderLabel.backgroundColor = LGBackColor
        featureSubjectHeaderLabel.text = "  特色科室"
        featureSubjectHeaderLabel.font = MainFont
        self.mainSCView.addSubview(featureSubjectHeaderLabel)
        
        let featureSubjectContentLabel = UILabel.init()
//            .init(frame: CGRectMake(0, featureSubjectHeaderLabel.frame.height+featureSubjectHeaderLabel.frame.origin.y, WIDTH, 60*px))
        featureSubjectContentLabel.font = UIFont.systemFontOfSize(12)
        featureSubjectContentLabel.backgroundColor = UIColor.whiteColor()
        featureSubjectContentLabel.textColor = MainTextBackColor
        featureSubjectContentLabel.userInteractionEnabled = false
        featureSubjectContentLabel.numberOfLines = 0
        featureSubjectContentLabel.lineBreakMode = .ByWordWrapping
        
        if self.userInfo != nil && self.userInfo!["department"].string != nil{
            featureSubjectContentLabel.text = self.userInfo!["department"].string!
        }
//        featureSubjectContentLabel.text = "儿童眼科｜视力矫正｜麻醉科｜预防接种｜儿童眼科｜视力矫正｜麻醉科｜预防接种｜儿童眼科｜视力矫正｜麻醉科｜预防接种｜儿童眼科｜视力矫正｜麻醉科｜预防接种｜"
        featureSubjectContentLabel.frame = CGRectMake(0, featureSubjectHeaderLabel.frame.height+featureSubjectHeaderLabel.frame.origin.y, WIDTH, calculateHeight(featureSubjectContentLabel.text!, size: 12, width: WIDTH))
        self.mainSCView.addSubview(featureSubjectContentLabel)
        
        
        let functionInfoHeaderLabel = UILabel.init(frame: CGRectMake(0, featureSubjectContentLabel.frame.height+featureSubjectContentLabel.frame.origin.y, WIDTH, 25*px))
        functionInfoHeaderLabel.backgroundColor = LGBackColor
        functionInfoHeaderLabel.text = "  功能信息"
        functionInfoHeaderLabel.font = MainFont
        self.mainSCView.addSubview(functionInfoHeaderLabel)
        
        for indexs in 0...functionTextArray.count-1 {
            let classifyButton = MainImageAndTextButton.init(frame: CGRectMake((WIDTH/3-5*px)*CGFloat((indexs)%3)+13*px,functionInfoHeaderLabel.height+functionInfoHeaderLabel.frame.origin.y+WIDTH/3*CGFloat((indexs)/3)+15*px, WIDTH/3-15*px, WIDTH/3-15*px), imageFrame: CGRectMake((WIDTH/3-76*px)/2, 15*px, 61*px, 61*px), textFrame: CGRectMake(0, 65*px, WIDTH/3-15*px, WIDTH/3-65*px), imageName: self.functionImageArray[indexs] , labelText: self.functionTextArray[indexs] )
            classifyButton.downTextLable.textColor = RGBACOLOR(206, g: 206, b: 206, a: 1)
            classifyButton.downTextLable.font = MainFont
            classifyButton.layer.masksToBounds = true
            classifyButton.layer.cornerRadius = 10*px
            classifyButton.tag = indexs
            classifyButton.addTarget(self, action: #selector(self.classifyButton(_:)), forControlEvents: .TouchUpInside)
            
            classifyButton.backgroundColor = UIColor.whiteColor()
            self.mainSCView.addSubview(classifyButton)
            
        }
        
        let lookBackView = UIView.init(frame: CGRectMake(0, functionInfoHeaderLabel.frame.origin.y+functionInfoHeaderLabel.height+270*px, WIDTH, 270*px))
        lookBackView.backgroundColor = UIColor.whiteColor()
        let watchVidioImageView = UIImageView()
        
        watchVidioImageView.frame = CGRectMake(5*px, 0, WIDTH-10*px, 190*px)
        
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
        onlineLabel.textColor = RGBACOLOR(77, g: 195, b: 172, a: 1)
        
        
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
        
        let lineView = UIView()
        let messageCell = UIImageView()
        let messageCellButton = UIButton()
        
        
        lineView.frame = CGRectMake(0, watchVidioImageView.height+watchVidioImageView.frame.origin.y+15*px, WIDTH, 2*px)
        lineView.backgroundColor = LGBackColor
        
        messageCell.frame = CGRectMake(0, lineView.frame.origin.y+2*px, WIDTH, 65*px)
        messageCellButton.frame = messageCell.frame
        messageCell.backgroundColor = UIColor.whiteColor()
        messageCellButton.backgroundColor = UIColor.clearColor()
        messageCellButton.addTarget(self, action: #selector(self.messageCellButtonAction), forControlEvents: .TouchUpInside)
        
        messageCell.image = UIImage(named:"xinxiqiang-1")
        
        lookBackView.addSubview(watchVidioImageView)
        lookBackView.addSubview(lineView)
        lookBackView.addSubview(messageCell)
        lookBackView.addSubview(messageCellButton)
        self.mainSCView.addSubview(lookBackView)
        
        
        
        self.mainSCView.addSubview(infoBackView)
        self.view.addSubview(self.mainSCView)
        self.view.addSubview(backButton)
        self.mainSCView.contentSize = CGSizeMake(WIDTH,lookBackView.height+lookBackView.frame.origin.y+10*px)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.hidden = true
    }
    
    
    //MARK:ACTION
    func backButtonAction(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    func classifyButton(sender:UIButton){
        switch sender.tag {
        case 0:
            let vc =  MainMedicalCareViewController()
            if self.userInfo != nil&&self.userInfo!["id"].string != nil
            {
                vc.cID = self.userInfo!["id"].string!
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
            break
        default:
            break
        }
    }
    func watchOnlineButtonAction(){
        
    }
    func messageCellButtonAction(){
        
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
