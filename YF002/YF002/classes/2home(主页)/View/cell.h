//
//  cell.h
//  testiPadCell
//
//  Created by David ding on 13-1-14.
//  Copyright (c) 2013年 David ding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "blePeripheral.h"

@class blePeripheral;
@interface cell : UITableViewCell
// Property
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *uuidLabel;
@property (strong, nonatomic) IBOutlet UILabel *staticLabel;
@property (strong, nonatomic) IBOutlet UIButton *connectedButton;

@property (nonatomic) blePeripheral *currentPeripheral;
@end
