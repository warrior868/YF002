//
//  treatParameterItemsViewCell.m
//  YF002
//
//  Created by Mushroom on 5/27/15.
//  Copyright (c) 2015 Mushroom. All rights reserved.
//

#import "treatParameterItemsViewCell.h"

@interface treatParameterItemsViewCell()

@property (weak, nonatomic) IBOutlet UILabel *treatName;

@property (weak, nonatomic) IBOutlet UIImageView *treatTime;

@property (weak, nonatomic) IBOutlet UIImageView *treatStrength;

@property (weak, nonatomic) IBOutlet UIImageView *treatWave;

@property (weak, nonatomic) IBOutlet UIImageView *treatModel;


@end

@implementation treatParameterItemsViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView withTreatItem:(NSDictionary *)treatParameterItem
{
    static NSString *ID = @"treatItem";
    treatParameterItemsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"treatParameterItemsViewCell" owner:nil options:nil] lastObject];
    }
    //名称
    cell.treatTime.image = [UIImage imageNamed:[treatParameterItem objectForKey:@"treatTime"]];
    cell.treatStrength.image = [UIImage imageNamed:[treatParameterItem objectForKey:@"treatStrength"]];
    cell.treatWave.image = [UIImage imageNamed:[treatParameterItem objectForKey:@"treatWave"]];
    cell.treatModel.image = [UIImage imageNamed:[treatParameterItem objectForKey:@"treatModel"]];
    
    cell.check.image = [UIImage imageNamed:@"checkNo"];
    cell.treatName.text = [treatParameterItem objectForKey:@"treatName"];
    return cell;
}




- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
