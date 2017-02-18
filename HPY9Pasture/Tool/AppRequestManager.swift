//
//  AppRequestManager.swift
//  HPY9Pasture
//
//  Created by purepure on 17/1/9.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


typealias ResponseBlock = (success:Bool,response:AnyObject)->Void

class AppRequestManager: NSObject {
    
    //单例
//    class func shareManager()->AppRequestManager{
//        struct Singleton{
//            static var onceToken : dispatch_once_t = 0
//            static var single:AppRequestManager?
//        }
//        dispatch_once(&Singleton.onceToken,{
//            Singleton.single=shareManager()
//            }
//        )
//        return Singleton.single!
//    }
    //单例
    static let shareManager = AppRequestManager()
    private override init() {
                
    }
     //MARK:检查手机号是否注册
    func comfirmPhoneHasRegister(phoneNum:String,handle:ResponseBlock){
        
        let indicator = JQIndicatorView.init(type: .BounceSpot1)
        indicator.startAnimating()
        
        let url = Happy_HeaderUrl+"checkphone"
        let paraDic = ["phone":phoneNum]
        
        Alamofire.request(.GET, url, parameters: paraDic).response{request, response, json, error in
            let json = JSON(data:json!)
            NSLOG(request)
            NSLOG(json)
            indicator.stopAnimating()
            if json["status"].string != nil && json["status"].string == "success"{
                handle(success: true, response: json["data"].string!)
            }else{
                if json["data"].string != nil{
                    handle(success: false, response: json["data"].string!)
                }
                
            }
        }
    }
     //MARK:发送验证码
    func sendMobileCodeWithPhoneNumber(phoneNumber:String,handle:ResponseBlock){
        let indicator = JQIndicatorView.init(type: .BounceSpot1)
        indicator.startAnimating()
        
        let url = Happy_HeaderUrl+"SendMobileCode"
        let paramDic = ["phone":phoneNumber]
        
        Alamofire.request(.GET, url, parameters: paramDic).response{request, response, json, error in
            let json = JSON(data:json!)
            NSLOG(request)
            NSLOG(json)
            indicator.stopAnimating()
            if json["status"].string != nil && json["status"].string == "success"{
                handle(success: true, response: json["data"]["code"].floatValue)
            }else{
                if json["data"].string != nil{
                    handle(success: false, response:json["data"].string!)
                }
            }
        }
        
    }
    //MARK:获取个人基本资料
    func getUserinfoWithUserId(userid:String,handle:ResponseBlock){
        let indicator = JQIndicatorView.init(type: .BounceSpot1)
        indicator.startAnimating()
        
        let url = Happy_HeaderUrl+"getuserinfo"
        let paramDic = ["userid":userid]
        
        Alamofire.request(.GET, url, parameters: paramDic).response{request, response, json, error in
            let json1 = JSON(data:json!)
            NSLOG(request)
            NSLOG(json)
            NSLOG(json1)
            indicator.stopAnimating()
            if json1["status"].string != nil && json1["status"].string == "success"{
                handle(success: true, response: json!)
            }else{
                if json1["data"].string != nil{
                    handle(success: false, response:json1["data"].string!)
                }
            }
        }
        
    }
    
    //MARK:注册
    func register(phone:String,password:String,
                  code:String,token:String,
            handle:ResponseBlock){
        let indicator = JQIndicatorView.init(type: .BounceSpot1)
        indicator.startAnimating()

        let url = Happy_HeaderUrl+"AppRegister"
        let paramDic = ["phone":phone,"password":password,"devicetype":"1",
                        "code":code,"token":token
        ]
        
        Alamofire.request(.GET, url, parameters: paramDic).response { request, response, json, error in
            let json1 = JSON(data:json!)
            NSLOG(json)
            NSLOG(request)
            NSLOG(json1["data"]["code"])
            indicator.stopAnimating()
            if json1["status"].string != nil && json1["status"].string == "success"{
                //                print(result.datas)
                handle(success: true, response: json!)
            }else{
                if json1["data"].string != nil{
                    handle(success: false, response:json1["data"].string!)
                }
                
            }
            
            
        }
    }
    
