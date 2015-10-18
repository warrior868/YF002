//
//  iPadCell.m
//  testiPadCell
//
//  Created by David ding on 13-1-14.
//  Copyright (c) 2013年 David ding. All rights reserved.
//

#import "cell.h"
#import "YFAppDelegate.h"

@implementation cell{
    YFAppDelegate    *blead;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCurrentPeripheral:(blePeripheral *)currentPeripheral{
    // 更新单元显示
    _currentPeripheral = currentPeripheral;
    _nameLabel.text = currentPeripheral.nameString;
    _uuidLabel.text = [[NSString alloc]initWithFormat:@"UUID:%@",currentPeripheral.uuidString];
    _staticLabel.text = [[NSString alloc]initWithFormat:@"STATIC:%@",currentPeripheral.staticString];
    // 连接成功后，显示跳转子页面标识
    if (_currentPeripheral.connectedFinish == YES) {
        _connectedButton.hidden = NO;
    }
    else{
        _connectedButton.hidden = YES;
    }
}

@end
