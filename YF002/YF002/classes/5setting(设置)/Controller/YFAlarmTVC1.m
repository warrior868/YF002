//
//  YFAlarmTVC.m
//  YF002
//
//  Created by Mushroom on 6/16/15.
//  Copyright (c) 2015 Mushroom. All rights reserved.
//

#import "YFAlarmTVC.h"

#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "YFNewAlarmTableViewCell.h"
#import "YFAlarmBtnTableViewCell.h"

@interface YFAlarmTVC () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) NSMutableArray *weekName;
@property (nonatomic ,strong) NSMutableArray *selectedArray;
@property (nonatomic ,strong) NSIndexPath *lastIndexPath;
@property (nonatomic ,assign) NSInteger   newRow;


@end

@implementation YFAlarmTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //隐藏多余的分割线
    self.tableView.tableFooterView = [[UIView alloc ] init];

    _selectedArray = [NSMutableArray arrayWithObjects:@"06:30", @"11:30",@"16:30",nil];
    

    _lastIndexPath= [NSIndexPath indexPathForRow:_newRow =0 inSection:0 ];
    // 0.设置返回按钮的背景图片
    // 0.1隐藏原有的返回按钮
    [self.navigationItem setHidesBackButton:YES];
    // 0.2新建一个按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(15, 5, 32, 20);
    [btn setBackgroundImage:[UIImage imageNamed:@"backicon"] forState:UIControlStateNormal];
    // 0.3增加selector的方法
    [btn addTarget: self action: @selector(goBackAction) forControlEvents: UIControlEventTouchUpInside];
    // 0.4设置导航栏的leftButton
    UIBarButtonItem *back=[[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=back;

}
#pragma mark - Alarm
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

/*- (IBAction)testKEEvent {
 
 NSDate *select = [_timePicker date];
 //   NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
 //    [dateFormatter setDateFormat:@"HH:mm"];
 //    NSString *dateAndTime =  [dateFormatter stringFromDate:select];
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已经在日历中设置闹钟" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
 [alert show];
 //在日历中创建闹钟
 EKEventStore *eventDB = [[EKEventStore alloc] init];
 [eventDB requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted,NSError *error) {
 // handle access here
 EKEvent *myEvent  = [EKEvent eventWithEventStore:eventDB];
 myEvent.title     = @"使用HeadaTerm";
 [myEvent setCalendar:[eventDB defaultCalendarForNewEvents]];
 myEvent.startDate = select;
 myEvent.endDate   = [select dateByAddingTimeInterval:5*60];
 myEvent.allDay = NO;
 if (_newRow == 0) {
 NSError *err;
 EKRecurrenceRule *recurrenceRule1 =  [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyDaily interval:1 end:[EKRecurrenceEnd recurrenceEndWithOccurrenceCount:2]];
 
 [myEvent addRecurrenceRule:recurrenceRule1];
 [eventDB saveEvent:myEvent span:EKSpanThisEvent error:&err];
 
 }else if (_newRow == 1){
 NSError *err;
 EKRecurrenceRule *recurrenceRule1 =  [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyDaily interval:1 end:[EKRecurrenceEnd recurrenceEndWithOccurrenceCount:7]];
 
 [myEvent addRecurrenceRule:recurrenceRule1];
 [eventDB saveEvent:myEvent span:EKSpanThisEvent error:&err];
 }else{
 NSError *err;
 EKRecurrenceRule *recurrenceRule1 =  [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:EKRecurrenceFrequencyDaily interval:1 end:[EKRecurrenceEnd recurrenceEndWithOccurrenceCount:30]];
 
 [myEvent addRecurrenceRule:recurrenceRule1];
 [eventDB saveEvent:myEvent span:EKSpanThisEvent error:&err];
 }
 
 
 }];
 }
*/
#pragma mark - Table view data source
#pragma mark tableview中cell的高度

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == _selectedArray.count-1) {
       return 46;
    }else{
       return 76;
    }
    
};

#pragma mark tableview中section的数量
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 return 1;
 }

#pragma mark tableview中每个section中cell数量
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
 
 return _selectedArray.count;
 }
 
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     if (indexPath.row == _selectedArray.count-1) {
         [_selectedArray addObject:@"12:30"];
         [self.tableView reloadData ];
     }
     //每次只选中行
//     {_newRow = [indexPath row];
// NSInteger oldRow = [_lastIndexPath row];
// UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:_lastIndexPath];
// UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
// if (_newRow != oldRow)
// {
// //新旧不同的两行，对旧的行进行背景颜色赋值
// if (newCell.accessoryType == UITableViewCellAccessoryNone){
// newCell.accessoryType = UITableViewCellAccessoryCheckmark;
// oldCell.accessoryType = UITableViewCellAccessoryNone;
// }
// 
// 
// //把新的行设置成下次操作的旧的行
// _lastIndexPath = indexPath;
// }
// 
// [tableView deselectRowAtIndexPath:_lastIndexPath animated:YES];
//     }
 }
 
 
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     
 static NSString *SimpleTableIdentifier=@"weekName";
     
 UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
 //如果行元素为空的话 则新建一行
 if(cell==nil){
     NSLog(@"indexPath.row is %ld", (long)indexPath.row);
    if (indexPath.row == _selectedArray.count-1) {
         cell =(YFAlarmBtnTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"YFAlarmBtn" owner:self options:nil]  lastObject];
     }else{
         cell= (YFNewAlarmTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"NewAlarm" owner:self options:nil]  lastObject];
         YFNewAlarmTableViewCell *alarmCell = [[YFNewAlarmTableViewCell alloc] init];
         
         alarmCell.timeTextField.text =@"15:25";
         
     }
     
 }
 
 return cell;
 }



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark  增加返回按钮的自定义动作
-(void)goBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
