//
//  InfoForServerViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 17/2/21.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit

typealias ChangeView = (indexs:CGFloat,ory:CGFloat)->CGFloat

class InfoForServerViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let infoTableView = UITableView()
    var changeView = ChangeView?()
    let textArray:Array<Array<String>> = [["年龄：","民族：","身份证号：","婚育状况","属相：","最高学历："],["服务户数：","工作年限：","可服务城市：","服务时间段："],["身份证：","健康证：","母婴护理证书：","驾驶证："]]
    let headerTitleArray : Array<String> = ["  基本信息","  服务信息","  证件信息"]
    var types = CGFloat()
    var move = UIPanGestureRecognizer()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.creatUI()
        self.types = 106

        // Do any additional setup after loading the view.
    }
    
    func creatUI(){
        self.infoTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-110-40*px)
        self.infoTableView.sectionHeaderHeight = 20
        self.infoTableView.delegate = self
        self.infoTableView.dataSource = self
        self.infoTableView.backgroundColor = LGBackColor
        self.infoTableView.separatorStyle = .None
        self.infoTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "PublicTableViewCell")
        self.infoTableView.scrollEnabled = false
        
        move = UIPanGestureRecognizer.init(target: self, action: #selector(self.doViewChage(_:)))
        self.infoTableView.addGestureRecognizer(move)
        self.view.addSubview(self.infoTableView)
    }
    
    
    func doViewChage(sender:UIPanGestureRecognizer){
        
        var change1 = CGPoint()
        var begin1 = CGPoint()
        if sender.state == .Began{
            
            
            
        }else if sender.state == .Changed{
            change1 = sender.translationInView(self.infoTableView)
            weak var weakSelf = self
            let indesss =  self.changeView!(indexs: change1.y,ory:weakSelf!.types)
            if indesss != 20&&indesss != 106{
                 self.infoTableView.height = HEIGHT-40*px-change1.y
            }else if indesss == 20{
                self.infoTableView.height = HEIGHT-40*px-20
                self.infoTableView.scrollEnabled = true
                self.infoTableView.removeGestureRecognizer(move)
            }else if indesss == 106{
                self.infoTableView.height = HEIGHT-40*px-110
            }
           
            
            
        }else {
            
            begin1 = sender.translationInView(self.infoTableView)
            self.types =  self.changeView!(indexs: begin1.y,ory:self.types)
            NSLOG(begin1)
        }
    }
    
    
    //MARK: ------UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 44*px
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        
        
        
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if self.infoTableView.scrollEnabled{
            if infoTableView.contentOffset.y < -60{
                UIView.animateWithDuration(0.3, animations: {
                    self.changeView!(indexs: 0,ory:106)
                    self.infoTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-110-40*px)
                    
                })
                self.types = 106
                self.infoTableView.scrollEnabled = false
                
                self.infoTableView.addGestureRecognizer(self.move)
                
                
            }
        }
        
        
    }
    
    //MARK: ------TableViewDatasource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return textArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return textArray[section].count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = PublicTableViewCell.init(style:.Default)
        cell.textLabel?.font = UIFont.systemFontOfSize(13)
        cell.textLabel?.text = textArray[indexPath.section][indexPath.row]
        
        cell.accessoryType = .None
        cell.selectionStyle = .None
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UILabel.init(frame: CGRectMake(0, 0, WIDTH, 10))
        headerView.backgroundColor = LGBackColor
        headerView.textColor = MainTextBackColor
        headerView.font = UIFont.systemFontOfSize(12)
        headerView.text = self.headerTitleArray[section]
        return headerView
        
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
