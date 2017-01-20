//
//  CommunityCareViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 16/12/19.
//  Copyright © 2016年 xiaocool. All rights reserved.
//

import UIKit

class CommunityOlderCareViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let myTableView = UITableView()
    
    let headerButton1 = UIButton()//日间照料
    let headerButton2 = UIButton()//助老食堂
    let headerButton3 = UIButton()//互助养老
    let headerButton4 = UIButton()//康复中心
    
    let movingLabel = UILabel()//移动白色label
    
    let headerViewImageView = UIImageView()//tableViewHeaderView中的图片
    let addressLabel = UILabel()
    let nameLabel = UILabel()
    let geLabel = UILabel()
    let imageArray = ["shequyanglao","zhulaoshitang","huzhuyanglao","kangfuzhognxin"]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "社区养老"
        self.view.backgroundColor = LGBackColor
        
        self.createUI()
        //消除导航栏与self.view之间的黑色分割线
        self.navigationController!.navigationBar.translucent = false
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController!.navigationBar.shadowImage=UIImage()
        // Do any additional setup after loading the view.
    }
    
    
    func createUI(){
        headerButton1.frame = CGRectMake(0, 0, WIDTH/4, 40*px)
        headerButton1.backgroundColor = NavColor
        headerButton1.setTitle("日间照料", forState: .Normal)
        headerButton1.setTitleColor(RGBACOLOR(208, g: 231, b: 255, a: 1), forState: .Normal)
        headerButton1.setTitleColor(UIColor.whiteColor(), forState: .Selected)
        headerButton1.selected = true
        headerButton1.titleLabel?.font = UIFont.systemFontOfSize(13)
        headerButton1.addTarget(self, action: #selector(self.headerButton1Action), forControlEvents: .TouchUpInside)
        
        headerButton2.frame = CGRectMake(WIDTH/4, 0, WIDTH/4, 40*px)
        headerButton2.backgroundColor = NavColor
        headerButton2.setTitle("助老食堂", forState: .Normal)
        headerButton2.setTitleColor(RGBACOLOR(208, g: 231, b: 255, a: 1), forState: .Normal)
        headerButton2.setTitleColor(UIColor.whiteColor(), forState: .Selected)
        headerButton2.titleLabel?.font = UIFont.systemFontOfSize(13)
        headerButton2.addTarget(self, action: #selector(self.headerButton2Action), forControlEvents: .TouchUpInside)
        
        headerButton3.frame = CGRectMake(WIDTH/4*2, 0, WIDTH/4, 40*px)
        headerButton3.backgroundColor = NavColor
        headerButton3.setTitle("互助养老", forState: .Normal)
        headerButton3.setTitleColor(RGBACOLOR(208, g: 231, b: 255, a: 1), forState: .Normal)
        headerButton3.setTitleColor(UIColor.whiteColor(), forState: .Selected)
        headerButton3.titleLabel?.font = UIFont.systemFontOfSize(13)
        headerButton3.addTarget(self, action: #selector(self.headerButton3Action), forControlEvents: .TouchUpInside)
        
        headerButton4.frame = CGRectMake(WIDTH/4*3, 0, WIDTH/4, 40*px)
        headerButton4.backgroundColor = NavColor
        headerButton4.setTitle("康复中心", forState: .Normal)
        headerButton4.setTitleColor(RGBACOLOR(208, g: 231, b: 255, a: 1), forState: .Normal)
        headerButton4.setTitleColor(UIColor.whiteColor(), forState: .Selected)
        headerButton4.titleLabel?.font = UIFont.systemFontOfSize(13)
        headerButton4.addTarget(self, action: #selector(self.headerButton4Action), forControlEvents: .TouchUpInside)
        
        let backLabel = UILabel.init(frame: CGRectMake(0, headerButton4.height, WIDTH, 5*px))
        backLabel.backgroundColor = NavColor
        
        self.movingLabel.frame = CGRectMake(0, headerButton4.height, WIDTH/4, 3*px)
        self.movingLabel.backgroundColor = UIColor.whiteColor()
        
        
        
        self.view.addSubview(self.headerButton1)
        self.view.addSubview(self.headerButton2)
        self.view.addSubview(self.headerButton3)
        self.view.addSubview(self.headerButton4)
        self.view.addSubview(backLabel)
        self.view.addSubview(self.movingLabel)
        
        
        self.myTableView.frame = CGRectMake(0, backLabel.frame.origin.y+backLabel.height, WIDTH, HEIGHT-backLabel.frame.origin.y+backLabel.height-64)
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
        self.myTableView.separatorStyle = .None
        
        self.myTableView.registerNib(UINib(nibName: "CommunityOlderCareTableViewCell",bundle: nil), forCellReuseIdentifier: "CommunityOlderCareTableViewCell")
       
        
        self.view.addSubview(myTableView)
        
        
        let mytableViewHeaderView = UIView()
        mytableViewHeaderView.frame = CGRectMake(0, 0, WIDTH, 80*px)
        self.myTableView.tableHeaderView = mytableViewHeaderView
        
        self.headerViewImageView.frame = CGRectMake(20, 21*px, 38*px, 38*px)
        self.headerViewImageView.image = UIImage(named: self.imageArray[0])
        mytableViewHeaderView.addSubview(self.headerViewImageView)
        
        self.addressLabel.frame = CGRectMake(headerViewImageView.frame.origin.x+headerViewImageView.frame.size.width + 10*px, 20*px, WIDTH-70*px, 20*px)
        self.addressLabel.font = UIFont.systemFontOfSize(13)
        self.addressLabel.textColor = UIColor.blackColor()
        self.addressLabel.textAlignment = .Left
        self.addressLabel.text = "青岛市北区"
        mytableViewHeaderView.addSubview(self.addressLabel)
        
        self.nameLabel.frame = CGRectMake(headerViewImageView.frame.origin.x+headerViewImageView.frame.size.width + 10*px, 40*px, 95*px, 20*px)
        self.nameLabel.font = UIFont.systemFontOfSize(13)
        self.nameLabel.textColor = UIColor.blackColor()
        self.nameLabel.textAlignment = .Left
        self.nameLabel.text = "日间照料场所"
        mytableViewHeaderView.addSubview(self.nameLabel)
        
        self.geLabel.frame = CGRectMake(self.nameLabel.frame.size.width+self.nameLabel.frame.origin.x, self.nameLabel.frame.origin.y-3, 18*px, 20*px+3)
        self.geLabel.text = "2"
        self.geLabel.textColor = NavColor
        self.geLabel.font = UIFont.systemFontOfSize(19)
        mytableViewHeaderView.addSubview(self.geLabel)
        
        let lastLabel = UILabel.init(frame: CGRectMake(self.geLabel.frame.origin.x+self.geLabel.frame.size.width, 40*px, 20*px, 20*px))
        lastLabel.font = UIFont.systemFontOfSize(13)
        lastLabel.text = "个"
        lastLabel.textColor = UIColor.blackColor()
        mytableViewHeaderView.addSubview(lastLabel)
        
        
        
    }
    
    
    //MARK: ------TableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 130
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
    }
    
    
    //MARK: ------TableViewDatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let dic = NSDictionary()
        let cell = tableView.dequeueReusableCellWithIdentifier("CommunityOlderCareTableViewCell", forIndexPath: indexPath)as!CommunityOlderCareTableViewCell
        cell.setValueWithInfo(dic)
        cell.accessoryType = .None
        cell.selectionStyle = .None
        
        return cell
    }
    //MARK: ------Action
    func headerButton1Action(){
        if self.headerButton1.selected == true {
            return
        }else{
            self.headerButton1.selected = true
            self.headerButton2.selected = false
            self.headerButton3.selected = false
            self.headerButton4.selected = false
            
            UIView.animateWithDuration(0.1, animations: {
                self.movingLabel.frame = CGRectMake(0, self.headerButton4.height, WIDTH/4, 3*px)
                self.headerViewImageView.image = UIImage(named: self.imageArray[0])
                self.nameLabel.text = "日间照料场所"
            })
            
            
        }
        
    }
    func headerButton2Action(){
        if self.headerButton2.selected == true {
            return
        }else{
            self.headerButton2.selected = true
            self.headerButton1.selected = false
            self.headerButton3.selected = false
            self.headerButton4.selected = false
            UIView.animateWithDuration(0.1, animations: {
                self.movingLabel.frame = CGRectMake(WIDTH/4, self.headerButton4.height, WIDTH/4, 3*px)
                self.headerViewImageView.image = UIImage(named: self.imageArray[1])
                self.nameLabel.text = "助老食堂场所"
            })
        }
    }
    func headerButton3Action(){
        if self.headerButton3.selected == true {
            return
        }else{
            self.headerButton3.selected = true
            self.headerButton2.selected = false
            self.headerButton1.selected = false
            self.headerButton4.selected = false
            UIView.animateWithDuration(0.1, animations: {
                self.movingLabel.frame = CGRectMake(WIDTH/4*2, self.headerButton4.height, WIDTH/4, 3*px)
                self.headerViewImageView.image = UIImage(named: self.imageArray[2])
                self.nameLabel.text = "互助养老场所"
            })
            
        }
    }
    func headerButton4Action(){
        if self.headerButton4.selected == true {
            return
        }else{
            self.headerButton4.selected = true
            self.headerButton2.selected = false
            self.headerButton3.selected = false
            self.headerButton1.selected = false
            UIView.animateWithDuration(0.1, animations: {
                self.movingLabel.frame = CGRectMake(WIDTH/4*3, self.headerButton4.height, WIDTH/4, 3*px)
                self.headerViewImageView.image = UIImage(named: self.imageArray[3])
                self.nameLabel.text = "康复中心场所"
            })
        }
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
