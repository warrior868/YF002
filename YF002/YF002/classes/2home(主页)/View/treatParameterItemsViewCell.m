//
//  treatParameterItemsViewCell.m
//  YF002
//
//  Created by Mushroom on 5/27/15.
//  Copyright (c) 2015 Mushroom. All rights reserved.
//

#import "treatParameterItemsViewCell.h"

@interface treatParameterItemsViewCell()
@property (weak, nonatomic) IBOutlet UIButton *check;
@property (weak, nonatomic) IBOutlet UILabel *treatTime;
@property (weak, nonatomic) IBOutlet UILabel *treatStrength;
@property (weak, nonatomic) IBOutlet UILabel *treatWave;
@property (weak, nonatomic) IBOutlet UILabel *treatModel;
@property (weak, nonatomic) IBOutlet UILabel *cellName;



@end

@implementation treatParameterItemsViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView withTreatItem:(YFTreatParameterItem *)treatParameterItem
{
    static NSString *ID = @"treatItem";
    treatParameterItemsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"treatParameterItemsViewCell" owner:nil options:nil] lastObject];
    }
//    self.treatTime.text = treatParameterItem.treatTime;
    cell.treatTime.text = @"18";
    // 2.强度
    cell.treatStrength.text = treatParameterItem.treatStrength;
    
    // 3.波形
    cell.treatWave.text = treatParameterItem.treatWave;
    
    // 4.电极
    cell.treatModel.text = treatParameterItem.treatModel;
    return cell;
}

- (void)setTreatItem:(YFTreatParameterItem *)treatParameterItem
{
//    _tg = tg;
    
    // 1.时间
    //self.treatTime.text = treatParameterItem.treatTime;
    self.treatTime.text = @"180";
    // 2.强度
    self.treatStrength.text = treatParameterItem.treatStrength;
    
    // 3.波形
    self.treatWave.text = treatParameterItem.treatWave;
    
    // 4.电极
    self.treatModel.text = treatParameterItem.treatModel;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
