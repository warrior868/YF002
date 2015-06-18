//
//  YFPamameterItemTableViewController.m
//  YF002
//
//  Created by Mushroom on 5/27/15.
//  Copyright (c) 2015 Mushroom. All rights reserved.
//

#import "YFPamameterItemTableViewController.h"


@interface YFPamameterItemTableViewController ()
<UITableViewDataSource,UITabBarDelegate>


@property (nonatomic ,strong) NSIndexPath *lastIndexPath;

@end

@implementation YFPamameterItemTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self delegateMethodGetArrayFromHomeCV];

   
    //对数组中的字典按照日期进行排序
    NSMutableArray *sortDescriptors = [NSMutableArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"treatDate" ascending:YES]];
    [_tableViewArray sortUsingDescriptors:sortDescriptors];
    NSLog(@"排序后的数组%@",_tableViewArray);
    //初始化选中行
    _lastIndexPath= [NSIndexPath indexPathForRow:0 inSection:0 ];
    [self.tableView selectRowAtIndexPath:_lastIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
  
}
//从代理那边拿到tableView 显示的数组
- (void)delegateMethodGetArrayFromHomeCV {
    
     _tableViewArray = (NSMutableArray *)   [self.delegate getArrayHomeVC];
    
}



#pragma mark - TableViewCell选中某行，取消之前选中行

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int newRow = [indexPath row];
    int oldRow = [_lastIndexPath row];
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:_lastIndexPath];
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    if (newRow != oldRow)
    {
        //新旧不同的两行，对旧的行进行背景颜色赋值
        newCell.backgroundColor = [UIColor redColor];
        if ((oldRow % 2) == 1) {
            oldCell.backgroundColor = [UIColor colorWithRed:255.0/255 green:255.0/255 blue:245.0/255 alpha:1];
        }else{
            oldCell.backgroundColor = [UIColor whiteColor ];
        };
        //把新的行设置成下次操作的旧的行
        _lastIndexPath = indexPath;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"选中了%d",newRow );
    [self.delegate sendSelectedItemToHomeVC:newRow];
    
    
}
#pragma mark - TableViewcell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{       //设置cell的高度
        return 100.0;
    }

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [_tableViewArray count];
}

#pragma mark - 生成Tableviewcell内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //创建cell
     NSDictionary *dicInCell = _tableViewArray[indexPath.row];
    treatParameterItemsViewCell *cell = [treatParameterItemsViewCell cellWithTableView:tableView withTreatItem:dicInCell];
    // 隔行显示颜色
    if ((indexPath.row % 2) == 1) {
        cell.backgroundColor = [UIColor colorWithRed:255.0/255 green:255.0/255 blue:245.0/255 alpha:1];
    }
    cell.selectedBackgroundView.backgroundColor = [UIColor redColor ];

    // 2.给cell传递模型数据
    
    //cell= self.tableViewArray[indexPath.row];
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
#pragma mark - Tableviewcell删除该行
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [_tableViewArray removeObjectAtIndex:indexPath.row ];
        [tableView reloadData];
        NSString *plistPath1;
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        plistPath1 = [rootPath stringByAppendingPathComponent:@"treatItem.plist"];

        [_tableViewArray writeToFile:plistPath1 atomically:YES];
//        [tableView  deleteRowsAtIndexPaths:indexPath withRowAnimation:UITableViewRowAnimationFade];
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


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
