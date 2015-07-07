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
    
    

    _weekName = [NSMutableArray arrayWithObjects:@"星期一", @"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日",nil];
    NSNumber *number = [NSNumber numberWithInteger:0 ];
    _selectedArray = [NSMutableArray arrayWithObjects:number, number,number, number,number,number, number,nil];
    

    _lastIndexPath= [NSIndexPath indexPathForRow:_newRow =0 inSection:0 ];
    UITableViewCell *oldCell = [self.tableView cellForRowAtIndexPath:_lastIndexPath];
    oldCell.accessoryType = UITableViewCellAccessoryCheckmark;

}
#pragma mark - Alarm
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (IBAction)testKEEvent {
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {


    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _newRow = [indexPath row];
    NSInteger oldRow = [_lastIndexPath row];
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:_lastIndexPath];
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    if (_newRow != oldRow)
    {
        //新旧不同的两行，对旧的行进行背景颜色赋值
        if (newCell.accessoryType == UITableViewCellAccessoryNone){
            newCell.accessoryType = UITableViewCellAccessoryCheckmark;
            oldCell.accessoryType = UITableViewCellAccessoryNone;
        }
       
        
        //把新的行设置成下次操作的旧的行
        _lastIndexPath = indexPath;
    }

    [tableView deselectRowAtIndexPath:_lastIndexPath animated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SimpleTableIdentifier=@"weekName";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    //如果行元素为空的话 则新建一行
    if(cell==nil){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
    }
    //取得当前行
    if (indexPath.section == 0 ) {
        if ([indexPath row] ==0) {
            cell.backgroundColor = [UIColor colorWithRed:255.0/255 green:255.0/255 blue:245.0/255 alpha:1];
            //设置每一行要显示的值
            cell.textLabel.text=@"只提醒一次";

        }else if ([indexPath row] == 1){
            cell.textLabel.text= @"每天提醒持续一周";
            cell.backgroundColor = [UIColor colorWithRed:245.0/255 green:255.0/255 blue:255.0/255 alpha:1];
        }else{
            cell.textLabel.text= @"每天提醒持续一月";
            cell.backgroundColor = [UIColor colorWithRed:255.0/255 green:255.0/255 blue:245.0/255 alpha:1];
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

@end
