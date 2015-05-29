//
//  YFTreatParameterItem.h
//  YF002
//
//  Created by Mushroom on 5/25/15.
//  Copyright (c) 2015 Mushroom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFTreatParameterItem : NSObject

@property (nonatomic, strong) NSString *treatTime;
@property (nonatomic, strong) NSString *treatStrength;
@property (nonatomic, strong) NSString *treatWave;
@property (nonatomic, strong) NSString *treatModel;
@property (nonatomic, strong) NSString *treatItemName;

@property (nonatomic, strong) NSMutableDictionary *defaultTreatItem;
//从treatItem读取的数据
@property (nonatomic, strong) NSMutableDictionary *datafromTreatItem;
//从treatItemList读取的数据
@property (nonatomic, strong) NSMutableDictionary *datafromTreatItemList;
@end