//
//  WisdomControllerViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 16/11/1.
//  Copyright © 2016年 xiaocool. All rights reserved.
//

import UIKit

class WisdomControllerViewController: UIViewController,SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource {
    
    let mytableView = UITableView()
    
    var a = ["mainTitle":"智慧社区","classify":[["image":"rijianzhaol","text":"日常照料"],["image":"zhulaoshitang","text":"助老食堂"],["image":"huzhuyanglao","text":"互助养老"],["image":"kangfuzhognxin","text":"康复中心"],["image":"yuanchegnrenzheng","text":"远程认证"],["image":"shequjianjie","text":"社区简介"],["image":"wuyefei","text":"物业费"],["image":"disanfang","text":"第三方缴费"],["image":"xinxiqiang","text":"信息墙"],["image":"bianminshangcheng-1","text":"便民商城"],["image":"yijiantong","text":"一键通"],["image":"shipindating","text":"视频大厅"]]]
    
    var b = ["mainTitle":"机构养老","classify":[["image":"qiyexinxi","text":"企业信息"],["image":"tuzhurenyuan","text":"入住人员"],["image":"renlizhiyuan","text":"人力资源"],["image":"kaoqianguanli","text":"考勤管理"],["image":"houqinguanli","text":"后勤管理"],["image":"butieguanli","text":"补贴管理"],["image":"caiwuguanli","text":"财务管理"],["image":"shipindating","text":"视频大厅"]]]
    
    var c = ["mainTitle":"居家养老","classify":[["image":"bianminshangcheng-1","text":"便民商城"],["image":"jiatingfuwu","text":"家庭服务"],["image":"peihufuwu","text":"陪护服务"],["image":"gongjuxinag","text":"工具箱"],["image":"hulizhan","text":"护理站"],["image":"anbao","text":"安保＋养老"]]]
    
    var d = ["mainTitle":"时尚生活","classify":[["image":"laoniandaxue","text":"老年大学"],["image":"xiaojuyuan","text":"小剧院"],["image":"组1","text":"文娱室"],["image":"dianyingyaun","text":"电影院"]]]
    
    var myDataSource = NSMutableArray()
    var isALLArray = NSMutableArray()
    
    var aIsAll = Bool()
    var bIsAll = Bool()
    var cIsAll = Bool()
    var dIsAll = Bool()
    
    
//    [["mainTitle":"智慧社区","classify":[["image":"","text":"日常照料"],["image":"","text":"助老食堂"],["image":"","text":"互助养老"],["image":"","text":"康复中心"],["image":"","text":"远程认证"],["image":"","text":"社区简介"],["image":"","text":"物业费"],["image":"","text":"第三方缴费"],["image":"","text":"信息墙"],["image":"","text":"便民商城"],["image":"","text":"一键通"],["image":"","text":"视频大厅"]]],["mainTitle":"机构养老","classify":[["image":"","text":"企业信息"],["image":"","text":"入住人员"],["image":"","text":"人力资源"],["image":"","text":"考勤管理"],["image":"","text":"后勤管理"],["image":"","text":"补贴管理"],["image":"","text":"财务管理"],["image":"","text":"视频大厅"]]],["mainTitle":"居家养老","classify":[["image":"","text":"便民商城"],["image":"","text":"家庭服务"],["image":"","text":"陪护服务"],["image":"","text":"工具箱"],["image":"","text":"护理站"],["image":"","text":"安保＋养老"]]],["mainTitle":"时尚生活","classify":[["image":"","text":"老年大学"],["image":"","text":"小剧院"],["image":"","text":"文娱室"],["image":"","text":"电影院"]]]]
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "智慧养老"
        myDataSource = [a,b,c,d]
        isALLArray = [aIsAll,bIsAll,cIsAll,dIsAll]
        self.view.backgroundColor = LGBackColor
        self.createUI()
        // Do any additional setup after loading the view.
    }

    func createUI(){
        
        mytableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
        mytableView.backgroundColor = LGBackColor
        mytableView.delegate = self
        mytableView.dataSource = self
        mytableView.sectionHeaderHeight = 10
        mytableView.separatorStyle = .None
        mytableView.tableFooterView = UIView()
        mytableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "PublicTableViewCell")
        self.view.addSubview(mytableView)
        
        
    }
    
    
    //MARK: ------TableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        if (self.isALLArray[indexPath.row] as! Bool) == false{
            if (self.myDataSource[indexPath.row].objectForKey("classify") as! NSArray).count > 4{
                return 98*px + WIDTH/2
            }else{
                return 98*px + WIDTH/4
            }
        }else{
            return 98*px + WIDTH/4*CGFloat(((self.myDataSource[indexPath.row].objectForKey("classify") as! NSArray).count)/4+1)
        }
        
        
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        switch indexPath.row {
        case 0:
            let homeCareViewController = MapSelectViewController()
            //        homeCareViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(homeCareViewController, animated: true)
            break
        case 2:
            let homeCareViewController = HPYHomeCareViewController()
            //        homeCareViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(homeCareViewController, animated: true)
            break
        default:
            break
        }
        
        NSLOG(indexPath)
    }
    
    
    
    //MARK: ------TableViewDatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
//        let cell = tableView.dequeueReusableCellWithIdentifier("mytableViewCell", forIndexPath: indexPath)
        let cell = WisdomTableViewCell.init(myDIC: (myDataSource[indexPath.row] as! NSDictionary),isAlll:isALLArray[indexPath.row] as! Bool)
        let myarray = myDataSource[indexPath.row].objectForKey("classify") as! NSArray
        if myarray.count > 8{
            cell.lookAllButton.hidden = false
            cell.lookAllButton.tag = indexPath.row
            cell.lookAllButton.addTarget(self, action: #selector(self.lookAllButtonAction(_:)), forControlEvents: .TouchUpInside)
        }else{
            cell.lookAllButton.hidden = true
            
        }
       
        return cell
        
        
        
        
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let mysectionView = UILabel()
        mysectionView.backgroundColor = LGBackColor
        mysectionView.frame = CGRectMake(0, 0, Screen_W, 10)
        return mysectionView
        
    }
    
    func lookAllButtonAction(sender:UIButton){
        let isalll = self.isALLArray[sender.tag] as! Bool
            
            
         self.isALLArray[sender.tag] = !isalll
        
        
        self.mytableView.reloadData()
        
//        let indexs = NSIndexPath.init(forRow: sender.tag, inSection: 0)
//        let cell = mytableView.cellForRowAtIndexPath(indexs) as! WisdomTableViewCell
//        mytableView.beginUpdates()
//        cell.isAll = !cell.isAll
//        mytableView.endUpdates()
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
