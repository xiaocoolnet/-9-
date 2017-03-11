//
//  ClothesWashServerForChildVC.swift
//  HPY9Pasture
//
//  Created by purepure on 17/2/6.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit
import SwiftyJSON

struct clothsType {
    var projectid = String()
    var name = String()
    var price = String()
    var haschild = String()
}

class ClothesWashServerForChildVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource{
    

    let clothsTabelView = UITableView()
    let PickerBackView = UIView()
    let PickerView = UIPickerView()
    let tatolMoenylabel = UILabel()
    var money = Double()
    var countArray :Array<String> = []
    var counts = Int()
    var userinfo:Array<JSON> = []
    let colthsTypeArray = ["洗衣","洗鞋","洗衣纺","洗窗帘","配件"]
    var textArray:Array<Array<String>> = [["  请选择或添加收货地址","请选择取件时间"],["请选择您需要的服务","添加服务内容"]]
    var clothsTypeArray:Array<Array<clothsType>> = []//洗衣类型小类
    var clothsTypes:Array<String> = []
    var diselectedClothsTypes:Array<clothsType> = []
    var diselectedClothsType : clothsType!
    var typeCounts = 0
    
    
    var adressinfo:addressInfo?
    var timeStr = String()
    
    
    // 懒加载(毛玻璃效果)
    lazy var lasyEffectView:UIVisualEffectView = {
        // iOS8 系统才有
        let tempEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.ExtraLight))
        tempEffectView.frame = self.view.bounds;
        tempEffectView.alpha = 0.8
        // 添加手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.effectViewTouch(_:)))
        tempEffectView.addGestureRecognizer(tap)
        return tempEffectView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let dateFormatter = NSDateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd EEE HH:mm"
        self.timeStr = dateFormatter.stringFromDate(NSDate())

        clothsTabelView.sectionHeaderHeight = 10*px
        clothsTabelView.delegate = self
        clothsTabelView.dataSource = self
        clothsTabelView.backgroundColor = LGBackColor
        clothsTabelView.frame = CGRectMake(0,0 , WIDTH, HEIGHT-64-43*px-50*px)
        clothsTabelView.separatorStyle = .None
        self.clothsTabelView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "PublicTableViewCell")
        self.clothsTabelView.registerNib(UINib(nibName: "RightArrowAndLabelTableViewCell",bundle: nil), forCellReuseIdentifier: "RightArrowAndLabelTableViewCell")
        self.view.addSubview(clothsTabelView)
        
        
        self.tatolMoenylabel.textColor = RGBACOLOR(255, g: 172, b: 49, a: 1)
        self.tatolMoenylabel.font = MainFont
        self.tatolMoenylabel.frame = CGRectMake(0, HEIGHT-64-50*px-43*px, WIDTH-100*px, 50*px)
        self.tatolMoenylabel.text =  "    费用总计：0.00"  + "元"
        
        
        
        self.tatolMoenylabel.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.tatolMoenylabel)
        
        let goButton = UIButton.init(frame: CGRectMake(WIDTH-100*px, HEIGHT-64-43*px-50*px, 100*px, 50*px))
        goButton.backgroundColor = RGBACOLOR(81, g: 166, b: 255, a: 1)
        goButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        goButton.setTitle("立即预约", forState: .Normal)
        goButton.addTarget(self, action: #selector(self.goButtonAction), forControlEvents: .TouchUpInside)
        goButton.titleLabel?.font = MainFont
        self.view.addSubview(goButton)

        
        self.getclothsType()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func changeMoney(){
        var money2 = Double()
        var count = 0
        for diselectedClothsType1 in self.diselectedClothsTypes {
            money2 = money2+Double(diselectedClothsType1.price)!*Double(self.countArray[count])!
            count+=1
        }
        self.money = money2
        self.tatolMoenylabel.text =  "    费用总计：" + String(format: "%.2f",self.money) + "元"
    }
    
    func getclothsType(){
        AppRequestManager.shareManager.GetLaundryProjectList { [unowned self](success, response) in
            if success{
                let typeInfo = JSON(data: response as! NSData)
                if typeInfo["data"].array != nil{
                    for types in typeInfo["data"].array!{
                        
                        var clothsTypeArray:Array<clothsType> = []
                        
                        if types["childlist"].array != nil{
                            for delType in types["childlist"].array!{
                                
                                var typesforcloth = clothsType()
                                typesforcloth.projectid = delType["projectid"].string != nil ? delType["projectid"].string! : ""
                                typesforcloth.name = delType["name"].string != nil ? delType["name"].string! : ""
                                typesforcloth.price = delType["price"].string != nil ? delType["price"].string! : ""
                                typesforcloth.haschild = delType["haschild"].string != nil ? delType["haschild"].string! : ""
                                clothsTypeArray.append(typesforcloth)
                                if self.diselectedClothsType == nil{
                                    self.diselectedClothsType = typesforcloth
                                }
                            }

                            self.clothsTypes.append(types["name"].string != nil ? types["name"].string!:"")
                            self.clothsTypeArray.append(clothsTypeArray)
                        }
                        
                        
                        
                    }
                }
                self.PickerView.reloadAllComponents()
                
            }else{
                
            }
        }
    }
    
    
    //创建选择器
    func CreatPicker(){
        
        self.PickerBackView.frame = CGRectMake(0, HEIGHT, WIDTH, 320*px)
        self.PickerBackView.backgroundColor = UIColor.whiteColor()
        let PickerHeaderLabel = UILabel.init(frame: CGRectMake(0, 0, WIDTH, 50*px))
        PickerHeaderLabel.text = "洗护种类选择"
        
        
        
        PickerHeaderLabel.font = UIFont.systemFontOfSize(15)
        PickerHeaderLabel.textAlignment = .Center
        PickerHeaderLabel.backgroundColor = NavColor
        PickerHeaderLabel.textColor = UIColor.whiteColor()
        PickerBackView.addSubview(PickerHeaderLabel)
        
        
        self.PickerView.frame = CGRectMake(0, 50*px, WIDTH, 200*px)
        self.PickerView.delegate = self
        self.PickerView.dataSource = self
        self.PickerView.backgroundColor = UIColor.whiteColor()
        
        
        self.PickerBackView.addSubview(self.PickerView)
        
        let PickerCancelButton = UIButton.init(frame: CGRectMake(40*px, self.PickerView.frame.origin.y+self.PickerView.height+15*px, 100*px, 35*px))
        PickerCancelButton.backgroundColor = NavColor
        PickerCancelButton.setTitle("取消", forState: .Normal)
        PickerCancelButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        PickerCancelButton.addTarget(self, action: #selector(self.PickerCancelButtonAction), forControlEvents: .TouchUpInside)
        PickerCancelButton.layer.masksToBounds = true
        PickerCancelButton.layer.cornerRadius = 10*px
        PickerCancelButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        
        
        let PickerDetermineButton = UIButton.init(frame: CGRectMake(WIDTH-140*px, self.PickerView.frame.origin.y+self.PickerView.height+15*px, 100*px, 35*px))
        PickerDetermineButton.backgroundColor = NavColor
        
        PickerDetermineButton.setTitle("确定", forState: .Normal)
        
        PickerDetermineButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        PickerDetermineButton.addTarget(self, action: #selector(self.PickerDetermineButtonAction), forControlEvents: .TouchUpInside)
        PickerDetermineButton.layer.masksToBounds = true
        PickerDetermineButton.layer.cornerRadius = 10*px
        PickerDetermineButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        
        self.PickerBackView.addSubview(PickerCancelButton)
        self.PickerBackView.addSubview(PickerDetermineButton)
        self.PickerView.selectRow(0, inComponent: 0, animated: false)
        
        
        
    }
    
    
    //MARK: ------UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if indexPath.section == 0{
            if indexPath.row == 0{
                return 65*px
            }
            return 44*px
        }else {
            if indexPath.row == 0{
                return 30*px
            }else if indexPath.row == 1{
                return 50*px
            }else{
                return 44*px
            }
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if indexPath.section == 0{
            if indexPath.row == 0{
                let vc = AdressEditViewController()
                vc.isselected = true
                vc.addressBlock = {(adressinfo) -> Void in
                    self.adressinfo = adressinfo
                    self.clothsTabelView.reloadSections(NSIndexSet.init(index: 0), withRowAnimation: .Automatic)
                    vc.navigationController?.popViewControllerAnimated(true)
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                
                TimeSelector.shareManager.CreatDataPicker(self,height:HEIGHT-64-43*px, timesblock: {[unowned self] (timestr, date) in
                    self.timeStr = timestr
                    self.clothsTabelView.reloadSections(NSIndexSet.init(index: 0), withRowAnimation: .Automatic)
                })
            }
        }
        
        
        
    }
    
    //MARK: ------TableViewDatasource
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return textArray.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0{
            return textArray[section].count
        }else{
            return textArray[section].count + self.diselectedClothsTypes.count
        }
        
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UILabel.init(frame: CGRectMake(0, 0, WIDTH, 10*px))
        headerView.backgroundColor = LGBackColor
        return headerView
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = PublicTableViewCell.init(style:.Default)
        let headerImage = UIImageView.init(frame: CGRectMake(10*px, (65*px-16)/2, 13, 16))
        let nameLabe = UILabel.init(frame: CGRectMake(40*px, 10*px, WIDTH/2-60*px, 30*px))
        let phoneLabel = UILabel.init(frame: CGRectMake(WIDTH/2-10*px, 10*px, WIDTH/2-50*px, 30*px))
        let adressLabel = UILabel.init(frame: CGRectMake(40*px, 35*px, WIDTH-90*px, 30*px))
        if indexPath.section == 0{
            if indexPath.row == 0 && self.adressinfo != nil{
                
                headerImage.image = UIImage(named: "ic_dingwei")
                cell.addSubview(headerImage)
                nameLabe.textColor = MainTextColor
                nameLabe.text = self.adressinfo?.name
                nameLabe.font = MainFont
                cell.addSubview(nameLabe)
                phoneLabel.textColor = MainTextColor
                phoneLabel.text = self.adressinfo?.phone
                phoneLabel.font = MainFont
                cell.addSubview(phoneLabel)
                adressLabel.textColor = MainTextColor
                adressLabel.text = self.adressinfo?.adress
                adressLabel.font = MainFont
                cell.addSubview(adressLabel)
                return cell
            }else if indexPath.row == 0 && self.adressinfo == nil{
                headerImage.image = UIImage(named: "ic_dingwei")
                cell.addSubview(headerImage)
                cell.textLabel?.text = textArray[indexPath.section][indexPath.row]
                cell.textLabel?.textColor = MainTextBackColor
                cell.textLabel?.font = MainFont
                cell.selectionStyle = .None
                cell.accessoryType = .DisclosureIndicator
                return cell
            }else{
                let cell1 = tableView.dequeueReusableCellWithIdentifier("RightArrowAndLabelTableViewCell", forIndexPath: indexPath)as!RightArrowAndLabelTableViewCell
                cell1.setUIWithDic(NSDictionary())
                cell1.selectionStyle = .None
                cell1.mainLabel.text = textArray[indexPath.section][indexPath.row]
                cell1.lastLabel.text = self.timeStr
                cell1.mainLabel.textColor = MainTextBackColor
                
                return cell1
            }
            
        }else{
            if indexPath.row == 0{
                cell.accessoryType = .None
                cell.selectionStyle = .None
                let titleLabel = UILabel.init(frame: CGRectMake(10, 0, WIDTH, 30*px))
                titleLabel.text = self.textArray[indexPath.section][indexPath.row]
                titleLabel.textColor = MainTextBackColor
                titleLabel.font = MainFont
                titleLabel.textAlignment = .Left
                cell.addSubview(titleLabel)
                return cell
                
            }else if indexPath.row == 1{
                let addSomeButton = UIButton.init(frame: CGRectMake(35*px, 10*px, WIDTH-70*px, 30*px))
                addSomeButton.layer.masksToBounds = true
                addSomeButton.layer.cornerRadius = 5
                addSomeButton.layer.borderColor = MainTextBackColor.CGColor
                addSomeButton.layer.borderWidth = 1
                addSomeButton.titleLabel?.font = MainFont
                addSomeButton.setTitle("+"+self.textArray[indexPath.section][indexPath.row], forState: .Normal)
                addSomeButton.setTitleColor(MainTextBackColor, forState: .Normal)
                addSomeButton.addTarget(self, action: #selector(self.addSomeButtonAction), forControlEvents: .TouchUpInside)
                cell.addSubview(addSomeButton)
                return cell
            }else{
                let cell = PublicTableViewCell.init(style:.Default)
                cell.textLabel?.font = UIFont.systemFontOfSize(13)
                cell.textLabel?.text = self.diselectedClothsTypes[indexPath.row-2].name+"（"+self.diselectedClothsTypes[indexPath.row-2].price+"元/件）"
                cell.textLabel?.textColor = MainTextBackColor
                cell.accessoryType = .None
                cell.selectionStyle = .None
                let reduceButton = UIButton.init(frame: CGRectMake(WIDTH-90*px,(44*px-13)/2, 25, 13))
                let addButton = UIButton.init(frame: CGRectMake(WIDTH-30*px, (44*px-13)/2, 25, 13))
                reduceButton.setImage(UIImage(named: "ic_jian"), forState: .Normal)
                addButton.setImage(UIImage(named: "ic_jia"), forState: .Normal)
                reduceButton.tag = indexPath.row
                addButton.tag = indexPath.row+100
                reduceButton.imageView?.contentMode = .Right
                addButton.imageView?.contentMode = .Left
                reduceButton.addTarget(self, action: #selector(self.reduceButtonAction(_:)), forControlEvents: .TouchUpInside)
                addButton.addTarget(self, action: #selector(self.addButtonAction(_:)), forControlEvents: .TouchUpInside)
                let countLabel = UILabel()//个数
                countLabel.frame = CGRectMake(WIDTH-60*px, 0, 30*px, 44*px)
                countLabel.font = MainFont
                countLabel.textAlignment = .Center
                
                countLabel.text = countArray[indexPath.row-2]
                
                
                //            self.countLabel.backgroundColor = UIColor.redColor()
                cell.addSubview(addButton)
                cell.addSubview(reduceButton)
                cell.addSubview(countLabel)
                return cell
            }
        }
        
    }
    
    
    func effectViewTouch(tap:UITapGestureRecognizer) {
        // 移除毛玻璃
        if (lasyEffectView.superview != nil) {
            lasyEffectView.removeFromSuperview()
           
                self.PickerBackView.removeFromSuperview()
            for view in self.PickerBackView.subviews {
                view.removeFromSuperview()
            }
            
            
        }
    }
    func showEffectView() {
        // 点击显示毛玻璃的判断
        
        if (lasyEffectView.superview != nil) {
            lasyEffectView.removeFromSuperview()
            
            self.PickerBackView.removeFromSuperview()
            for view in self.PickerBackView.subviews {
                view.removeFromSuperview()
            }
            
            
        }else{
            self.view.addSubview(lasyEffectView)
        }
    }
    
    //MARK:--UIPickerViewDatasource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0{
            return self.clothsTypes.count
        }
        if self.clothsTypeArray.count>0{
            return self.clothsTypeArray[self.typeCounts].count
        }else{
            return 0
        }
        
        
    }
    
    //MARK:--UIPickerViewDelegate
//    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if component == 0{
//            return self.clothsTypes[row]
//        }
//        return self.clothsTypeArray[self.typeCounts][row].name
//    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
            self.typeCounts = row
            self.diselectedClothsType = self.clothsTypeArray[self.typeCounts][0]
            self.PickerView.reloadComponent(1)
        }else{
            self.diselectedClothsType = self.clothsTypeArray[self.typeCounts][row]
        }
        
        
        self.counts = row
    }
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 0{
            return 100
        }else{
            return WIDTH - 100
        }
    }
