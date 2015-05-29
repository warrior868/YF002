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
-(instancetype)init{
    if(self = [super init]){

        [self readFromTreatItemList];
        [self readFromTreatItemOrSelectItem:0];
         _treatTime = [_defaultTreatItem objectForKey:@"treatTime"];
         _treatStrength = [_defaultTreatItem objectForKey:@"treatStrength"];
         _treatWave = [_defaultTreatItem objectForKey:@"treatWave"];
         _treatModel = [_defaultTreatItem objectForKey:@"treatModel"];
    }
    return self;
}

/**  read from treatTtem.plist
*
*  @return property  _datafromTreatItem  about treatTtem
*/
-(NSMutableDictionary *)readFromTreatItemOrSelectItem:(NSInteger)item{
    //读取plist,生成第一级别的dictionary
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"treatItem" ofType:@"plist"];
    _datafromTreatItem = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    //取出第一级别的dictionary中的第item个treatItem 生成新的_defaultTreatItem
    _defaultTreatItem =[_datafromTreatItem objectForKey:@"上次使用参数"] ;
    
    
    
    //   [mySettingData synchronize];
    
    return  _datafromTreatItem;
}

/**
 *  read from treatTtemList.plist
 *
 *  @return property  _datafromTreatItemList  about treatTtem
 */
-(NSMutableDictionary *)readFromTreatItemList{
 //读取plist
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"treatItemList" ofType:@"plist"];
    _datafromTreatItemList = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
 //   [mySettingData synchronize];
    
    return  _datafromTreatItemList;
}
@end
