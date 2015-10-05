//
//  YFTabBarViewController.m
//  YF002
//
//  Created by Mushroom on 5/19/15.
//  Copyright (c) 2015 Mushroom. All rights reserved.
//

#import "YFTabBarViewController.h"
#import "YFNewfeatureViewController.h"
#import "YFHomeViewController.h"
#import "YFRecordTVC.h"
#import "YFHistoryVC.h"
#import "YFSettingTableViewController.h"
#import "YFNavigationController.h"




@interface YFTabBarViewController ()

@end

@implementation YFTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

/**
 *  1.版本比较 出现新特性
 */
- (void)viewDidAppear:(BOOL)animated
{
    NSString *key = @"CFBundleVersion";
       self.navigationController.navigationBarHidden = NO;
    // 取出沙盒中存储的上次使用软件的版本号
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults stringForKey:key];
    
    // 获得当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
    if ([currentVersion isEqualToString:lastVersion]) {

    }
    else { // 新版本
        
          // 存储新版本
        [defaults setObject:currentVersion forKey:key];
        [defaults synchronize];
        // 跳转到新特性控制器
        [self performSegueWithIdentifier:@"newFeatureView" sender:nil];
    }

       }
  


/**
 *  初始化一个子控制器
 *
 *  @param childVc           需要初始化的子控制器
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */





@end
