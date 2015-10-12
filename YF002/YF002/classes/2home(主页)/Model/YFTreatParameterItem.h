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
@property (nonatomic, copy) NSString *treatDate;

@property (nonatomic, strong) NSDictionary *defaultTreatItem;
//从treatItem.plist中读取的治疗参数库
@property (nonatomic, strong) NSMutableArray *datafromTreatItem;
//从treatItemList读取的数据
@property (nonatomic, strong) NSDictionary *datafromTreatItemList;
//从treatHistory读取的数据
@property (nonatomic, strong) NSMutableArray *datafromTreatHistory;
-(instancetype)initWithIndex:(NSInteger) item;

- (void)newParameterWithIndex:(NSInteger) item;
@end