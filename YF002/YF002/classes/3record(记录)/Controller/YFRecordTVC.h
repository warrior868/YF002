//
//  YFRecordTVC.h
//  YF002
//
//  Created by Mushroom on 5/31/15.
//  Copyright (c) 2015 Mushroom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "treatRecordTVCell.h"
@protocol YFRecordTVCDelegate <NSObject>


- (NSMutableArray *)ArrayToRecordTVC;

@end

@interface YFRecordTVC : UITableViewController


@property (strong,nonatomic) NSMutableArray            *recordArray;
@property (nonatomic,weak) id <YFRecordTVCDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableview;


@end