    //MARK:修改密码
    func forgetPassword(phone:String,code:String,password:String,handle:ResponseBlock){
        let indicator = JQIndicatorView.init(type: .BounceSpot1)
        indicator.startAnimating()
        let url = Happy_HeaderUrl+"forgetpwd"
        let paramDic = ["phone":phone,"code":code,"password":password]
        Alamofire.request(.GET,url, parameters: paramDic).response { request, response, json, error in
            let json1 = JSON(data:json!)
            NSLOG(json)
            NSLOG(request)
            indicator.stopAnimating()
            if json1["status"].string != nil && json1["status"].string == "success"{
                //                print(result.datas)
                handle(success: true, response: json!)
            }else{
                if json1["data"].string != nil{
                    handle(success: false, response:json1["data"].string!)
                }
                
            }
        }
    }
    //MARK:登录
    func login(phoneNum:String,password:String,registrationID:String,handle:ResponseBlock){
        let indicator = JQIndicatorView.init(type: .BounceSpot1)
        indicator.startAnimating()
        let url = Happy_HeaderUrl+"applogin"
        let paramDic = ["phone":phoneNum,"password":password,"token":registrationID,"devicestate":"1"]
        
        Alamofire.request(.GET,url, parameters: paramDic).response { request, response, json, error in
            NSLOG(json)
            NSLOG(request)
            let json1 = JSON(data:json!)
            indicator.stopAnimating()
            
            if json1["status"].string != nil && json1["status"].string == "success"{
                //                print(result.datas)
                handle(success: true, response: json!)
            }else{
                if json1["data"].string != nil{
                    handle(success: false, response:json1["data"].string!)
                }
            }
            
            }
    }
    
    //MARK:修改个人资料[姓名]
    func UpdateUserName(name:String,userid:String, handle:ResponseBlock){
        let indicator = JQIndicatorView.init(type: .BounceSpot1)
        indicator.startAnimating()
        let url = Happy_HeaderUrl+"UpdateUserName"
        let paramDic = ["userid":userid,"name":name]
        
        Alamofire.request(.GET,url, parameters: paramDic).response { request, response, json, error in
            NSLOG(json)
            NSLOG(request)
            let json1 = JSON(data:json!)
            indicator.stopAnimating()
            
            if json1["status"].string != nil && json1["status"].string == "success"{
                //                print(result.datas)
                handle(success: true, response: json!)
            }else{
                if json1["data"].string != nil{
                    handle(success: false, response:json1["data"].string!)
                }
                
            }
        }
    }
    //MARK:修改个人资料[头像]
    func UpdateUserAvatar(avatar:String,userid:String, handle:ResponseBlock){
        let indicator = JQIndicatorView.init(type: .BounceSpot1)
        indicator.startAnimating()
        let url = Happy_HeaderUrl+"UpdateUserAvatar"
        let paramDic = ["userid":userid,"avatar":avatar]
        
        Alamofire.request(.GET,url, parameters: paramDic).response { request, response, json, error in
            NSLOG(json)
            NSLOG(request)
            let json1 = JSON(data:json!)
            indicator.stopAnimating()
            
            if json1["status"].string != nil && json1["status"].string == "success"{
                //                print(result.datas)
                handle(success: true, response: json!)
            }else{
                if json1["data"].string != nil{
                    handle(success: false, response:json1["data"].string!)
                }
                
            }
            
        }
    }
    //MARK:修改个人资料[性别]
    func UpdateUserSex(userid:String,sex:String, handle:ResponseBlock){
        let indicator = JQIndicatorView.init(type: .BounceSpot1)
        indicator.startAnimating()
        let url = Happy_HeaderUrl+"UpdateUserSex"
        let paramDic = ["userid":userid,"sex":sex]
        
        Alamofire.request(.GET,url, parameters: paramDic).response { request, response, json, error in
            NSLOG(json)
            NSLOG(request)
            let json1 = JSON(data:json!)
            indicator.stopAnimating()
            
            if json1["status"].string != nil && json1["status"].string == "success"{
                //                print(result.datas)
                handle(success: true, response: json!)
            }else{
                if json1["data"].string != nil{
                    handle(success: false, response:json1["data"].string!)
                }
                
            }
            
        }
    }
    //MARK:修改个人资料[手机]
    func UpdateUserPhone(userid:String,phone:String, code:String, handle:ResponseBlock){
        let indicator = JQIndicatorView.init(type: .BounceSpot1)
        indicator.startAnimating()
        let url = Happy_HeaderUrl+"UpdateUserPhone"
        let paramDic = ["userid":userid,"phone":phone,"code":code]
        
        Alamofire.request(.GET,url, parameters: paramDic).response { request, response, json, error in
            NSLOG(json)
            NSLOG(request)
            let json1 = JSON(data:json!)
            indicator.stopAnimating()
            
            if json1["status"].string != nil && json1["status"].string == "success"{
                //                print(result.datas)
                handle(success: true, response: json!)
            }else{
                if json1["data"].string != nil{
                    handle(success: false, response:json1["data"].string!)
                }
                
            }
            
        }
    }
    //MARK:修改个人资料[生日]
    func UpdateUserBirthday(userid:String,birthday:String, handle:ResponseBlock){
        let indicator = JQIndicatorView.init(type: .BounceSpot1)
        indicator.startAnimating()
        let url = Happy_HeaderUrl+"UpdateUserBirthday"
        let paramDic = ["userid":userid,"birthday":birthday]
        
        Alamofire.request(.GET,url, parameters: paramDic).response { request, response, json, error in
            NSLOG(json)
            NSLOG(request)
            let json1 = JSON(data:json!)
            indicator.stopAnimating()
            
            if json1["status"].string != nil && json1["status"].string == "success"{
                //                print(result.datas)
                handle(success: true, response: json!)
            }else{
                if json1["data"].string != nil{
                    handle(success: false, response:json1["data"].string!)
                }
                
            }
            
        }
    }
    
