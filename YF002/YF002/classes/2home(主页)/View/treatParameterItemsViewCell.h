//
//  treatParameterItemsViewCell.h
//  YF002
//
//  Created by Mushroom on 5/27/15.
//  Copyright (c) 2015 Mushroom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YFTreatParameterItem.h"
@interface treatParameterItemsViewCell: UITableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView withTreatItem:(YFTreatParameterItem *)treatParameterItem;

@property (nonatomic, strong) YFTreatParameterItem *TreatParameterItem;

@end
