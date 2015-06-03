//
//  YFCalendarVC.h
//  YF002
//
//  Created by Mushroom on 6/3/15.
//  Copyright (c) 2015 Mushroom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCalendar.h"


@interface YFCalendarVC : UIViewController <JTCalendarDataSource>
@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;

@property (weak, nonatomic) IBOutlet JTCalendarContentView *calendarContentView;



@property (strong, nonatomic) JTCalendar *calendar;
@end
