//
//  YFHistoryVC.h
//  YF002
//
//  Created by Mushroom on 5/31/15.
//  Copyright (c) 2015 Mushroom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SliderSwitch.h"
#import "InfoView.h"
#import "chatView.h"
typedef enum{
    year=0,
    month,
    day,
    week
}State;

@interface YFHistoryVC : UIViewController

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,weak) UIView *aview;


@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property(nonatomic,strong) SliderSwitch *slideSwitchH;

@property (nonatomic,strong) NSMutableArray *recordArray;
-(void)loadAreaDicWithCGRect:(CGRect) cgrect;
@end
