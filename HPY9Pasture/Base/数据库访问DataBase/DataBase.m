//
//  DataBase.m
//  FMDBDemo
//
//  Created by Zeno on 16/5/18.
//  Copyright © 2016年 zenoV. All rights reserved.
//

#import "DataBase.h"
#import "HPY9Pasture-Swift.h"

#import "FMDB.h"

static DataBase *_DBCtl = nil;

@interface DataBase()<NSCopying,NSMutableCopying>{
    FMDatabase  *_db;
    
}




@end

@implementation DataBase

+(instancetype)sharedDataBase{
    
    if (_DBCtl == nil) {
        
        _DBCtl = [[DataBase alloc] init];
        
        [_DBCtl initDataBase];
        
    }
    
    return _DBCtl;
    
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    
    if (_DBCtl == nil) {
        
        _DBCtl = [super allocWithZone:zone];
        
    }
    
    return _DBCtl;
    
}

-(id)copy{
    
    return self;
    
}

-(id)mutableCopy{
    
    return self;
    
}

-(id)copyWithZone:(NSZone *)zone{
    
    return self;
    
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    
    return self;
    
}


-(void)initDataBase{
    // 获得Documents目录路径
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    // 文件路径
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"model.sqlite"];
    
    // 实例化FMDataBase对象
    
    _db = [FMDatabase databaseWithPath:filePath];
    
    [_db open];
    
    // 初始化数据表
//    NSString *personSql = @"CREATE TABLE 'serverPhone' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'person_id' VARCHAR(255),'person_name' VARCHAR(255),'person_age' VARCHAR(255),'person_number'VARCHAR(255)) ";
    NSString *personSql = @"CREATE TABLE 'serverPhone' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL,'server_name' VARCHAR(255),'person_phone' VARCHAR(255)) ";
//    NSString *carSql = @"CREATE TABLE 'car' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'own_id' VARCHAR(255),'car_id' VARCHAR(255),'car_brand' VARCHAR(255),'car_price'VARCHAR(255)) ";
    
    [_db executeUpdate:personSql];
//    [_db executeUpdate:carSql];
    
    
    [_db close];

}
#pragma mark - 接口

- (void)addPerson:(ServerPhone *)serverPhone{
    
    
//    NSNumber *maxID = @(0);
//    
//    FMResultSet *res = [_db executeQuery:@"SELECT * FROM serverPhone "];
//    //获取数据库中最大的ID
//    while ([res next]) {
//        if ([maxID integerValue] < [[res stringForColumn:@"person_id"] integerValue]) {
//            maxID = @([[res stringForColumn:@"person_id"] integerValue] ) ;
//        }
//        
//    }
//    maxID = @([maxID integerValue] + 1);
//    NSData *dataUrls = [NSKeyedArchiver archivedDataWithRootObject:serverPhone.phoneArray];
    NSLog(@"%@",[self getAllPerson]);
    BOOL isHave = NO;
    for (ServerPhone *ss in [self getAllPerson]) {
        if ([ss.name isEqualToString:serverPhone.name]) {
            isHave = YES;
            [self updatePerson:serverPhone];
        }
    }
    if (!isHave) {
        [_db open];
        NSError * error;
        NSData * dataUrls = [NSJSONSerialization dataWithJSONObject:serverPhone.phoneArray options:0 error:&error];
        NSLog(@"%@",dataUrls);
        
        NSString * jsonString = [[NSString alloc] initWithData:dataUrls encoding:(NSUTF8StringEncoding)];
        NSLog(@"%@",jsonString);
        [_db executeUpdate:@"INSERT INTO serverPhone(server_name,person_phone)VALUES(?,?)",serverPhone.name,jsonString];
    }
    
    
    
    
    
    
    [_db close];
    
}

- (void)deletePerson:(ServerPhone *)serverPhone{
    [_db open];
    
    [_db executeUpdate:@"DELETE FROM serverPhone WHERE server_name = ?",serverPhone.name];

    [_db close];
}

