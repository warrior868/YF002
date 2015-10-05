//
//  YFPamameterItemTableViewController.h
//  YF002
//
//  Created by Mushroom on 5/27/15.
//  Copyright (c) 2015 Mushroom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YFTreatParameterItem.h"
#import "treatParameterItemsViewCell.h"
@protocol YFPamameterItemTVCDelegate <NSObject>

- (void)sendSelectedItemToHomeVC:(NSInteger ) rowForNewTreatItem;
- (NSArray *)getArrayHomeVC;
- (NSInteger )getRowFromHomeVC;
@end


@interface YFPamameterItemTableViewController : UIView

@property (nonatomic,weak) id <YFPamameterItemTVCDelegate> delegate;
@property (strong,nonatomic) YFTreatParameterItem      *treatParameterItemTV;
@property (strong,nonatomic) NSMutableArray                   *tableViewArray;
@property (assign,nonatomic) NSInteger                   newRow;

@end
