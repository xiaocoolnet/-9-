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
    
//    var a = []
//    var b = []
//    var c = []
//    var d = []
    
    var a = ["mainTitle":"智慧社区","classify":[["image":"fuwudating","text":"服务大厅"],["image":"shequyanglao","text":"社区养老"],["image":"yijiantong","text":"一键通"],["image":"bianminshangcheng-1","text":"便民商城"],["image":"jiatingchufang","text":"家庭厨房"],["image":"wuyefei","text":"物业缴费"],["image":"hulizhan","text":"护理站"],["image":"shequmenzhen","text":"社区门诊"],["image":"efangtianxia","text":"e房天下"]
        ]]
    
    var b = ["mainTitle":"机构养老","classify":[["image":"qiyexinxi","text":"企业信息"],["image":"tuzhurenyuan","text":"入住人员"],["image":"fangjainfenbu","text":"房间分布"],["image":"kaoqianguanli","text":"考勤管理"],
        ["image":"butieguanli","text":"补贴管理"],
        ["image":"caiwuguanli","text":"财务管理"],
        ["image":"renlizhiyuan","text":"人力资源"],
        ["image":"houqinguanli","text":"后勤管理"],["image":"yaofangguanli","text":"药房管理"],["image":"xiaofanganquan","text":"消防安全"]
        ,["image":"yaojainshipin","text":"药检食品"]]]
    
    var c = ["mainTitle":"居家养老","classify":[["image":"jiankangdangan","text":"健康档案"],["image":"ic_anbao","text":"安保＋养老"],["image":"jiatingfuwu","text":"家庭服务"],
        ["image":"peihufuwu","text":"陪护服务"],["image":"jingshenweiji","text":"精神慰藉"],["image":"quanyibaozhang","text":"权益保障"],["image":"shegnhuojiaofei","text":"生活缴费"],["image":"gongjuxinag","text":"工具箱"],["image":"jipiao","text":"机票"],["image":"huochepaio","text":"火车票"],["image":"qichepiao","text":"汽车票"],["image":"didi","text":"滴滴出行"]]]
    
    var d = ["mainTitle":"时尚生活","classify":[["image":"jingshenweiji","text":"精神慰藉"],["image":"quanyibaozhang","text":"权益保障"],["image":"laoniandaxue","text":"老年大学"],
        ["image":"tushuguan","text":"图书馆"],
        ["image":"dianyingyaun","text":"电影院"],["image":"xiaojuyuan","text":"小剧院"]]]
    
    var myDataSource = NSMutableArray()
    var isALLArray = NSMutableArray()
    
    var aIsAll = Bool()
    var bIsAll = Bool()
    var cIsAll = Bool()
    var dIsAll = Bool()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSLOG(WIDTH)
        NSLOG(px)
        
        self.title = "智慧养老"
        myDataSource = [a,c,b,d]
        isALLArray = [aIsAll,bIsAll,cIsAll,dIsAll]
        self.view.backgroundColor = LGBackColor
        self.createUI()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.hidden = false
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
            if (self.myDataSource[indexPath.row].objectForKey("classify") as! NSArray).count > 3{
                return 98*px + WIDTH/2
            }else{
                return 98*px + WIDTH/4
            }
        }else{
            return 98*px + WIDTH/4*CGFloat(((self.myDataSource[indexPath.row].objectForKey("classify") as! NSArray).count)/4+1)+473*px
        }
        
        
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
//        switch indexPath.row {
//        case 0:
//            let homeCareViewController = MapSelectViewController()
//            //        homeCareViewController.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(homeCareViewController, animated: true)
//            break
//        case 2:
//            let homeCareViewController = HPYHomeCareViewController()
//            //        homeCareViewController.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(homeCareViewController, animated: true)
//            break
//        default:
//            break
//        }
        
        NSLOG(indexPath)
    }
    
    
    
    //MARK: ------TableViewDatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = WisdomTableViewCell.init(myDIC: (myDataSource[indexPath.row] as! NSDictionary),isAlll:isALLArray[indexPath.row] as! Bool)
        cell.targets = self
        cell.selectionStyle = .None
        cell.lookAllButton.tag = indexPath.row
        cell.lookAllButton.addTarget(self, action: #selector(self.lookAllButtonAction(_:)), forControlEvents: .TouchUpInside)
        return cell
        
        
        
        
    }

    //MARK: ------Action
    func lookAllButtonAction(sender:UIButton){
        let isalll = self.isALLArray[sender.tag] as! Bool
        sender.setTitle("收起", forState: .Normal)
        sender.setImage(UIImage(named: "shouhui"), forState: .Normal)
            
            
         self.isALLArray[sender.tag] = !isalll
        
        
        self.mytableView.reloadData()
        
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
