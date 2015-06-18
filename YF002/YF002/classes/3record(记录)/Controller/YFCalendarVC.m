//
//  YFCalendarVC.m
//  YF002
//
//  Created by Mushroom on 6/3/15.
//  Copyright (c) 2015 Mushroom. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "YFCalendarVC.h"

@interface YFCalendarVC (){
    NSMutableDictionary *eventsByDate;
    
}
@property (nonatomic ,strong) NSMutableArray *recordArray;
@end

@implementation YFCalendarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    VRGCalendarView *calendar = [[VRGCalendarView alloc] init];
    calendar.delegate=self;
    calendar.frame = CGRectMake(0, 60, 320, 320);
    [self.view addSubview:calendar];
    
    // Do any additional setup after loading the view.
    //读取plist,生成第一级别的dictionary
    NSString *plistPath;
//    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
//    plistPath = [rootPath stringByAppendingPathComponent:@"treatHistory.plist"];
    
    plistPath =  [[NSBundle mainBundle] pathForResource:@"treatHistory" ofType:@"plist"];
   
    _recordArray = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
}

#pragma mark - calendarDelegate

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated {
    NSMutableArray *markDates = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<[_recordArray count]; i++) {
       NSString *treatDate = [_recordArray[i] objectForKey:@"treatDate" ];
        //读取历史纪录中的月字符串
        NSString *treatMonth =[treatDate substringWithRange:NSMakeRange(4, 2)];
        //读取历史纪录中的月为数值
        NSInteger treatMonthInterger = [treatMonth integerValue];
        if (treatMonthInterger == month) {
            NSString *treatDay = [treatDate substringWithRange:NSMakeRange(6, 2)];
            NSInteger treatDayInterger = [treatDay integerValue];
            NSNumber *numberDay = [NSNumber numberWithInteger:treatDayInterger];
            [markDates addObject:numberDay];
        }
    };
        //NSLog(@"day is %@",markDates);
        [calendarView markDates:markDates];
    
}

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date {
    NSLog(@"Selected date = %@",date);
}

#pragma mark - Transition examples

//- (void)transitionExample
//{
//    CGFloat newHeight = 300;
//    if(self->calendar.calendarAppearance.isWeekMode){
//        newHeight = 75.;
//    }
//    
//    [UIView animateWithDuration:.5
//                     animations:^{
//                         self.calendarContentViewHeight.constant = newHeight;
//                         [self.view layoutIfNeeded];
//                     }];
//    
//    [UIView animateWithDuration:.25
//                     animations:^{
//                         self.calendarContentView.layer.opacity = 0;
//                     }
//                     completion:^(BOOL finished) {
//                         [self.calendar reloadAppearance];
//                         
//                         [UIView animateWithDuration:.25
//                                          animations:^{
//                                              self.calendarContentView.layer.opacity = 1;
//                                          }];
//                     }];
//}

#pragma mark - Fake data

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}

- (void)createRandomEvents
{
    eventsByDate = [NSMutableDictionary new];
    
    for(int i = 0; i < 30; ++i){
        // Generate 30 random dates between now and 60 days later
        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
        
        // Use the date as key for eventsByDate
        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
        
        if(!eventsByDate[key]){
            eventsByDate[key] = [NSMutableArray new];
        }
        
        [eventsByDate[key] addObject:randomDate];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
