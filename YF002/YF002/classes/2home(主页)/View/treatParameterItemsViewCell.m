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
@property (weak, nonatomic) IBOutlet UILabel *treatName;




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
    cell.treatTime.text = [treatParameterItem objectForKey:@"treatTime"];
    cell.treatStrength.text = [treatParameterItem objectForKey:@"treatStrength"];
    cell.treatWave.text = [treatParameterItem objectForKey:@"treatWave"];
    cell.treatModel.text = [treatParameterItem objectForKey:@"treatModel"];
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
