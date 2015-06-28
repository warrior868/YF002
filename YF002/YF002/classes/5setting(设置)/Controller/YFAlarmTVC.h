//
//  YFAlarmTVC.h
//  YF002
//
//  Created by Mushroom on 6/16/15.
//  Copyright (c) 2015 Mushroom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFAlarmTVC : UITableViewController


@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (strong ,nonatomic) NSArray *weeDayPicked;

@end
