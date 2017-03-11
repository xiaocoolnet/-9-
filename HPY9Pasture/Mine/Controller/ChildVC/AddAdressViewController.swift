//
//  AddAdressViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 17/3/7.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit

class AddAdressViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let mytableView = UITableView()
    var sarchModel:BMKPoiInfo?
    let textArray:Array<String> = ["联系人","手机号","您的地址","门牌号"]
    let placeholderArray:Array<String> = ["您的姓名","您的联系电话","小区/写字楼等","详细地址"]
    var textConmentArray:Array<String> = ["","","",""]
    var textfieldArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "新增地址"
        self.view.backgroundColor = LGBackColor
        self.mytableView.frame = CGRectMake(0, 10*px, WIDTH, HEIGHT-64-43*px)
        self.mytableView.delegate = self
        self.mytableView.dataSource = self
        self.mytableView.backgroundColor = LGBackColor
        self.mytableView.separatorStyle = .None
        self.mytableView.registerNib(UINib(nibName: "AddAdressTableViewCell",bundle: nil), forCellReuseIdentifier: "AddAdressTableViewCell")
        
        let footBackView = UIView.init(frame: CGRectMake(0, 0, WIDTH, 100*px))
        footBackView.backgroundColor = LGBackColor
        let saveButton = UIButton.init(frame: CGRectMake(10, 30, WIDTH-20, 30))
        saveButton.backgroundColor = NavColor
        saveButton.setTitle("保存", forState: .Normal)
        saveButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        saveButton.titleLabel?.font = MainFont
        saveButton.layer.masksToBounds = true
        saveButton.addTarget(self, action: #selector(self.saveButtonAction), forControlEvents: .TouchUpInside)
        saveButton.layer.cornerRadius = 5
        footBackView.addSubview(saveButton)
        self.mytableView.tableFooterView = footBackView
        
        self.view.addSubview(self.mytableView)

        // Do any additional setup after loading the view.
    }
    //MARK: ------UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 44
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if indexPath.row == 2{
            let homeCareViewController = MapSelectViewController()
            homeCareViewController.mapBlock = {(mapInfo) ->Void in
                self.sarchModel = mapInfo
                self.textConmentArray[2] = self.sarchModel!.name
                self.mytableView.reloadRowsAtIndexPaths([NSIndexPath.init(forRow: 2, inSection: 0)], withRowAnimation: .Automatic)
            }
            self.navigationController?.pushViewController(homeCareViewController, animated: true)
        }
    }
    //MARK: ------TableViewDatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return textArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("AddAdressTableViewCell", forIndexPath: indexPath)as!AddAdressTableViewCell
        cell.selectionStyle = .None
        if indexPath.row == 2{
            cell.creatUI(true)
            cell.accessoryType = .DisclosureIndicator
        }else{
            cell.creatUI(false)
        }
        if indexPath.row == 1{
            cell.mytextField.keyboardType = .NumberPad
        }
        cell.mytextField.text = textConmentArray[indexPath.row]
        cell.mytextField.tag = indexPath.row
        cell.mytextField.addTarget(self, action: #selector(self.mytextFieldAction(_:)), forControlEvents: .EditingChanged)
        self.textfieldArray.addObject(cell.mytextField)
        cell.lebel.text = textArray[indexPath.row]
        cell.mytextField.placeholder = placeholderArray[indexPath.row]
        return cell
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        for textfield in self.textfieldArray {
            if (textfield as! UITextField).isFirstResponder(){
                (textfield as! UITextField).resignFirstResponder()
            }
        }
    }
    //MARK:-----ACTION
    func mytextFieldAction(sender:UITextField){
        
        self.textConmentArray[sender.tag] = sender.text!
    
        
    }
    func saveButtonAction(){
        if self.textConmentArray[0] == ""||self.textConmentArray[1] == ""||self.textConmentArray[2] == ""{
         Alert.shareManager.alert("请完善信息", delegate: self)
            return
        }
        if USERLC != nil && USERLC!["userid"] != nil{
            AppRequestManager.shareManager.AddAddress(USERLC!["userid"] as! String, address: self.sarchModel!.name+self.textConmentArray[3], longitude: String((self.sarchModel?.pt.longitude)!), latitude: String((self.sarchModel?.pt.latitude)!), isdefault: "",name: self.textConmentArray[0],phone:self.textConmentArray[1], handle: { (success, response) in
                if success{
                    self.navigationController?.popViewControllerAnimated(true)
                }else{
                    Alert.shareManager.alert("保存失败", delegate: self)
                }
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
