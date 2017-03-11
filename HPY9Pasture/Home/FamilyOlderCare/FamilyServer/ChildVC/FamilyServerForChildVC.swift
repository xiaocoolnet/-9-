//
//  FamilyServerForChildVC.swift
//  HPY9Pasture
//
//  Created by purepure on 17/2/6.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit

class FamilyServerForChildVC: UIViewController,UITableViewDelegate,UITableViewDataSource {


    let familyServerTableView = UITableView()
    let headerImageArray = ["ic_baojie","ic_zhouqibaojie"]
    let tableHeaderUpLabelText = ["日常保洁","周期保洁"]
    let tableHeaderDownLabelText = ["家庭保洁 预约随心","一次下单 保洁无忧"]
    let cellTopTextArray = ["月嫂","育儿嫂","保姆","专业保洁","家庭维修","家电清洗","生活急救箱"]
    let cellDownTextArray = ["具备专业的知识与技术","全面掌握生活照料、保育方面的相关知识","专业服务，体贴放心","深度清洁，让您的家焕然一新","家电、房屋维修、局部换新（装修）等","拆洗杀菌去污，延长家电寿命","专业除虫、开锁、管道疏通等"]
    let cellImageView = ["ic_yuesao-1","ic_yuersao","ic_yuesao","ic_zhuanyebaojie","ic_jiatingweixiu","ic_jiadianqingxi","ic_shenghuojijiu"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        familyServerTableView.delegate = self
        familyServerTableView.dataSource = self
        familyServerTableView.backgroundColor = LGBackColor
        familyServerTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64-40*px)
        familyServerTableView.separatorStyle = .None
        familyServerTableView.registerClass(PublicTableViewCell.self, forCellReuseIdentifier: "PublicTableViewCell")
//        familyServerTableView.sectionFooterHeight = 10*px
        self.view.addSubview(familyServerTableView)
        self.creatUI()

