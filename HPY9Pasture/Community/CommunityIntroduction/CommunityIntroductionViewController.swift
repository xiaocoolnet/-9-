//
//  CommunityIntroductionViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 16/10/31.
//  Copyright © 2016年 xiaocool. All rights reserved.
//

import UIKit

class CommunityIntroductionViewController: UIViewController,SDCycleScrollViewDelegate,UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource {
    
    let myScrollView = UIView()//头部view
//    let introductionTextView = UITextView()//简介
    let introductionTextView = UIWebView()//简介
    var stretchButton:MainImageAndTextButton?//伸展按钮
    var busTableView = UITableView()
    var height = Int()//webview展开的长度
    var isOpen = Bool()//展开按钮是否点击
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = LGBackColor
        self.title = "社区简介"
        myScrollView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
        self.view.addSubview(myScrollView)
        self.createrRightNavButton()
        self.createView()
        
        // Do any additional setup after loading the view.
    }
    
    //右侧地图按钮
    func createrRightNavButton(){
        let mapButton = UIButton()
        mapButton.frame = CGRectMake(0, 0, 40, 40)
        mapButton.setTitle("位置", forState: .Normal)
        mapButton.titleLabel?.font = MainFont
        mapButton.titleLabel?.textAlignment = .Right
        mapButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: mapButton)
    }
    
    func createView(){
        let myImageScroolView = SDCycleScrollView.init(frame: CGRectMake(0, 0, Screen_W, 160*px), delegate: self, placeholderImage: UIImage(named: "zhihui_tupainzanshiwufaxinashi"))
        
        myImageScroolView.imageURLStringsGroup = ["http://www.lagou.com/upload/webproduct/bd00394b005842dfa13364678d2ff6cd.jpg","http://imgsrc.baidu.com/forum/w%3D580/sign=35f5eb13f703738dde4a0c2a831ab073/80b0bd6eddc451da0d3f9858b7fd5266d1163219.jpg","http://s7.sinaimg.cn/mw690/005Xo3wSgy6WfLXd2n4c6&690","http://img5.duitang.com/uploads/item/201408/01/20140801115317_YSzEn.thumb.700_0.jpeg"]
        
        self.myScrollView.addSubview(myImageScroolView)
        
        self.introductionTextView.frame = CGRectMake(0, 160*px+10*px, WIDTH, 300*px)
        self.introductionTextView.userInteractionEnabled = false
        self.introductionTextView.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.my51bang.com/index.php?g=portal&m=article&a=index&id=4")!))
        self.introductionTextView.delegate = self
        

        
        
        stretchButton = MainImageAndTextButton.init(frame: CGRectMake(0, self.introductionTextView.height+self.introductionTextView.frame.origin.y, WIDTH, 20*px), imageFrame: CGRectMake(WIDTH/2, 4.5*px, 11*px, 11*px), textFrame: CGRectMake(WIDTH/2-35, 0, 30, 20), imageName: "zhihui_Arrow", labelText: "展开")
        stretchButton?.downTextLable.textColor = RGBACOLOR(81, g: 166, b: 255, a: 1)
        stretchButton?.downTextLable.font = UIFont.systemFontOfSize(13)
        stretchButton?.downTextLable.textAlignment = .Right
        stretchButton?.addTarget(self, action: #selector(self.openAction), forControlEvents: .TouchUpInside)
        
        self.busTableView = UITableView.init(frame: CGRectMake(0, 0, WIDTH, HEIGHT-64))
        busTableView.backgroundColor = LGBackColor
        busTableView.delegate = self
        busTableView.dataSource = self
        busTableView.sectionHeaderHeight = 30
        busTableView.separatorStyle = .None
        busTableView.tableFooterView = UIView()
//        busTableView.registerNib(UINib(nibName: "BusTableViewCell",bundle: nil), forCellReuseIdentifier: "BusTableViewCell")
        busTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "BusTableViewCell")
        
        self.myScrollView.addSubview(stretchButton!)
        
        self.myScrollView.addSubview(introductionTextView)
        self.view.addSubview(self.busTableView)
        self.myScrollView.frame = CGRectMake(0, 0, WIDTH, stretchButton!.height+stretchButton!.origin.y)

        busTableView.tableHeaderView = self.myScrollView
        
    }
    
    //MARK-----webViewDelegate
    
    func webViewDidFinishLoad(webView: UIWebView) {
        let heightStr = webView.stringByEvaluatingJavaScriptFromString("document.body.offsetHeight")
        height = Int(heightStr!)!
    }
    
    func openAction(){
        if isOpen {
            UIView.animateWithDuration(0.6) {
                self.introductionTextView.frame = CGRectMake(0, 160*px+10*px, WIDTH, 300*px)
//                self.myScrollView.contentSize = CGSizeMake(WIDTH, self.introductionTextView.height+self.introductionTextView.frame.origin.y+self.stretchButton!.height)
                self.stretchButton?.frame = CGRectMake(0, self.introductionTextView.height+self.introductionTextView.frame.origin.y, WIDTH, 20*px)
                self.stretchButton?.headerImageView.transform = CGAffineTransformMakeRotation(CGFloat(2*M_PI))
                self.myScrollView.frame = CGRectMake(0, 0, WIDTH, self.stretchButton!.height+self.stretchButton!.origin.y)
                self.busTableView.tableHeaderView = self.myScrollView
            }
        }else{
            UIView.animateWithDuration(0.6) {
                self.introductionTextView.frame = CGRectMake(0, 160*px+10*px, WIDTH, CGFloat(self.height))
//                self.myScrollView.contentSize = CGSizeMake(WIDTH, self.introductionTextView.height+self.introductionTextView.frame.origin.y+self.stretchButton!.height)
                self.stretchButton?.frame = CGRectMake(0, self.introductionTextView.height+self.introductionTextView.frame.origin.y, WIDTH, 20*px)
                self.stretchButton?.headerImageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                self.myScrollView.frame = CGRectMake(0, 0, WIDTH, self.stretchButton!.height+self.stretchButton!.origin.y)
                self.busTableView.tableHeaderView = self.myScrollView
            }
        }
        
            isOpen = !isOpen

    }
    
    
    
    
    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 2
//    }
    //MARK: ------TableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 44
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        NSLOG(indexPath)
    }
    
    
    
    //MARK: ------TableViewDatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("BusTableViewCell", forIndexPath: indexPath)
        cell.textLabel?.text = String(indexPath.row+1) + "阳光尚城(公交站)"
        cell.textLabel?.font = MainFont
        cell.accessoryType = .None
        cell.selectionStyle = .None
        return cell
        
        
        
        
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let mysectionView = UILabel()
        mysectionView.backgroundColor = LGBackColor
        mysectionView.frame = CGRectMake(0, 0, Screen_W, 30)
        
        mysectionView.text = "  公交地铁站"
        
        mysectionView.textColor = UIColor.grayColor()
        mysectionView.font = UIFont.systemFontOfSize(13)
        return mysectionView
        
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
