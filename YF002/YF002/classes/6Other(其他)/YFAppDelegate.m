//
//  AppDelegate.m
//  YF002
//
//  Created by Mushroom on 4/20/15.
//  Copyright (c) 2015 Mushroom. All rights reserved.
//

#import "YFAppDelegate.h"
#import "YFTabBarViewController.h"
#import "YFNewfeatureViewController.h"


@interface YFAppDelegate ()

@end
@interface YFAppDelegate ()

@end

@implementation YFAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    
    //启动画面延时
    [NSThread sleepForTimeInterval:1.5];
    [_window makeKeyAndVisible];
    
        // 初始化蓝牙管理控制器
    _ble = [[bleCentralManager alloc]init];
   
    /*
    //闹钟设置
    [[LKAlarmMamager shareManager] didFinishLaunchingWithOptions:launchOptions];
    ///注册下回调
    [[LKAlarmMamager shareManager] registDelegateWithObject:self];
    
    NSMutableArray *alarmList = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarmList"];
    NSMutableArray *timeArray = [[alarmList objectAtIndex:0] mutableCopy];
    NSMutableArray *onOrOffArray = [[alarmList objectAtIndex:1] mutableCopy];
    for (NSInteger i=0; i<[timeArray count]-1; i++) {
        if ([[onOrOffArray objectAtIndex:i] isEqualToString:@"on"]) {
            
            //当前的日期
            NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"YYYY-MM-dd-"];
            NSMutableString *date = [[formatter stringFromDate:[NSDate date]] mutableCopy];
            
            //[date stringByAppendingString:[timeArray objectAtIndex:i]];
            NSString *date1 = [[NSString alloc] init];
            date1 =[date stringByAppendingFormat:@"%@",[timeArray objectAtIndex:i]];
            // NSLog(@"Date1 = %@ /n", date1);
            NSString *date2 =[date1 stringByAppendingString:@"00"];
            //NSLog(@"Date = %@ /n", date2);
            
            //转化成闹钟的日期
            NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init] ;
            [inputFormatter setDateFormat:@"YYYY-MM-dd-hh:mmss"];
            NSDate* inputDate = [inputFormatter dateFromString:date2];
            //NSLog(@"Date = %@", inputDate);
            if ([inputDate laterDate:[NSDate date]]) {
                ///本地提醒
                LKAlarmEvent* notifyEvent = [LKAlarmEvent new];
                notifyEvent.title = [NSString stringWithFormat:@"请按照处方进行使用。"];
                ///强制加入到本地提醒中
                notifyEvent.isNeedJoinLocalNotify = YES;
                ///提醒时间
                notifyEvent.startDate = inputDate;
                notifyEvent.repeatType = NSCalendarUnitDay;
                
                ///增加推送声音
                [notifyEvent setOnCreatingLocalNotification:^(UILocalNotification * localNotification) {
                    localNotification.soundName = UILocalNotificationDefaultSoundName;
                    
                }];
                
                [[LKAlarmMamager shareManager] addAlarmEvent:notifyEvent];
            }
            
            
        }
    }
     */

    // Override point for customization after application launch.
    return YES;
}




-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    
    return YES;
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    }
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
