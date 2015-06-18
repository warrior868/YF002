//
//  YFHistoryVC.h
//  YF002
//
//  Created by Mushroom on 5/31/15.
//  Copyright (c) 2015 Mushroom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SliderSwitch.h"

@interface YFHistoryVC : UIViewController

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,weak) UIView *aview;
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic,strong) SliderSwitch *slideSwitchH;

@property (nonatomic,strong) NSArray *recordArray;
-(void)loadAreaDicWithCGRect:(CGRect) cgrect;
@end
