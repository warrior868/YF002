//
//  JKSideSlipView.h
//  JKSideSlipView
//
//  Created by Jakey on 15/1/10.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YFTreatParameterItem.h"

@interface JKSideSlipView : UIView
{
    BOOL isOpen;
    UITapGestureRecognizer *_tap;
    UISwipeGestureRecognizer *_leftSwipe, *_rightSwipe;
    UIImageView *_blurImageView;
    UIViewController *_sender;
    UIView *_contentView;
}

@property (weak, nonatomic) IBOutlet UILabel *isBlueToothConnect;
@property (weak, nonatomic) IBOutlet UILabel *powerRemain;
@property (weak, nonatomic) IBOutlet UILabel *treatTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *treatStrengthLabel;
@property (weak, nonatomic) IBOutlet UILabel *treatWaveLabel;
@property (weak, nonatomic) IBOutlet UILabel *treatModelLabel;
@property (weak, nonatomic) IBOutlet UIView *aView;


- (instancetype)initWithSender:(UIViewController *)sender;

- (void)reloadTreatItem:(YFTreatParameterItem *)treatParameterItem
    withBlueToothStatus:(BOOL)blueToothStatus
        withPowerStatus:(NSInteger)powerStatus;
-(instancetype)initWithName:(YFTreatParameterItem *)treatParameterItem withBlueToothStatus:(BOOL)blueToothStatus
            withPowerStatus:(NSInteger)powerStatus;

- (instancetype)initWithSender:(UIViewController*)sender;
-(void)show;
-(void)hide;
-(void)switchMenu;
-(id)initWithCoder:(NSCoder *)aDecoder;
//-(void)setContentView:(UIView*)contentView;

@end
