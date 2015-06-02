//
//  YFHistoryVC.m
//  YF002
//
//  Created by Mushroom on 5/31/15.
//  Copyright (c) 2015 Mushroom. All rights reserved.
//

#import "YFHistoryVC.h"
#import "TableViewCell.h"

@interface YFHistoryVC () 

@end

@implementation YFHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //    _baseView.backgroundColor = [UIColor redColor];
    // Do any additional setup after loading the view.
    
    //    配置
    TableViewCell *lineChart = [[TableViewCell alloc] init];
    NSIndexPath *path = [NSIndexPath indexPathForRow:2 inSection:0];
    NSLog(@"%@", path);
    [lineChart configUI:path];
    [_baseView addSubview:lineChart];
    lineChart.frame = CGRectMake(0, 100, 100, 100) ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark - UITableView Datasource

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    //    return section?2:4;
//    return 1;
//    
//}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *cellIdentifier = @"TableViewCell";
//    
//    
//    
//    
//    return cell;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 170;
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
