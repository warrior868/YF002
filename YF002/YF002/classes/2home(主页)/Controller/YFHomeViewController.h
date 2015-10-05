//
//  YFHomeViewController.h
//  YF002
//
//  Created by Mushroom on 5/20/15.
//  Copyright (c) 2015 Mushroom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"

@interface YFHomeViewController : UIViewController <CBCentralManagerDelegate,CBPeripheralDelegate>{
@public
    BabyBluetooth *baby;}

@property __block NSMutableArray *services;
@property(strong,nonatomic)CBPeripheral *currPeripheral;

@end