    //MARK:修改个人资料[身份证有效期]
    func UpdateUserIDCardExpiry(userid:String,birthday:String, handle:ResponseBlock){
        let indicator = JQIndicatorView.init(type: .BounceSpot1)
        indicator.startAnimating()
        let url = Happy_HeaderUrl+"UpdateUserIDCardExpiry"
        let paramDic = ["userid":userid,"expiry":birthday]
        
        Alamofire.request(.GET,url, parameters: paramDic).response { request, response, json, error in
            NSLOG(json)
            NSLOG(request)
            let json1 = JSON(data:json!)
            indicator.stopAnimating()
            
            if json1["status"].string != nil && json1["status"].string == "success"{
                //                print(result.datas)
                handle(success: true, response: json!)
            }else{
                if json1["data"].string != nil{
                    handle(success: false, response:json1["data"].string!)
                }
                
            }
            
        }
    }
    
    //MARK:修改个人资料[户口类型]
    func UpdateUserHouseholdregistration(userid:String,householdregistration:String, handle:ResponseBlock){
        let indicator = JQIndicatorView.init(type: .BounceSpot1)
        indicator.startAnimating()
        let url = Happy_HeaderUrl+"UpdateUserHouseholdregistration"
        let paramDic = ["userid":userid,"householdregistration":householdregistration]
        
        Alamofire.request(.GET,url, parameters: paramDic).response { request, response, json, error in
            NSLOG(json)
            NSLOG(request)
            let json1 = JSON(data:json!)
            indicator.stopAnimating()
            
            if json1["status"].string != nil && json1["status"].string == "success"{
                //                print(result.datas)
                handle(success: true, response: json!)
            }else{
                if json1["data"].string != nil{
                    handle(success: false, response:json1["data"].string!)
                }
                
            }
            
        }
    }
    
    //MARK:修改个人资料[地址]
    func UpdateUserAddress(userid:String,address:String, handle:ResponseBlock){
        let indicator = JQIndicatorView.init(type: .BounceSpot1)
        indicator.startAnimating()
        let url = Happy_HeaderUrl+"UpdateUserAddress"
        let paramDic = ["userid":userid,"address":address]
        
        Alamofire.request(.GET,url, parameters: paramDic).response { request, response, json, error in
            NSLOG(json)
            NSLOG(request)
            let json1 = JSON(data:json!)
            indicator.stopAnimating()
            
            if json1["status"].string != nil && json1["status"].string == "success"{
                //                print(result.datas)
                handle(success: true, response: json!)
            }else{
                if json1["data"].string != nil{
                    handle(success: false, response:json1["data"].string!)
                }
                
            }
            
        }
    }
    
