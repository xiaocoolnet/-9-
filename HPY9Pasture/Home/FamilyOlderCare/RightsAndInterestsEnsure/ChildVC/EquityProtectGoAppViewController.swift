//
//  EquityProtectGoAppViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 17/3/9.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit

class EquityProtectGoAppViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {
    let mytableView = UITableView()
    let textview = UITextView()
    var headerView:LawHelpTableViewCell?
    let tatolMoenylabel = UILabel()
    var timeforWork = NSMutableDictionary()
    let textArray:Array<Array<String>> = [["姓名","手机号","性别","年龄","地址"],["预约方式","预约时长","预约时间"],[]]
    var rightTextArray:Array<Array<String>> = [["","","","",""],["","",""],[""]]
    let headerArray:Array<String> = ["预约信息","","留言"]
    var adressinfo:addressInfo?
    var price = Float()
    var counts = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        self.title = "预约信息"
        
        timeforWork = ["2小时":2,"2.5小时":2.5,"3小时":3,"3.5小时":3.5,"4小时":4,"4.5小时":4.5,"5小时":5,"5.5小时":5.5,"6小时":6]
        self.view.backgroundColor = LGBackColor
        self.mytableView.frame = CGRectMake(0, 0*px, WIDTH, HEIGHT-64-51*px)
        self.mytableView.delegate = self
        self.mytableView.dataSource = self
        self.mytableView.backgroundColor = UIColor.whiteColor()
        self.mytableView.separatorStyle = .None
//        self.mytableView.sectionHeaderHeight = 38*px
        self.mytableView.registerNib(UINib(nibName: "RightArrowAndLabelTableViewCell",bundle: nil), forCellReuseIdentifier: "RightArrowAndLabelTableViewCell")
        self.view.addSubview(self.mytableView)
        
        let headerBackView = UIView.init(frame: CGRectMake(0, 0, WIDTH, 80))
        self.headerView =  NSBundle.mainBundle().loadNibNamed("LawHelpTableViewCell", owner: nil, options: nil).first as? LawHelpTableViewCell
        self.headerView!.headerImage.backgroundColor = UIColor.redColor()
        self.headerView!.name.text = "纯纯"
        self.headerView!.adress.text = "青岛市市北区"
        self.headerView!.disLabel.text = "已帮助3524545人解决问题"
        headerBackView.addSubview(self.headerView!)
        self.mytableView.tableHeaderView = headerBackView
        
