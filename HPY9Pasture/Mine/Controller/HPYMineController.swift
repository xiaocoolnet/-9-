//
//  HPYMineController.swift
//  HPY9Pasture
//
//  Created by xiaocool on 16/10/10.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class HPYMineController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.purpleColor()
        let label = UILabel(frame: CGRectMake(100,100,100,50))
        label.text = "我的"
        view.addSubview(label)
        // Do any additional setup after loading the view.
    }

}