    //MARK:修改个人资料[身份证号]
    func UpdateUserIDCard(userid:String,idcard:String, handle:ResponseBlock){
        let indicator = JQIndicatorView.init(type: .BounceSpot1)
        indicator.startAnimating()
        let url = Happy_HeaderUrl+"UpdateUserIDCard"
        let paramDic = ["userid":userid,"idcard":idcard]
        
        Alamofire.request(.GET,url, parameters: paramDic).response { request, response, json, error in
            NSLOG(json)
            NSLOG(request)
            let json1 = JSON(data:json!)
            indicator.stopAnimating()
            
            if json1["status"].string != nil && json1["status"].string == "success"{
                //                print(result.datas)
                handle(success: true, response: json!)
            }else{
                if json1["data"].string != nil{
                    handle(success: false, response:json1["data"].string!)
                }
                
            }
            
        }
    }
    
    //MARK:修改个人资料[民族]
    func UpdateUserNation(userid:String,nation:String, handle:ResponseBlock){
        let indicator = JQIndicatorView.init(type: .BounceSpot1)
        indicator.startAnimating()
        let url = Happy_HeaderUrl+"UpdateUserNation"
        let paramDic = ["userid":userid,"nation":nation]
        
        Alamofire.request(.GET,url, parameters: paramDic).response { request, response, json, error in
            NSLOG(json)
            NSLOG(request)
            let json1 = JSON(data:json!)
            indicator.stopAnimating()
            
            if json1["status"].string != nil && json1["status"].string == "success"{
                //                print(result.datas)
                handle(success: true, response: json!)
            }else{
                if json1["data"].string != nil{
                    handle(success: false, response:json1["data"].string!)
                }
                
            }
            
        }
    }
    
    //MARK:修改个人资料[是否党员]
    func UpdateUserParty(userid:String,party:String, handle:ResponseBlock){
        let indicator = JQIndicatorView.init(type: .BounceSpot1)
        indicator.startAnimating()
        let url = Happy_HeaderUrl+"UpdateUserParty"
        let paramDic = ["userid":userid,"party":party]
        
        Alamofire.request(.GET,url, parameters: paramDic).response { request, response, json, error in
            NSLOG(json)
            NSLOG(request)
            let json1 = JSON(data:json!)
            indicator.stopAnimating()
            
            if json1["status"].string != nil && json1["status"].string == "success"{
                //                print(result.datas)
                handle(success: true, response: json!)
            }else{
                if json1["data"].string != nil{
                    handle(success: false, response:json1["data"].string!)
                }
                
            }
            
        }
    }
    //MARK:修改个人资料[婚姻状态]
    func UpdateUserMarriageStatus(userid:String,marriage:String, handle:ResponseBlock){
        let indicator = JQIndicatorView.init(type: .BounceSpot1)
        indicator.startAnimating()
        let url = Happy_HeaderUrl+"UpdateUserMarriageStatus"
        let paramDic = ["userid":userid,"marriage":marriage]
        
        Alamofire.request(.GET,url, parameters: paramDic).response { request, response, json, error in
            NSLOG(json)
            NSLOG(request)
            let json1 = JSON(data:json!)
            indicator.stopAnimating()
            
            if json1["status"].string != nil && json1["status"].string == "success"{
                //                print(result.datas)
                handle(success: true, response: json!)
            }else{
                if json1["data"].string != nil{
                    handle(success: false, response:json1["data"].string!)
                }
                
            }
            
        }
    }
    //MARK:修改个人资料[是否过敏]
    func UpdateUserIrritability(userid:String,irritability:String, handle:ResponseBlock){
        let indicator = JQIndicatorView.init(type: .BounceSpot1)
        indicator.startAnimating()
        let url = Happy_HeaderUrl+"UpdateUserIrritability"
        let paramDic = ["userid":userid,"irritability":irritability]
        
        Alamofire.request(.GET,url, parameters: paramDic).response { request, response, json, error in
            NSLOG(json)
            NSLOG(request)
            let json1 = JSON(data:json!)
            indicator.stopAnimating()
            
            if json1["status"].string != nil && json1["status"].string == "success"{
                //                print(result.datas)
                handle(success: true, response: json!)
            }else{
                if json1["data"].string != nil{
                    handle(success: false, response:json1["data"].string!)
                }
                
            }
            
        }
    }
    //MARK:修改个人资料[医疗保险类型]
    func UpdateUserHealthInsuranceType(userid:String,type:String, handle:ResponseBlock){
        let indicator = JQIndicatorView.init(type: .BounceSpot1)
        indicator.startAnimating()
        let url = Happy_HeaderUrl+"UpdateUserHealthInsuranceType"
        let paramDic = ["userid":userid,"type":type]
        
        Alamofire.request(.GET,url, parameters: paramDic).response { request, response, json, error in
            NSLOG(json)
            NSLOG(request)
            let json1 = JSON(data:json!)
            indicator.stopAnimating()
            
            if json1["status"].string != nil && json1["status"].string == "success"{
                //                print(result.datas)
                handle(success: true, response: json!)
            }else{
                if json1["data"].string != nil{
                    handle(success: false, response:json1["data"].string!)
                }
                
            }
            
        }
    }
    