//    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//        
//        if component == 0{
//            let str = NSMutableAttributedString.init(string: self.clothsTypes[row], attributes: [NSForegroundColorAttributeName : UIColor.redColor(),NSFontAttributeName:UIFont.systemFontOfSize(8)])
//
//            return str
//        }else{
//            let str = NSAttributedString.init(string: self.clothsTypeArray[self.typeCounts][row].name+"("+self.clothsTypeArray[self.typeCounts][row].price+"元/件)", attributes: [NSForegroundColorAttributeName : NavColor])
//            return str
//            
//        }
//        
//    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40*px
    }
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let label = AutoScrollLabel()
        label.backgroundColor = UIColor.clearColor()
        label.textAlignment = .Center
        if component == 0{
            label.frame = CGRectMake(0, 0, 100, 40*px)
            label.text = self.clothsTypes[row]
            label.font = UIFont.systemFontOfSize(15)
            label.textColor = UIColor.redColor()
            
            return label
        }else{
            label.frame = CGRectMake(0, 0, WIDTH-100, 40*px)
            label.text = self.clothsTypeArray[self.typeCounts][row].name+"("+self.clothsTypeArray[self.typeCounts][row].price+"元/件)"
            label.font = UIFont.systemFontOfSize(13)
            label.textColor = NavColor
            return label
        }
    }
    
    //MARK:-----ACTION
    func typeButtonAction(sender:UIButton){
        
        if sender.selected {
            sender.backgroundColor = UIColor.whiteColor()
            sender.layer.borderWidth = 1
        }else{
            sender.backgroundColor = NavColor
            sender.layer.borderWidth = 0
        }
        sender.selected = !sender.selected
        
    }
    func addSomeButtonAction(){
        self.showEffectView()
         self.typeCounts = 0
        self.CreatPicker()
        self.view.addSubview(self.PickerBackView)
        UIView.animateWithDuration(0.2, animations: {
            self.PickerBackView.frame = CGRectMake(0, HEIGHT-64-320*px-40, WIDTH, 320*px)
        })
    }
    
    func addButtonAction(sender:UIButton){
        var count = Int(self.countArray[sender.tag-102])
        if count != nil{
            count = count! + 1
            self.countArray[sender.tag-102] = String(count!)
            
        }else{
            self.countArray[sender.tag-102] = "1"
        }
        self.clothsTabelView.reloadRowsAtIndexPaths([NSIndexPath.init(forRow: sender.tag-100, inSection: 1)], withRowAnimation: .None)
        self.changeMoney()
    }
    func reduceButtonAction(sender:UIButton){
        
        var count = Int(self.countArray[sender.tag-self.textArray[1].count])
        if count != nil&&count > 1{
            count = count! - 1
            self.countArray[sender.tag-self.textArray[1].count] = String(count!)
            self.clothsTabelView.reloadRowsAtIndexPaths([NSIndexPath.init(forRow: sender.tag, inSection: 1)], withRowAnimation: .None)
        }else{
            
            self.countArray[sender.tag-self.textArray[1].count] = "1"
            self.countArray.removeAtIndex(sender.tag-self.textArray[1].count)
            self.diselectedClothsTypes.removeAtIndex(sender.tag-self.textArray[1].count)
            self.clothsTabelView.deleteRowsAtIndexPaths([NSIndexPath.init(forRow: sender.tag, inSection: 1)], withRowAnimation: .Left)
            
        }
        self.changeMoney()
        
    }

    func PickerCancelButtonAction(){
        self.showEffectView()
    }
    func PickerDetermineButtonAction(){
        self.showEffectView()
        if self.diselectedClothsType != nil{
            self.diselectedClothsTypes.append(self.diselectedClothsType)
            self.countArray.append("1")
            self.clothsTabelView.reloadData()
        }
        self.changeMoney()
    }
    
    func goButtonAction(){
        if  USERLC != nil && USERLC!["userid"] != nil {
            if self.adressinfo == nil{
                Alert.shareManager.alert("请选择地址", delegate: self)
                return
            }
        }
        if self.diselectedClothsTypes.count == 0{
            Alert.shareManager.alert("请选择服务类型", delegate: self)
            return
        }
        
        AppRequestManager.shareManager.AddServiceOrderForCloths(USERLC!["userid"] as! String, type: "9", servicetime: "", money: String(self.money), begintime: self.timeStr, address: (self.adressinfo?.adress)!, longitude: (self.adressinfo?.longitude)!, latitude: (self.adressinfo?.latitude)!, remark: "", goodInfo: self.diselectedClothsTypes, number: self.countArray) { (success, response) in
            if success{
                NSLOG("go pay")
            }else{
                NSLOG("some error\(response)")
            }
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