- (void)updatePerson:(ServerPhone *)serverPhone{
    [_db open];
    NSError * error;
    NSData * dataUrls = [NSJSONSerialization dataWithJSONObject:serverPhone.phoneArray options:0 error:&error];
    NSLog(@"%@",dataUrls);
    
    NSString * jsonString = [[NSString alloc] initWithData:dataUrls encoding:(NSUTF8StringEncoding)];
    NSLog(@"%@",jsonString);
    [_db executeUpdate:@"UPDATE 'serverPhone' SET person_phone = ?  WHERE server_name = ? ",jsonString,serverPhone.name];
//    [_db executeUpdate:@"UPDATE 'person' SET person_age = ?  WHERE person_id = ? ",@(person.age),person.ID];
//    [_db executeUpdate:@"UPDATE 'person' SET person_number = ?  WHERE person_id = ? ",@(person.number + 1),person.ID];

    
    
    [_db close];
}

- (void)deleteTable{
    [_db open];
    NSString *dropTable1 = @"DROP TABLE serverPhone";
    [_db executeQuery:dropTable1];
    [_db close];
}

- (NSMutableArray *)getAllPerson{
    [_db open];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM serverPhone"];
    
    while ([res next]) {
        ServerPhone *serverPhone = [[ServerPhone alloc] init];
        serverPhone.name = [res stringForColumn:@"server_name"];
        
         NSString *a = [res stringForColumn:@"person_phone"];
//        NSLog(@"%@",[res stringForColumn:@"person_phone"]);
//        NSLog(@"%@",a);
//        NSLog(@"%@",[res stringForColumn:@"server_name"]);
        NSError * error;
        id result = [NSJSONSerialization JSONObjectWithData:[a dataUsingEncoding:NSUTF8StringEncoding]
                                                    options:(NSJSONReadingAllowFragments) error:&error];
//        NSLog(@"%@",result);
        NSMutableArray *bb = (NSMutableArray *)result;
//        NSLog(@"%@",bb);
        serverPhone.phoneArray =  bb;
        
        
        [dataArray addObject:serverPhone];
        
    }
    
    [_db close];
    
    
    
    return dataArray;
    
    
}
///**
// *  给person添加车辆
// *
// */
//- (void)addCar:(Car *)car toPerson:(Person *)person{
//    [_db open];
//    
//    //根据person是否拥有car来添加car_id
//    NSNumber *maxID = @(0);
//    
//    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM car where own_id = %@ ",person.ID]];
//    
//    while ([res next]) {
//        if ([maxID integerValue] < [[res stringForColumn:@"car_id"] integerValue]) {
//             maxID = @([[res stringForColumn:@"car_id"] integerValue]);
//        }
//       
//    }
//     maxID = @([maxID integerValue] + 1);
//    
//    [_db executeUpdate:@"INSERT INTO car(own_id,car_id,car_brand,car_price)VALUES(?,?,?,?)",person.ID,maxID,car.brand,@(car.price)];
//    
//    
//    
//    [_db close];
//    
//}
///**
// *  给person删除车辆
// *
// */
//- (void)deleteCar:(Car *)car fromPerson:(Person *)person{
//    [_db open];
//    
//    
//    [_db executeUpdate:@"DELETE FROM car WHERE own_id = ?  and car_id = ? ",person.ID,car.car_id];
//
//    
//    [_db close];
//    
//    
//    
//}
///**
// *  获取person的所有车辆
// *
// */
//- (NSMutableArray *)getAllCarsFromPerson:(Person *)person{
//    
//    [_db open];
//    NSMutableArray  *carArray = [[NSMutableArray alloc] init];
//    
//    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM car where own_id = %@",person.ID]];
//    while ([res next]) {
//        Car *car = [[Car alloc] init];
//        car.own_id = person.ID;
//        car.car_id = @([[res stringForColumn:@"car_id"] integerValue]);
//        car.brand = [res stringForColumn:@"car_brand"];
//        car.price = [[res stringForColumn:@"car_price"] integerValue];
//        
//        [carArray addObject:car];
//        
//    }
//    [_db close];
//    
//    return carArray;
//    
//}
//- (void)deleteAllCarsFromPerson:(Person *)person{
//    [_db open];
//    
//    [_db executeUpdate:@"DELETE FROM car WHERE own_id = ?",person.ID];
//    
//    
//    [_db close];
//}

@end