    //MARK:修改个人资料[以往病史]
    func UpdateUserMedicalhistory(userid:String,medicalhistory:String, handle:ResponseBlock){
        let indicator = JQIndicatorView.init(type: .BounceSpot1)
        indicator.startAnimating()
        let url = Happy_HeaderUrl+"UpdateUserMedicalhistory"
        let paramDic = ["userid":userid,"medicalhistory":medicalhistory]
        
        Alamofire.request(.GET,url, parameters: paramDic).response { request, response, json, error in
            NSLOG(json)
            NSLOG(request)
            let json1 = JSON(data:json!)
            indicator.stopAnimating()
            
            if json1["status"].string != nil && json1["status"].string == "success"{
                //                print(result.datas)
                handle(success: true, response: json!)
            }else{
                if json1["data"].string != nil{
                    handle(success: false, response:json1["data"].string!)
                }
                
            }
            
        }
    }
    //MARK:修改个人资料[病种归类]
    func UpdateUserDiseasetype(userid:String,diseasetype:String, handle:ResponseBlock){
        let indicator = JQIndicatorView.init(type: .BounceSpot1)
        indicator.startAnimating()
        let url = Happy_HeaderUrl+"UpdateUserDiseasetype"
        let paramDic = ["userid":userid,"diseasetype":diseasetype]
        
        Alamofire.request(.GET,url, parameters: paramDic).response { request, response, json, error in
            NSLOG(json)
            NSLOG(request)
            let json1 = JSON(data:json!)
            indicator.stopAnimating()
            
            if json1["status"].string != nil && json1["status"].string == "success"{
                //                print(result.datas)
                handle(success: true, response: json!)
            }else{
                if json1["data"].string != nil{
                    handle(success: false, response:json1["data"].string!)
                }
                
            }
            
        }
    }
    
    
    //MARK:获取社区养老机构
    func getOrganizationList(cid:String,type:String,beginId:String, handle:ResponseBlock){
        let indicator = JQIndicatorView.init(type: .BounceSpot1)
        indicator.startAnimating()
        let url = Happy_HeaderUrl+"getOrganizationList"
        let paramDic = ["cid":cid,"type":type,beginId:"beginId"]
        
        Alamofire.request(.GET,url, parameters: paramDic).response { request, response, json, error in
            NSLOG(json)
            NSLOG(request)
            let json1 = JSON(data:json!)
            indicator.stopAnimating()
            
            if json1["status"].string != nil && json1["status"].string == "success"{
                //                print(result.datas)
                handle(success: true, response: json!)
            }else{
                if json1["data"].string != nil{
                    handle(success: false, response:json1["data"].string!)
                }
                
            }
        }
    }
    