        let footBackView = UIView.init(frame: CGRectMake(0, 0, WIDTH, 180*px))
        footBackView.backgroundColor = LGBackColor
        self.textview.frame = CGRectMake(20*px, 0, WIDTH-40*px, 170*px)
        self.textview.layer.masksToBounds = true
        self.textview.layer.cornerRadius = 10*px
        self.textview.delegate = self
        self.textview.backgroundColor = UIColor.whiteColor()
        self.textview.textColor = MainTextBackColor
        self.textview.text = "(请留下您的要求)"
        self.textview.font = MainFont
        footBackView.addSubview(self.textview)
        self.mytableView.tableFooterView = footBackView
        
        
        self.tatolMoenylabel.textColor = RGBACOLOR(255, g: 172, b: 49, a: 1)
        self.tatolMoenylabel.font = MainFont
        self.tatolMoenylabel.frame = CGRectMake(0, HEIGHT-64-40*px, WIDTH-100*px, 40*px)
        
        
        self.tatolMoenylabel.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.tatolMoenylabel)
        
        let goButton = UIButton.init(frame: CGRectMake(WIDTH-100*px, HEIGHT-64-40*px, 100*px, 40*px))
        goButton.backgroundColor = RGBACOLOR(81, g: 166, b: 255, a: 1)
        goButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        goButton.setTitle("立即预约", forState: .Normal)
        goButton.addTarget(self, action: #selector(self.goButtonAction), forControlEvents: .TouchUpInside)
        goButton.titleLabel?.font = MainFont
        self.view.addSubview(goButton)

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
        
        if indexPath.section == 0{
            switch indexPath.row {
            case 0:
                let vc = PublicTextEditViewController()
                vc.title = self.textArray[indexPath.section][indexPath.row]
                vc.leftTextLabelText = self.textArray[indexPath.section][indexPath.row]+":"
                vc.myFunc = {(editedText) ->Void in
                    self.rightTextArray[indexPath.section][indexPath.row] = editedText as String
                    self.mytableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation:.Automatic)
                    vc.navigationController?.popViewControllerAnimated(true)
                }
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 1:
                let vc = PublicTextEditViewController()
                vc.title = self.textArray[indexPath.section][indexPath.row]
                vc.leftTextLabelText = self.textArray[indexPath.section][indexPath.row]+":"
                vc.textField.keyboardType = .NumberPad
                vc.myFunc = {(editedText) ->Void in
                    self.rightTextArray[indexPath.section][indexPath.row] = editedText as String
                    self.mytableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation:.Automatic)
                    vc.navigationController?.popViewControllerAnimated(true)
                }
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            case 2:
                let vc = PublicTableViewViewController()
                vc.myArray = ["男","女"]
                vc.title = self.textArray[indexPath.section][indexPath.row]
                vc.myFunc = {(selectText,index) ->Void in
                    self.rightTextArray[indexPath.section][indexPath.row] = selectText as String
                    self.mytableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation:.Automatic)
                    vc.navigationController?.popViewControllerAnimated(true)
                }
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 3:
                let vc = PublicTextEditViewController()
                vc.title = self.textArray[indexPath.section][indexPath.row]
                vc.leftTextLabelText = self.textArray[indexPath.section][indexPath.row]+":"
                vc.textField.keyboardType = .NumberPad
                vc.myFunc = {(editedText) ->Void in
                    self.rightTextArray[indexPath.section][indexPath.row] = editedText as String
                    self.mytableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation:.Automatic)
                    vc.navigationController?.popViewControllerAnimated(true)
                }
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 4:
                let vc = AdressEditViewController()
                vc.isselected = true
                vc.addressBlock = {(adressinfo) -> Void in
                    self.adressinfo = adressinfo
                    self.rightTextArray[indexPath.section][indexPath.row] = adressinfo.adress
                    self.mytableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation:.Automatic)
                    vc.navigationController?.popViewControllerAnimated(true)
                }
                self.navigationController?.pushViewController(vc, animated: true)
                break
            default:
                break
            }
        }else if indexPath.section == 1{
            switch indexPath.row {
            case 0:
                let vc = PublicTableViewViewController()
                vc.myArray = ["上门","不上门"]
                vc.title = self.textArray[indexPath.section][indexPath.row]
                vc.myFunc = {(selectText,index) ->Void in
                    self.rightTextArray[indexPath.section][indexPath.row] = selectText as String
                    self.mytableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation:.Automatic)
                    self.price = 100
                    self.changeMoneyTotal()
                    vc.navigationController?.popViewControllerAnimated(true)
                }
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 1:
                let vc = PublicTableViewViewController()
                vc.title = self.textArray[indexPath.section][indexPath.row]
                vc.myArray = ["2小时","2.5小时","3小时","3.5小时","4小时","4.5小时","5小时","5.5小时","6小时"]
                vc.myFunc = {[unowned self](selectText,index) ->Void in
                    self.rightTextArray[indexPath.section][indexPath.row]  = selectText
                    self.mytableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Bottom)
                    
                        self.counts = self.timeforWork.objectForKey(selectText) as! Int
                    
                    self.changeMoneyTotal()
                        
                    
                    
                    vc.navigationController?.popViewControllerAnimated(true)
                }
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 2:
                TimeSelector.shareManager.CreatDataPicker(self,height:HEIGHT-64) { (timestr, date) in
                    self.rightTextArray[indexPath.section][indexPath.row]  = timestr
                    self.mytableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Bottom)
                }
                break
            default:
                break
            }
        }
        

    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0||section == 2{
            return 30*px
        }else{
            return 10*px
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.textview.resignFirstResponder()
    }
    
    //MARK: -----textViewDelegate
    
    func textViewDidBeginEditing(textView: UITextView) {
        self.mytableView.contentOffset = CGPointMake(0, 300)
        self.textview.becomeFirstResponder()
        if self.textview == textView {
            if textview.text ==  "(请留下您的要求)"{
                self.textview.text = ""
            }else{
                
            }
        }
        self.textview.textColor = UIColor.blackColor()
    }
    //MARK: ------TableViewDatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return textArray[section].count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return textArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("RightArrowAndLabelTableViewCell", forIndexPath: indexPath)as!RightArrowAndLabelTableViewCell
        cell.setUIWithDic(NSDictionary())
        cell.mainLabel?.text = self.textArray[indexPath.section][indexPath.row]
        cell.lastLabel?.text = self.rightTextArray[indexPath.section][indexPath.row]
        cell.selectionStyle = .None
        return cell
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let backView = UIView.init()
        backView.backgroundColor = LGBackColor
        if section == 0||section == 2{
            backView.frame = CGRectMake(0, 0, WIDTH, 30*px)
            
            let downView = UILabel.init(frame: CGRectMake(0, 0*px, WIDTH, 30*px))
            downView.text = "   " + self.headerArray[section]
            downView.textColor = MainTextBackColor
            downView.font = UIFont.systemFontOfSize(12)
            downView.backgroundColor = LGBackColor
            backView.addSubview(downView)
        }else{
            backView.frame = CGRectMake(0, 0, WIDTH, 10*px)
        }
        
        return backView
    }
    
    func changeMoneyTotal(){
        
        self.tatolMoenylabel.text = "    费用总计：" + String(format: "%.2f",self.price*Float(self.counts) )+"元"
    }
    
    //MARK:-----ACTION
    func goButtonAction(){
        
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
