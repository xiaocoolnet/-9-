//
//  DetailsViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 17/1/3.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate  {
    
    let mytableView = UITableView()
    let leftTextArray = [["地址","缴费户号","户名"],["日期","电梯维修缴费","叠层物业费","清洁费用"]]
    let rightTextArray = [["福海应景小区12棟506室","00521864","纯纯"],["2016年7月","15.00","365.95","235.45"]]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = LGBackColor
        self.title = "物业缴费"

        self.mytableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
        self.mytableView.delegate = self
        self.mytableView.dataSource = self
        self.mytableView.backgroundColor = LGBackColor
        self.mytableView.separatorStyle = .None
        self.mytableView.editing = false
        self.mytableView.registerNib(UINib(nibName: "DetailsTableViewCell",bundle: nil), forCellReuseIdentifier: "DetailsTableViewCell")
        self.view.addSubview(self.mytableView)
        
        let footBackView = UIView.init(frame: CGRectMake(0, 0, WIDTH, 110*px))
        let leftMoneyLabel = UILabel.init(frame: CGRectMake(0, 0, WIDTH/2, 45*px))
        leftMoneyLabel.text = "  预计缴费总额："
        leftMoneyLabel.backgroundColor = LGBackColor
        leftMoneyLabel.font = MainFont
        
        let rightMoneyLabel = UITextView.init(frame: CGRectMake(WIDTH/2, 0, WIDTH/2-10, 45*px))
        rightMoneyLabel.text = "1162.35"
        rightMoneyLabel.textAlignment = .Right
        rightMoneyLabel.backgroundColor = LGBackColor
        rightMoneyLabel.font = MainFont
        rightMoneyLabel.userInteractionEnabled = false
        rightMoneyLabel.textColor = RGBACOLOR(255, g: 172, b: 49, a: 1)
        
        footBackView.addSubview(leftMoneyLabel)
        footBackView.addSubview(rightMoneyLabel)
        
        let payButton = UIButton.init(frame: CGRectMake(10*px, rightMoneyLabel.height, WIDTH-20*px, 44*px))
        payButton.setTitle("立即支付", forState: .Normal)
        payButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        payButton.backgroundColor = NavColor
        payButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        payButton.addTarget(self, action: #selector(self.payButton), forControlEvents: .TouchUpInside)
        payButton.layer.masksToBounds = true
        payButton.layer.cornerRadius = 5
        footBackView.addSubview(payButton)
        self.mytableView.tableFooterView = footBackView
        
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: ------UITableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return leftTextArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 35
    }
    
    
    
    //MARK: ------TableViewDatasource
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 20
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel.init(frame: CGRectMake(0, 0, WIDTH, 20))
        label.backgroundColor = LGBackColor
        label.text = "  缴费事项"
        label.textColor = MainTextBackColor
        label.font = UIFont.systemFontOfSize(12)
        return label
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return leftTextArray[section].count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("DetailsTableViewCell", forIndexPath: indexPath)as!DetailsTableViewCell
        cell.setUI()
        cell.leftTextLabel.text = self.leftTextArray[indexPath.section][indexPath.row] as String
        cell.rightTextLabel.text = self.rightTextArray[indexPath.section][indexPath.row] as String
        
        cell.selectionStyle = .None
        
        return cell
    }
    //MARK: ACTION
    
    func payButton(){
        
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
