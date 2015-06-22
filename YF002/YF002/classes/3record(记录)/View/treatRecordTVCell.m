//
//  treatRecordTVCell.m
//  YF002
//
//  Created by Mushroom on 5/31/15.
//  Copyright (c) 2015 Mushroom. All rights reserved.
//

#import "treatRecordTVCell.h"

@implementation treatRecordTVCell


+ (instancetype)cellWithTableView:(UITableView *)tableView withTreatItem:(NSDictionary *)treatParameterItem
{
    static NSString *ID = @"treatItem";
    treatRecordTVCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"treatRecordTVCell"  owner:nil options:nil] lastObject];
    }
    //从字典中读取各个参数
    
    cell.treatTime.image = [UIImage imageNamed:[treatParameterItem objectForKey:@"treatTime"]];
    cell.treatStrength.image = [UIImage imageNamed:[treatParameterItem objectForKey:@"treatStrength"]];
    cell.treatWave.image = [UIImage imageNamed:[treatParameterItem objectForKey:@"treatWave"]];
    cell.treatModel.image = [UIImage imageNamed:[treatParameterItem objectForKey:@"treatModel"]];
    
    
    NSString *string1 = [treatParameterItem objectForKey:@"treatDate"];
    NSString *year = [string1 substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [string1 substringWithRange:NSMakeRange(4, 2)];
    NSString *day = [string1 substringWithRange:NSMakeRange(6, 2)];
    NSString *hour = [string1 substringWithRange:NSMakeRange(8, 2)];
    NSString *min = [string1 substringWithRange:NSMakeRange(10, 2)];
    cell.treatDate.text = [NSString stringWithFormat:@"%@年%@月%@日 %@时%@分",year,month,day,hour,min];
    
    cell.treatDrug.text = [treatParameterItem objectForKey:@"treatDrug"];
    
    
    if ([[treatParameterItem objectForKey:@"treatDrug"] isEqualToString:@"0"]) {
     //如果字典中drug的参数为0，则设置药物和数量设置如下
        cell.treatDrug.text = @"-";
        cell.treatDrugQuantity.text = @"-";
    }else
    {
    //如果字典中drug的参数不为0，则设置药物和数量设置如下
        cell.treatDrug.text = [treatParameterItem objectForKey:@"treatDrug"];
        cell.treatDrugQuantity.text = [treatParameterItem objectForKey:@"treatDrugQuantity"];
    
    }
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