    //MARK:获取社区服务者电话
    func getcommunityServiceListBycommunityId(communityId:String, handle:ResponseBlock){
        let indicator = JQIndicatorView.init(type: .BounceSpot1)
        indicator.startAnimating()
        let url = Happy_HeaderUrl+"getcommunityServiceListBycommunityId"
        let paramDic = ["cid":communityId]
        
        Alamofire.request(.GET,url, parameters: paramDic).response { request, response, json, error in
            NSLOG(json)
            NSLOG(request)
            let json1 = JSON(data:json!)
            indicator.stopAnimating()
            
            if json1["status"].string != nil && json1["status"].string == "success"{
                //                print(result.datas)
                handle(success: true, response: json!)
            }else{
                if json1["data"].string != nil{
                    handle(success: false, response:json1["data"].string!)
                }
                
            }
            
        }
    }
    //MARK:获取家庭厨房列表
    func getHomekitchenListByCommunityId(communityId:String,beginID:String,keyWord:String, handle:ResponseBlock){
        let indicator = JQIndicatorView.init(type: .BounceSpot1)
        indicator.startAnimating()
        let url = Happy_HeaderUrl+"getHomekitchenListByCommunityId"
        let paramDic = ["cid":communityId,"begin":beginID,"keyword":keyWord]
        
        Alamofire.request(.GET,url, parameters: paramDic).response { request, response, json, error in
            NSLOG(json)
            NSLOG(request)
            let json1 = JSON(data:json!)
            indicator.stopAnimating()
            
            if json1["status"].string != nil && json1["status"].string == "success"{
                //                print(result.datas)
                handle(success: true, response: json!)
            }else{
                if json1["data"].string != nil{
                    handle(success: false, response:json1["data"].string!)
                }
                
            }
            
        }
    }
    
    //MARK:获取家庭厨房食品列表
    func getFoodListByHomeId(foodID:String,beginID:String, handle:ResponseBlock){
        let indicator = JQIndicatorView.init(type: .BounceSpot1)
        indicator.startAnimating()
        let url = Happy_HeaderUrl+"getFoodListByHomeId"
        let paramDic = ["hid":foodID,"begin":beginID]
        
        Alamofire.request(.GET,url, parameters: paramDic).response { request, response, json, error in
            NSLOG(json)
            NSLOG(request)
            let json1 = JSON(data:json!)
            indicator.stopAnimating()
            
            if json1["status"].string != nil && json1["status"].string == "success"{
                //                print(result.datas)
                handle(success: true, response: json!)
            }else{
                if json1["data"].string != nil{
                    handle(success: false, response:json1["data"].string!)
                }
                
            }
                       
        }
    }
    //MARK:根据用户ID获取个人档案信息
    func getPersonalinformationByUserid(userid:String, handle:ResponseBlock){
        let indicator = JQIndicatorView.init(type: .BounceSpot1)
        indicator.startAnimating()
        let url = Happy_HeaderUrl+"getPersonalinformationByUserid"
        let paramDic = ["userid":userid]
        
        Alamofire.request(.GET,url, parameters: paramDic).response { request, response, json, error in
            NSLOG(json)
            NSLOG(request)
            let json1 = JSON(data:json!)
            indicator.stopAnimating()
            
            if json1["status"].string != nil && json1["status"].string == "success"{
                //                print(result.datas)
                handle(success: true, response: json!)
            }else{
                if json1["data"].string != nil{
                    handle(success: false, response:json1["data"].string!)
                }
                
            }
            
        }
    }
    
    
    //MARK:获取所在社区未支付订单
    func getMyCommunityWaitForPayOrder(userid:String,cid:String, handle:ResponseBlock){
        let indicator = JQIndicatorView.init(type: .BounceSpot1)
        indicator.startAnimating()
        let url = Happy_HeaderUrl+"getMyCommunityWaitForPayOrder"
        let paramDic = ["userid":userid,"cid":cid]
        
        Alamofire.request(.GET,url, parameters: paramDic).response { request, response, json, error in
            NSLOG(json)
            NSLOG(request)
            let json1 = JSON(data:json!)
            indicator.stopAnimating()
            
            if json1["status"].string != nil && json1["status"].string == "success"{
                //                print(result.datas)
                handle(success: true, response: json!)
            }else{
                if json1["data"].string != nil{
                    handle(success: false, response:json1["data"].string!)
                }
                
            }
            
        }
    }
    
    
    //MARK:获取所在社区门诊列表
    func getCommunityOutpatientListByCommunityId(cid:String, handle:ResponseBlock){
        let indicator = JQIndicatorView.init(type: .BounceSpot1)
        indicator.startAnimating()
        let url = Happy_HeaderUrl+"getCommunityOutpatientListByCommunityId"
        let paramDic = ["cid":cid]
        
        Alamofire.request(.GET,url, parameters: paramDic).response { request, response, json, error in
            NSLOG(json)
            NSLOG(request)
            let json1 = JSON(data:json!)
            indicator.stopAnimating()
            
            if json1["status"].string != nil && json1["status"].string == "success"{
                //                print(result.datas)
                handle(success: true, response: json!)
            }else{
                if json1["data"].string != nil{
                    handle(success: false, response:json1["data"].string!)
                }
                
            }
            
        }
    }
    
