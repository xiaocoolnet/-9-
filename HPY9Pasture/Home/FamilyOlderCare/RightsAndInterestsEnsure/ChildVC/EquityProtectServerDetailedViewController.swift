//
//  EquityProtectServerDetailedViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 17/3/9.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit

class EquityProtectServerDetailedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let mytableView = UITableView()
    var headerView:LawHelpTableViewCell?
    let textArray:Array<Array<String>> = [[""],["执业证号：","执业机构："],[""]]
    let headerArray:Array<String> = ["专业领域","认证信息",""]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "详情页面"
        self.view.backgroundColor = LGBackColor
        self.mytableView.frame = CGRectMake(0, 0*px, WIDTH, HEIGHT-64-51*px)
        self.mytableView.delegate = self
        self.mytableView.dataSource = self
        self.mytableView.backgroundColor = UIColor.whiteColor()
        self.mytableView.separatorStyle = .None
        self.mytableView.sectionHeaderHeight = 38*px
        self.mytableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "PublicTableViewCell")
        self.view.addSubview(self.mytableView)
        
        let headerBackView = UIView.init(frame: CGRectMake(0, 0, WIDTH, 80))
        self.headerView =  NSBundle.mainBundle().loadNibNamed("LawHelpTableViewCell", owner: nil, options: nil).first as? LawHelpTableViewCell
        self.headerView!.headerImage.backgroundColor = UIColor.redColor()
        self.headerView!.name.text = "纯纯"
        self.headerView!.adress.text = "青岛市市北区"
        self.headerView!.disLabel.text = "已帮助3524545人解决问题"
        headerBackView.addSubview(self.headerView!)
        self.mytableView.tableHeaderView = headerBackView
        //底部按钮部分
        let phoneButton = UIButton.init(frame: CGRectMake(0, HEIGHT-64-50*px, WIDTH/3-1, 50*px))
        phoneButton.setImage(UIImage(named: ""), forState: .Normal)
        phoneButton.addTarget(self, action: #selector(self.phoneButtonAction), forControlEvents: .TouchUpInside)
        self.view.addSubview(phoneButton)
        let talkButton = UIButton.init(frame: CGRectMake(WIDTH/3, HEIGHT-64-50*px, WIDTH/3-1, 50*px))
        talkButton.setImage(UIImage(named: ""), forState: .Normal)
        talkButton.addTarget(self, action: #selector(self.talkButtonAction), forControlEvents: .TouchUpInside)
        self.view.addSubview(talkButton)
        
        let appButton = UIButton.init(frame: CGRectMake(WIDTH/3*2, HEIGHT-64-50*px, WIDTH/3-1, 50*px))
        appButton.setImage(UIImage(named: ""), forState: .Normal)
        appButton.addTarget(self, action: #selector(self.appButtonAction), forControlEvents: .TouchUpInside)
        appButton.backgroundColor = UIColor.orangeColor()
        self.view.addSubview(appButton)
        
        // Do any additional setup after loading the view.
    }
    //MARK: ------UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if indexPath.section == 2{
            return 0
        }
        return 44*px
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
    }
    //MARK: ------TableViewDatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return textArray[section].count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return textArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = PublicTableViewCell.init(style: .Default)
        cell.textLabel?.text = self.textArray[indexPath.section][indexPath.row]+"1212121212"
        cell.textLabel?.font = MainFont
        cell.selectionStyle = .None
        return cell
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let backView = UIView.init(frame: CGRectMake(0, 0, WIDTH, 38*px))
        backView.backgroundColor = LGBackColor
        let downView = UILabel.init(frame: CGRectMake(0, 8*px, WIDTH, 29*px))
        if section == 2{
            downView.height = 30*px
        }
        downView.text = "   " + self.headerArray[section]
        downView.textColor = MainTextBackColor
        downView.font = UIFont.systemFontOfSize(12)
        downView.backgroundColor = UIColor.whiteColor()
        backView.addSubview(downView)
        return backView
    }
    //MARK:----ACTION
    func phoneButtonAction(){
        
    }
    
    func talkButtonAction(){
        
    }
    func appButtonAction(){
        let vc = EquityProtectGoAppViewController()
        self.navigationController?.pushViewController(vc, animated: true)
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
