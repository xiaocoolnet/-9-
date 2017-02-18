//
//  OC-Swift.swift
//  HPY9Pasture
//
//  Created by purepure on 16/11/21.
//  Copyright © 2016年 xiaocool. All rights reserved.
//

import UIKit

public let LGBackColor1 = UIColor(red: 239/255.0, green: 239/255.0, blue: 239/255.0, alpha: 1)

public class Test: NSObject {
    
    public let LGBackColor = UIColor(red: 239/255.0, green: 239/255.0, blue: 239/255.0, alpha: 1)
    public let NavColor = UIColor(red: 81/255.0, green: 166/255.0, blue: 255/255, alpha: 1)
    public func log() {
        print("这是Swift的方法")
    }
}
public class ServerPhone: NSObject {
    
    var name:NSString?
    var phoneArray:NSMutableArray?
    
    
}

public func globalLog() {
    print("这是Swift全局的log方法")
}
