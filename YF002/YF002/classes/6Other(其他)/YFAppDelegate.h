//
//  AppDelegate.h
//  YF002
//
//  Created by Mushroom on 4/20/15.
//  Copyright (c) 2015 Mushroom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bleCentralManager.h"
// 消息通知
//==============================================
// 发送消息
#define nEnterBackground                        [[NSNotificationCenter defaultCenter]postNotificationName:@"CBEnterBackground" object:nil];
#define nEnterForeground                        [[NSNotificationCenter defaultCenter]postNotificationName:@"CBEnterForeground" object:nil];

// 接收消息
#define nCBEnterBackground                      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CBEnterBackground ) name:@"CBEnterBackground" object:nil];
#define nCBEnterForeground                      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CBEnterForeground ) name:@"CBEnterForeground" object:nil];
//==============================================


@interface YFAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) bleCentralManager *ble;

@end

