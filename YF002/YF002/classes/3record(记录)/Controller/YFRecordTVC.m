//
//  YFRecordTVC.m
//  YF002
//
//  Created by Mushroom on 5/31/15.
//  Copyright (c) 2015 Mushroom. All rights reserved.
//

#import "YFRecordTVC.h"

@interface YFRecordTVC ()

@end

@implementation YFRecordTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //读取plist,生成第一级别的dictionary
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:@"treatHistory.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath =  [[NSBundle mainBundle] pathForResource:@"treatHistory" ofType:@"plist"];
    }
    _recordArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
//    //block比较方法，数组中可以是NSInteger，NSString（需要转换）
//    NSComparator finderSort = ^(id string1,id string2){
//        
//        if ([string1 integerValue] > [string2 integerValue]) {
//            return (NSComparisonResult)NSOrderedDescending;
//        }else if ([string1 integerValue] < [string2 integerValue]){
//            return (NSComparisonResult)NSOrderedAscending;
//        }
//        else
//            return (NSComparisonResult)NSOrderedSame;
//    };
    
    //数组排序：
//    NSArray *originalArray1 = [originalArray sortedArrayUsingComparator:finderSort];
    
    
    NSLog(@"第一种排序结果：%@",_recordArray);
    [self reloadArrayFromHomeVC];
//    [_tableview reloadData];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeNameNotification:) name:@"ChangeNameNotification" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) reloadArrayFromHomeVC{
    _recordArray = [self.delegate ArrayToRecordTVC];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [_recordArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{       //设置cell的高度
    return 100.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //创建cell
    NSDictionary *dicInCell = _recordArray[indexPath.row];
    treatRecordTVCell *cell = [treatRecordTVCell cellWithTableView:tableView withTreatItem:dicInCell];
    // 隔行显示颜色
    if ((indexPath.row % 2) == 1) {
        cell.backgroundColor = [UIColor colorWithRed:255.0/255 green:255.0/255 blue:245.0/255 alpha:1];
    }
   // cell.selectedBackgroundView.backgroundColor = [UIColor redColor ];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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
