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
        NSDictionary *dic = [_datafromTreatItem objectAtIndex:item];
        _treatTime = [dic objectForKey:@"treatTime"];
        _treatStrength = [dic objectForKey:@"treatStrength"];
        _treatWave = [dic objectForKey:@"treatWave"];
        _treatModel = [dic objectForKey:@"treatModel"];
        _treatName = [dic objectForKey:@"treatName"];
    }
    return self;
}


/**  read from treatTtem.plist
*
*  @return property  _datafromTreatItem  about treatTtem
*/
-(void)readFromTreatItem{
    //读取plist,生成第一级别的dictionary
    NSString *plistPath1 = [[NSBundle mainBundle] pathForResource:@"treatItem" ofType:@"plist"];
   _datafromTreatItem = [[NSArray alloc] initWithContentsOfFile:plistPath1];
    
    
    //取出第一级别的dictionary中的第item个treatItem 生成新的_defaultTreatItem
   // _defaultTreatItem =[_datafromTreatItem objectForKey:@"上次使用参数"] ;
    
    
    
    //   [mySettingData synchronize];
    
    }

/**
 *  read from treatTtemList.plist
 *
 *  @return property  _datafromTreatItemList  about treatTtem
 */
-(void)readFromTreatItemList{
 //读取plist
    NSString *plistPath2 = [[NSBundle mainBundle] pathForResource:@"treatItemList" ofType:@"plist"];
    _datafromTreatItemList = [[NSDictionary alloc] initWithContentsOfFile:plistPath2];
    
 //   [mySettingData synchronize];
    
    
}
@end
