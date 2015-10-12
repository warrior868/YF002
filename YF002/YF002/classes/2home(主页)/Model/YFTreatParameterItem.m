//
//  YFTreatParameterItem.m
//  YF002
//
//  Created by Mushroom on 5/25/15.
//  Copyright (c) 2015 Mushroom. All rights reserved.
//

#import "YFTreatParameterItem.h"


@implementation YFTreatParameterItem

//一个初始化方法


-(instancetype)initWithIndex:(NSInteger) item{
    if(self = [super init]){
        
        [self readFromTreatItemList];
        [self readFromTreatItem];
        [self readFromTreatHistory];
        NSDictionary *dic = [_datafromTreatItem objectAtIndex:item];
        _treatTime = [dic objectForKey:@"treatTime"];
        _treatStrength = [dic objectForKey:@"treatStrength"];
        _treatWave = [dic objectForKey:@"treatWave"];
        _treatModel = [dic objectForKey:@"treatModel"];
        _treatName = [dic objectForKey:@"treatName"];
        _treatDate = [dic objectForKey:@"treatDate"];
    }
    return self;
}

- (void)newParameterWithIndex:(NSInteger) item{
    NSDictionary *dic = [_datafromTreatItem objectAtIndex:item];
    _treatTime = [dic objectForKey:@"treatTime"];
    _treatStrength = [dic objectForKey:@"treatStrength"];
    _treatWave = [dic objectForKey:@"treatWave"];
    _treatModel = [dic objectForKey:@"treatModel"];
    _treatName = [dic objectForKey:@"treatName"];
    _treatDate = [dic objectForKey:@"treatDate"];
}


/**  read from treatTtem.plist
*
*  @return property  _datafromTreatItem  about treatTtem
*/
-(void)readFromTreatItem{
    //读取plist,生成第一级别的dictionary
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
   plistPath = [rootPath stringByAppendingPathComponent:@"treatItem.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
    plistPath = [[NSBundle mainBundle] pathForResource:@"treatItem" ofType:@"plist"];
    }
   _datafromTreatItem = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    //对数组中的字典按照日期进行排序
    NSMutableArray *sortDescriptors = [NSMutableArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"treatDate" ascending:YES]];
    [_datafromTreatItem sortUsingDescriptors:sortDescriptors];
      

    
    }

/**
 *  read from treatTtemList.plist
 *
 *  @return property  _datafromTreatItemList  about treatTtem
 */
-(void)readFromTreatItemList{
 //读取plist
    NSString *plistPath1;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    plistPath1 = [rootPath stringByAppendingPathComponent:@"treatItemList.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath1]) {
        plistPath1 =  [[NSBundle mainBundle] pathForResource:@"treatItemList" ofType:@"plist"];
    }
    
    NSLog(@"%d",[[NSFileManager defaultManager] fileExistsAtPath:plistPath1] );
    _datafromTreatItemList = [[NSDictionary alloc] initWithContentsOfFile:plistPath1];
    
 //   [mySettingData synchronize];
    
    
}
-(void)readFromTreatHistory{
    //读取plist
    NSString *plistPath1;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    plistPath1 = [rootPath stringByAppendingPathComponent:@"treatHistory.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath1]) {
        plistPath1 =  [[NSBundle mainBundle] pathForResource:@"treatHistory" ofType:@"plist"];
    }
    
    NSLog(@"%d",[[NSFileManager defaultManager] fileExistsAtPath:plistPath1] );
    _datafromTreatHistory = [[NSMutableArray alloc] initWithContentsOfFile:plistPath1];
    //对数组中的字典按照日期进行排序
    NSMutableArray *sortDescriptors = [NSMutableArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"treatDate" ascending:YES]];
    [_datafromTreatItem sortUsingDescriptors:sortDescriptors];
    //   [mySettingData synchronize];
    
    
}
@end
