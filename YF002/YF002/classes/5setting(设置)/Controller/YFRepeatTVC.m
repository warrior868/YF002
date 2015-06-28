//
//  YFRepeatTVC.m
//  YF002
//
//  Created by Mushroom on 6/24/15.
//  Copyright (c) 2015 Mushroom. All rights reserved.
//

#import "YFRepeatTVC.h"

@interface YFRepeatTVC ()

@property (nonatomic ,assign) NSInteger  newRow;
@property (nonatomic ,strong) NSMutableArray *selectedArray;
@property (nonatomic ,strong) NSIndexPath *lastIndexPath;
@property (nonatomic ,strong) NSMutableDictionary  *selectValueDictionary;

@end

@implementation YFRepeatTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectedArray =[NSMutableArray arrayWithObjects:@"0",@"1",@"0",@"1",@"0",@"1",@"0",@"0",nil];
    
    
    _lastIndexPath= [NSIndexPath indexPathForRow:_newRow inSection:6 ];
    [self.tableView selectRowAtIndexPath:_lastIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self.tableView deselectRowAtIndexPath:_lastIndexPath animated:YES];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

    
    UITableViewCell *cell = [self.tableView
                             cellForRowAtIndexPath: indexPath ];
    
    if (cell.accessoryType ==UITableViewCellAccessoryNone){
        cell.accessoryType =UITableViewCellAccessoryCheckmark;
        [_selectValueDictionary setObject:indexPath forKey:[_selectedArray objectAtIndex:indexPath.row]];
        
    }
    else{
        [_selectValueDictionary removeObjectForKey:[_selectedArray objectAtIndex:indexPath.row]];
        cell.accessoryType =UITableViewCellAccessoryNone;
    }
    
    NSLog(@"%@ ,%@",_selectedArray,_selectValueDictionary);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
