//
//  PersonalMessagesRecordsViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 16/12/21.
//  Copyright © 2016年 xiaocool. All rights reserved.
//

import UIKit

class PersonalMessagesRecordsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate {
    
    let myTableView = UITableView()
    let textArray = [["照片","人员编号","姓名","性别","出生日期","联系电话"],["户口类型","住址","身份证","身份证有效期"],["民族","是否党员","婚否"],["医疗保险类型","以往病史","自动病种归类"]]
    var headerImage = UIImage() //头像
    
    var sexStr = String()//性别
    
    let dataPickerView = UIDatePicker()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "个人信息"
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.backgroundColor = LGBackColor
        myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
        myTableView.separatorStyle = .None
        myTableView.sectionFooterHeight = 10*px
        self.myTableView.registerNib(UINib(nibName: "HeaderPhotoTableViewCell",bundle: nil), forCellReuseIdentifier: "HeaderPhotoTableViewCell")
        self.myTableView.registerNib(UINib(nibName: "DoubleLabelTableViewCell",bundle: nil), forCellReuseIdentifier: "DoubleLabelTableViewCell")
        self.myTableView.registerNib(UINib(nibName: "RightArrowAndLabelTableViewCell",bundle: nil), forCellReuseIdentifier: "RightArrowAndLabelTableViewCell")
        self.view.addSubview(myTableView)

        // Do any additional setup after loading the view.
    }
    //创建时间选择器
    func CreatDataPicker(){
        self.dataPickerView.frame = CGRectMake(0, HEIGHT-64-300*px, WIDTH, 200*px)
        self.dataPickerView.datePickerMode = .Date
        self.dataPickerView.backgroundColor = UIColor.whiteColor()
        self.dataPickerView.addTarget(self, action: #selector(self.dataPickerViewAction(_:)), forControlEvents: .ValueChanged)
        self.dataPickerView.maximumDate = NSDate()
    }
    
    //MARK: ------UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        if indexPath.section == 0 && indexPath.row == 0{
            return 51
        }else{
            return 38
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                self.uploadImage()
                break
            case 3:
                let vc = PublicTableViewViewController()
                vc.myArray = ["男","女"]
                vc.myFunc = {(selectText) ->Void in
                    self.sexStr = selectText
                    let index = NSIndexPath.init(forRow: 3, inSection: 0)
                    self.myTableView.reloadRowsAtIndexPaths([index], withRowAnimation:.Automatic)
                }
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 4:
                
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
        return self.textArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell1 = tableView.dequeueReusableCellWithIdentifier("HeaderPhotoTableViewCell", forIndexPath: indexPath)as!HeaderPhotoTableViewCell
                cell1.setUIWithDic(NSDictionary())
                cell1.headerImageView.image = self.headerImage
                cell1.selectionStyle = .None
                cell1.mainLabel.text = self.textArray[indexPath.section][indexPath.row]
                return cell1
                
            }else if indexPath.row == 1{
                let cell2 = tableView.dequeueReusableCellWithIdentifier("DoubleLabelTableViewCell", forIndexPath: indexPath)as!DoubleLabelTableViewCell
                cell2.setUIWithDic(NSDictionary())
                cell2.selectionStyle = .None
                cell2.mainLabel.text = self.textArray[indexPath.section][indexPath.row]
                return cell2
            }else if indexPath.row == 2{
                let cell2 = tableView.dequeueReusableCellWithIdentifier("DoubleLabelTableViewCell", forIndexPath: indexPath)as!DoubleLabelTableViewCell
                cell2.setUIWithDic(NSDictionary())
                cell2.selectionStyle = .None
                cell2.mainLabel.text = self.textArray[indexPath.section][indexPath.row]
                return cell2
            }else if indexPath.row == 3{
                let cell3 = tableView.dequeueReusableCellWithIdentifier("RightArrowAndLabelTableViewCell", forIndexPath: indexPath)as!RightArrowAndLabelTableViewCell
                cell3.setUIWithDic(NSDictionary())
                cell3.lastLabel.text = self.sexStr;
                cell3.selectionStyle = .None
                cell3.mainLabel.text = self.textArray[indexPath.section][indexPath.row]
                cell3.lastLabel.hidden = false
                return cell3
            }else if indexPath.row == 4{
                let cell3 = tableView.dequeueReusableCellWithIdentifier("RightArrowAndLabelTableViewCell", forIndexPath: indexPath)as!RightArrowAndLabelTableViewCell
                cell3.setUIWithDic(NSDictionary())
                cell3.selectionStyle = .None
                cell3.mainLabel.text = self.textArray[indexPath.section][indexPath.row]
                cell3.lastLabel.hidden = true
                return cell3
            }else {
                let cell2 = tableView.dequeueReusableCellWithIdentifier("DoubleLabelTableViewCell", forIndexPath: indexPath)as!DoubleLabelTableViewCell
                cell2.selectionStyle = .None
                cell2.setUIWithDic(NSDictionary())
                cell2.mainLabel.text = self.textArray[indexPath.section][indexPath.row]
                
                return cell2
            }
        }else if indexPath.section == 1{
            let cell3 = tableView.dequeueReusableCellWithIdentifier("RightArrowAndLabelTableViewCell", forIndexPath: indexPath)as!RightArrowAndLabelTableViewCell
            cell3.setUIWithDic(NSDictionary())
            cell3.selectionStyle = .None
            cell3.mainLabel.text = self.textArray[indexPath.section][indexPath.row]
            cell3.lastLabel.hidden = true
            return cell3
//            switch indexPath.row {
//            case 0:
//                break
//            case 1:
//                break
//            case 2:
//                break
//            default:
//                break
//            }
        }else if indexPath.section == 2{
            let cell3 = tableView.dequeueReusableCellWithIdentifier("RightArrowAndLabelTableViewCell", forIndexPath: indexPath)as!RightArrowAndLabelTableViewCell
            cell3.setUIWithDic(NSDictionary())
            cell3.selectionStyle = .None
            cell3.mainLabel.text = self.textArray[indexPath.section][indexPath.row]
            cell3.lastLabel.hidden = true
            return cell3
        }else {
            let cell3 = tableView.dequeueReusableCellWithIdentifier("RightArrowAndLabelTableViewCell", forIndexPath: indexPath)as!RightArrowAndLabelTableViewCell
            cell3.setUIWithDic(NSDictionary())
            cell3.selectionStyle = .None
            cell3.mainLabel.text = self.textArray[indexPath.section][indexPath.row]
            cell3.lastLabel.hidden = true
            return cell3
            
        }
        
