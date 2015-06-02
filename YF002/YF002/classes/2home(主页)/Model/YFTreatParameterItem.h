//
//  YFTreatParameterItem.h
//  YF002
//
//  Created by Mushroom on 5/25/15.
//  Copyright (c) 2015 Mushroom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFTreatParameterItem : NSObject

@property (nonatomic, copy) NSString *treatTime;
@property (nonatomic, copy) NSString *treatStrength;
@property (nonatomic, copy) NSString *treatWave;
@property (nonatomic, copy) NSString *treatModel;
@property (nonatomic, copy) NSString *treatName;

@property (nonatomic, strong) NSDictionary *defaultTreatItem;
//从treatItem读取的数据
@property (nonatomic, strong) NSArray *datafromTreatItem;
//从treatItemList读取的数据
@property (nonatomic, strong) NSDictionary *datafromTreatItemList;
-(instancetype)initWithIndex:(NSInteger) item;
@end