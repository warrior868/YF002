//
//  treatRecordTVCell.h
//  YF002
//
//  Created by Mushroom on 5/31/15.
//  Copyright (c) 2015 Mushroom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface treatRecordTVCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *treatTime;
@property (weak, nonatomic) IBOutlet UIImageView *treatWave;

@property (weak, nonatomic) IBOutlet UIImageView *treatStrength;

@property (weak, nonatomic) IBOutlet UIImageView *treatModel;

@property (weak, nonatomic) IBOutlet UILabel *treatDate;
@property (weak, nonatomic) IBOutlet UILabel *treatDrug;
@property (weak, nonatomic) IBOutlet UILabel *treatDrugQuantity;
+ (instancetype)cellWithTableView:(UITableView *)tableView withTreatItem:(NSDictionary *)treatParameterItem;
@end