//        let cell = UITableViewCell()
//        cell.textLabel?.font = UIFont.systemFontOfSize(13)
//        
//        
//        cell.accessoryType = .DisclosureIndicator
//        cell.selectionStyle = .None
//        
//        return cell
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footView = UIView()
        footView.backgroundColor = LGBackColor
        footView.frame = CGRectMake(0, 0, WIDTH, 10*px)
        
        return footView
    }
    //MARK:--------相册
    
    func uploadImage(){
        
        let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let pictureAssert = UIAlertAction.init(title: "从相册选取", style: UIAlertActionStyle.Default, handler: {
            void in
            self.LocalPhoto()
            
        })
        
        let Camera = UIAlertAction.init(title: "拍照", style: UIAlertActionStyle.Default, handler: {
            void in
            
            self.takePhoto()
            
            
        })
        let canelSelect = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alertController.addAction(Camera)
        alertController.addAction(pictureAssert)
        alertController.addAction(canelSelect)
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    func LocalPhoto(){
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func takePhoto(){
        
        let sourceType = UIImagePickerControllerSourceType.Camera
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = sourceType
            self.presentViewController(picker, animated: true, completion: nil)
        }else{
            print("无法打开相机")
        }
    }
    
    //MARK: -- UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        self.headerImage = (info[UIImagePickerControllerEditedImage] as! UIImage
            )
        let index = NSIndexPath.init(forRow: 0, inSection: 0)
        self.myTableView.reloadRowsAtIndexPaths([index], withRowAnimation:.Automatic)
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK:-------Action
    
    func dataPickerViewAction(sender:UIDatePicker){
        
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
