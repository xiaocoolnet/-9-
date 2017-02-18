//
//  PersonalMessagesViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 16/12/20.
//  Copyright © 2016年 xiaocool. All rights reserved.
//

import UIKit

class PersonalMessagesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    let myTableView = UITableView()
    let textArray = [["个人信息档案"],["个人体检信息档案"],["个人服药信息档案","个人医嘱信息档案"]]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "个人信息"
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.backgroundColor = LGBackColor
        myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
        myTableView.separatorStyle = .None
        myTableView.sectionFooterHeight = 10*px
        self.view.addSubview(myTableView)

        // Do any additional setup after loading the view.
    }
    
    //MARK: ------UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 44*px
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if indexPath.section == 0{
            if indexPath.row == 0 {
                let vc = PersonalMessagesRecordsViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if indexPath.section == 1{
            switch indexPath.row {
//            case 0:
//                let vc = FamilyMessagesViewController()
//                vc.textArray = ["00001","00002","00003","00004"]
//                vc.title = "个人过敏信息档案"
//                vc.buttonText = "添加过敏史"
//                vc.myFunc = {()->Void in
//                    //添加家族信息事件
//                    let vc1 = AddAllergyRecordsViewController()
//                    vc1.title = "添加过敏史"
//                    
//                    vc.navigationController?.pushViewController(vc1, animated: true)
//                }
//                vc.myIndexFunc = {(selectIndex,selectArray)->Void in
//                    //添加cell点击事件
//                    //                vc.navigationController?.pushViewController(vc1, animated: true)
//                }
//                self.navigationController?.pushViewController(vc, animated: true)
//                break
            case 0:
                let vc = FamilyMessagesViewController()
                vc.textArray = ["00001","00002","00003","00004"]
                vc.title = "个人体检信息档案"
                vc.buttonText = "添加体检信息"
                vc.myFunc = {()->Void in
                    //添加家族信息事件
                    let vc1 = AddPhysicalExaminationViewController()
                    vc1.title = "添加体检信息"
                    
                    vc.navigationController?.pushViewController(vc1, animated: true)
                }
                vc.myIndexFunc = {(selectIndex,selectArray)->Void in
                    //添加cell点击事件
                    //                vc.navigationController?.pushViewController(vc1, animated: true)
                }
                self.navigationController?.pushViewController(vc, animated: true)
                break
            default:
                break
            }
        }else if indexPath.section == 2{
            switch indexPath.row {
            case 0:
                let vc = FamilyMessagesViewController()
                vc.textArray = ["00001","00002","00003","00004"]
                vc.title = "个人服药档案"
                vc.buttonText = "添加服药信息"
                vc.myFunc = {()->Void in
                    //添加家族信息事件
                    let vc1 = AddMedicationMessagesViewController()
                    vc1.title = "添加服药信息"
                    
                    vc.navigationController?.pushViewController(vc1, animated: true)
                }
                vc.myIndexFunc = {(selectIndex,selectArray)->Void in
                    //添加cell点击事件
                    //                vc.navigationController?.pushViewController(vc1, animated: true)
                }
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 1:
                let vc = FamilyMessagesViewController()
                vc.textArray = ["00001","00002","00003","00004"]
                vc.title = "个人医嘱信息档案"
                vc.buttonText = "添加医嘱"
                vc.myFunc = {()->Void in
                    //添加家族信息事件
                    let vc1 = AddDoctorOrderViewController()
                    vc1.title = "添加医嘱"
                    
                    vc.navigationController?.pushViewController(vc1, animated: true)
                }
                vc.myIndexFunc = {(selectIndex,selectArray)->Void in
                    //添加cell点击事件
                    //                vc.navigationController?.pushViewController(vc1, animated: true)
                }
                self.navigationController?.pushViewController(vc, animated: true)
                break
            default:
                break
            }
        }
    }
    
    
    //MARK: ------TableViewDatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{

        return self.textArray[section].count
        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return textArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = UITableViewCell()
        cell.textLabel?.font = UIFont.systemFontOfSize(13)

        cell.textLabel?.text = textArray[indexPath.section][indexPath.row]
        cell.accessoryType = .DisclosureIndicator
        cell.selectionStyle = .None
        
        return cell
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footView = UIView()
        footView.backgroundColor = LGBackColor
        footView.frame = CGRectMake(0, 0, WIDTH, 10*px)
        
        return footView
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
