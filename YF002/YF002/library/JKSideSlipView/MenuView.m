//
//  MenuView.m
//  JKSideSlipView
//
//  Created by Jakey on 15/1/10.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import "MenuView.h"
#import "MenuCell.h"


@implementation MenuView
+(instancetype)menuViewWith:(YFTreatParameterItem *) treatPamameterItem withBlueToothStutas:(BOOL) blueToothStatus
{
   
    
    UIView *result = nil;

    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"MenuView" owner:self options:nil];
//    for (id object in nibView)
//    {
//        if ([object isKindOfClass:[self class]])
//        {
////            result = object;
////            if (blueToothStatus) {
//////                _powerRemain.text =@"-";
////                self.treatTimeLabel;
////                self.treatStrengthLabel;
////                self.treatWaveLabel;
////                self.treatModelLabel;
//            }
//    
//            break;
//        }
    
    return self;
}





@end
