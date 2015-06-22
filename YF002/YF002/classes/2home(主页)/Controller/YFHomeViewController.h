//
//  YFHomeViewController.h
//  YF002
//
//  Created by Mushroom on 5/20/15.
//  Copyright (c) 2015 Mushroom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface YFHomeViewController : UIViewController <CBCentralManagerDelegate,CBPeripheralDelegate>

//蓝牙连接参数
@property BOOL cbReady;
@property BOOL isRefreshing;
@property(nonatomic) float batteryValue;
@property (nonatomic, strong) CBCentralManager *manager;
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (strong ,nonatomic) CBCharacteristic *writeCharacteristic;

@property (strong,nonatomic) NSMutableArray *nDevices;
@property (strong,nonatomic) NSMutableArray *nServices;
@property (strong,nonatomic) NSMutableArray *nCharacteristics;
@end