    //MARK:获取所在社区门诊列表
    func getDoctorListByOutpatientId(oid:String,type:String, handle:ResponseBlock){
        let indicator = JQIndicatorView.init(type: .BounceSpot1)
        indicator.startAnimating()
        let url = Happy_HeaderUrl+"getDoctorListByOutpatientId"
        let paramDic = ["oid":oid,"type":type]
        
        Alamofire.request(.GET,url, parameters: paramDic).response { request, response, json, error in
            NSLOG(json)
            NSLOG(request)
            let json1 = JSON(data:json!)
            indicator.stopAnimating()
            
            if json1["status"].string != nil && json1["status"].string == "success"{
                //                print(result.datas)
                handle(success: true, response: json!)
            }else{
                if json1["data"].string != nil{
                    handle(success: false, response:json1["data"].string!)
                }
                
            }
            
        }
    }
    
    
    //MARK:获取社区门诊图片列表
    func getPhotoListByOutpatientId(oid:String, handle:ResponseBlock){
        let indicator = JQIndicatorView.init(type: .BounceSpot1)
        indicator.startAnimating()
        let url = Happy_HeaderUrl+"getPhotoListByOutpatientId"
        let paramDic = ["oid":oid]
        
        Alamofire.request(.GET,url, parameters: paramDic).response { request, response, json, error in
            NSLOG(json)
            NSLOG(request)
            let json1 = JSON(data:json!)
            indicator.stopAnimating()
            
            if json1["status"].string != nil && json1["status"].string == "success"{
                //                print(result.datas)
                handle(success: true, response: json!)
            }else{
                if json1["data"].string != nil{
                    handle(success: false, response:json1["data"].string!)
                }
                
            }
            
        }
    }
    
    //MARK:获取附近陪护服务人员列表
    func getServiceStaffsFormNearby(oid:String, handle:ResponseBlock){
        let indicator = JQIndicatorView.init(type: .BounceSpot1)
        indicator.startAnimating()
        let url = Happy_HeaderUrl+"getServiceStaffsFormNearby"
        let paramDic = ["":""]
        
        Alamofire.request(.GET,url, parameters: paramDic).response { request, response, json, error in
            NSLOG(json)
            NSLOG(request)
            let json1 = JSON(data:json!)
            indicator.stopAnimating()
            
            if json1["status"].string != nil && json1["status"].string == "success"{
                //                print(result.datas)
                handle(success: true, response: json!)
            }else{
                if json1["data"].string != nil{
                    handle(success: false, response:json1["data"].string!)
                }
                
            }
            
        }
    }
    //MARK:上传图片
    
    func uploadImage(imageName:String,imageData:NSData,handle:ResponseBlock){
        let indicator = JQIndicatorView.init(type: .BounceSpot1)
        indicator.startAnimating()
        let url = Happy_HeaderUrl+"uploadimg"
        
         ConnectModel.uploadWithImageName(imageName, imageData: imageData, URL: url) { (data) in
            NSLOG(data)
            let json1 = JSON(data:data!)
            NSLOG(json1)
            indicator.stopAnimating()
            if (json1["status"].string) != nil&&(json1["status"].string) == "success" {
                if json1["data"].string != nil{
                    handle(success: true, response:json1["data"].string!)
                }
            }else{
                if json1["data"].string != nil{
                handle(success: false, response:json1["data"].string!)
                }
            }
        }
        
        Alamofire.upload(.POST, url, data: imageData).response { request, response, json, error in
            NSLOG(json)
            NSLOG(request)
            let json1 = JSON(data:json!)
            NSLOG(json1)
            indicator.stopAnimating()
            
            if json1["status"].string != nil && json1["status"].string == "success"{
                //                print(result.datas)
                handle(success: true, response: json!)
            }else{
                if json1["data"].string != nil{
                    handle(success: false, response:json1["data"].string!)
                }
                
            }
        }
    }
    
    
}