        // Do any additional setup after loading the view.
    }
    
    func creatUI(){
        let tableHeaderBackView = UIView.init(frame: CGRectMake(0, 0, WIDTH, 115*px))
        for index in 0...1 {
            let dayCleanView = UIView.init(frame: CGRectMake(CGFloat(index)*WIDTH/2, 9*px, WIDTH/2, 97*px))
            dayCleanView.backgroundColor = UIColor.whiteColor()
            let leftImageView = UIImageView.init(frame: CGRectMake(6*px, 0, 50*px, 97*px))
            leftImageView.image = UIImage(named: headerImageArray[index])
            leftImageView.contentMode = .Center
            dayCleanView.addSubview(leftImageView)
            
            let upLabel = UILabel.init(frame: CGRectMake(60*px, 30*px, 100*px, 20*px))
            upLabel.text = self.tableHeaderUpLabelText[index]
            upLabel.font = MainFont
            upLabel.textColor = MainTextColor
            upLabel.textAlignment = .Left
            dayCleanView.addSubview(upLabel)
            
            let downLabel = UILabel.init(frame: CGRectMake(60*px, 50*px, WIDTH/2-63*px, 20*px))
            downLabel.text = self.tableHeaderDownLabelText[index]
            downLabel.font = UIFont.systemFontOfSize(11)
            downLabel.textColor = MainTextBackColor
            downLabel.textAlignment = .Left
            dayCleanView.addSubview(downLabel)
            
            let backClearButton = UIButton.init(frame: dayCleanView.frame)
            backClearButton.backgroundColor = UIColor.clearColor()
            backClearButton.tag = index
            backClearButton.addTarget(self, action: #selector(self.backClearButton(_:)), forControlEvents: .TouchUpInside)
            
            tableHeaderBackView.addSubview(dayCleanView)
            tableHeaderBackView.addSubview(backClearButton)
            
            
            
        }
        let lineBackView = UIView.init(frame: CGRectMake(WIDTH/2-0.5, 5+9*px, 1, 97*px-10))
        lineBackView.backgroundColor = RGBACOLOR(160, g: 160, b: 160, a: 1)
        
        tableHeaderBackView.addSubview(lineBackView)
        
        self.familyServerTableView.tableHeaderView = tableHeaderBackView
        
        
        
    }
    
    //MARK: ------UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 70*px
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        switch indexPath.row {
        case 0:
            
            let vc = InvoiceViewController()
            vc.headerTextArray = ["选择地址","工作性质","工作时长（天）","选择开始时间","说明"]
            vc.cellTextArray = [[""],["请选择工作性质"],["1"],[""],[""]]
            vc.title = "月嫂"
            vc.type = String(indexPath.row+2)
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 1:
            let vc = InvoiceViewController()
            vc.headerTextArray = ["选择地址","工作性质","工作时长（天）","选择开始时间","说明"]
            vc.cellTextArray = [[""],["请选择工作性质"],["1"],[""],[""]]
            vc.title = "育儿嫂"
            vc.type = String(indexPath.row+2)
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 2:
            let vc = InvoiceViewController()
            vc.headerTextArray = ["选择地址","工作性质","工作时长（天）","选择开始时间","说明"]
            vc.cellTextArray = [[""],["请选择工作性质"],["1"],[""],[""]]
            vc.title = "保姆"
            vc.type = String(indexPath.row+2)
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 3:
            let vc = InvoiceViewController()
            vc.headerTextArray = ["选择地址","选择清洁范围","选择第一次开始时间","说明"]
            vc.cellTextArray = [[""],["请选择清洁范围"],[""],[""]]
            vc.title = "专业保洁"
            vc.type = String(indexPath.row+2)
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 4:
            let vc = InvoiceViewController()
            vc.headerTextArray = ["选择地址","选择维修物品","选择开始时间","说明"]
            vc.cellTextArray = [[""],["请选择维修物品"],[""],[""]]
            vc.title = "家庭维修"
            vc.type = String(indexPath.row+2)
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 5:
            let vc = InvoiceViewController()
            vc.headerTextArray = ["选择地址","清洗物品","选择开始时间","说明"]
            vc.cellTextArray = [[""],["请选择清洗物品"],[""],[""]]
            vc.title = "家电清洗"
            vc.type = String(indexPath.row+2)
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 6:
            let vc = InvoiceViewController()
            vc.headerTextArray = ["选择地址","选择服务类型","选择开始时间","说明"]
            vc.cellTextArray = [[""],["请选择服务类型"],[""],[""]]
            vc.title = "生活急救箱"
            vc.type = String(indexPath.row+2)
            self.navigationController?.pushViewController(vc, animated: true)
            break
        default:
            break
        }
            
    }
    
    //MARK: ------TableViewDatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return cellTopTextArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = PublicTableViewCell.init(style:.Subtitle)
        cell.selectionStyle = .None
        cell.textLabel?.text = self.cellTopTextArray[indexPath.row]
        cell.textLabel?.font = MainFont
        cell.detailTextLabel?.text = self.cellDownTextArray[indexPath.row]
        cell.detailTextLabel?.textColor = MainTextBackColor
        cell.detailTextLabel?.font = UIFont.systemFontOfSize(11)
        cell.imageView?.image = UIImage(named: self.cellImageView[indexPath.row])
        cell.accessoryType = .DisclosureIndicator
        return cell
    }
    //MARK:ACTION
    func backClearButton(sender:UIButton){
        if sender.tag == 0{
            let vc = InvoiceViewController()
            vc.headerTextArray = ["选择地址","打扫时长","选择开始时间","说明"]
            vc.cellTextArray = [[""],["2小时"],[""],[""]]
            vc.title = "日常保洁"
            vc.type = "0"
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = InvoiceViewController()
            vc.headerTextArray = ["选择地址","打扫时长","打扫频率","打扫总次数","选择第一次开始时间","说明"]
            vc.cellTextArray = [[""],["2小时"],["两周一次"],["2"],[""],[""]]
            vc.title = "周期保洁"
            vc.type = "1"
            self.navigationController?.pushViewController(vc, animated: true)
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
