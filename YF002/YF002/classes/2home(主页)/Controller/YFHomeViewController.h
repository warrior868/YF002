//
//  YFHomeViewController.h
//  YF002
//
//  Created by Mushroom on 5/20/15.
//  Copyright (c) 2015 Mushroom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "YFAppDelegate.h"
#import "blePeripheral.h"

@interface YFHomeViewController : UIViewController {
    YFAppDelegate    *blead;

}

@property (nonatomic) blePeripheral *currentPeripheral;
@property (strong, nonatomic)  UITableView *blePeripheralTableView;

- (void)SendInputButton:(UIButton *)sender;

@end
