//
//  bleCentralManager.m
//  MonitoringCenter
//
//  Created by David ding on 13-1-10.
//
//

#import "bleCentralManager.h"


@implementation bleCentralManager

#pragma mark -
#pragma mark Init
/******************************************************/
//          类初始化                                   //
/******************************************************/
// 初始化蓝牙
-(id)init{
    self = [super init];
    if (self) {
        _activeCentralManager = [[CBCentralManager alloc] initWithDelegate:(id<CBCentralManagerDelegate>)self queue:dispatch_get_main_queue()];
        [self initProperty];
    }
    return self;
}

-(void)initProperty{
        _blePeripheralArray              = [[NSMutableArray alloc]init];
}

#pragma mark -
#pragma mark Scanning
/****************************************************************************/
/*						   		Scanning                                    */
/****************************************************************************/
// 按UUID进行扫描
-(void)startScanning{
	NSArray *uuidArray = [NSArray arrayWithObjects:[CBUUID UUIDWithString:kConnectedServiceUUID], nil];
    // CBCentralManagerScanOptionAllowDuplicatesKey | CBConnectPeripheralOptionNotifyOnConnectionKey | CBConnectPeripheralOptionNotifyOnDisconnectionKey | CBConnectPeripheralOptionNotifyOnNotificationKey
	NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
	[_activeCentralManager scanForPeripheralsWithServices:uuidArray options:options];
}

// 停止扫描
-(void)stopScanning{
	[_activeCentralManager stopScan];
}

// 扫缪复位
-(void)resetScanning{
    [self stopScanning];
    [self startScanning];
}

#pragma mark -
#pragma mark Connection/Disconnection
/****************************************************************************/
/*						Connection/Disconnection                            */
/****************************************************************************/
// 开始连接
-(void)connectPeripheral:(CBPeripheral*)peripheral
{
	if (!(peripheral.state == CBPeripheralStateConnected)){
        // 连接设备
        [_activeCentralManager connectPeripheral:peripheral options:nil];
	}
    else{
//        // 检测已连接Peripherals
//        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
//        if (version >= 6.0){
//            [_activeCentralManager retrieveConnectedPeripheralsWithServices:<#(NSArray *)#>];
//
//            [_activeCentralManager retrieveConnectedPeripherals];
        }
    }


// 断开连接
-(void)disconnectPeripheral:(CBPeripheral*)peripheral
{
    // 主动断开
    [_activeCentralManager cancelPeripheralConnection:peripheral];
    [self resetScanning];
}

#pragma mark -
#pragma mark CBCentralManager
/****************************************************************************/
/*							CBCentralManager								*/
/****************************************************************************/
// 中心设备状态更新
-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    //activeCentralManager = central;
    if ([_activeCentralManager isEqual:central]) {
        switch ([central state]){
                // 掉电状态
            case CBCentralManagerStatePoweredOff:
            {
                // 更新状态
                _currentCentralManagerState = bleCentralDelegateStateCentralManagerPoweredOff;
                nCentralStateChange
                [self resetScanning];
                NSLog(@"CBCentralManagerStatePoweredOff\n");
                break;
            }
                
                // 未经授权的状态
            case CBCentralManagerStateUnauthorized:
            {
                /* Tell user the app is not allowed. */
                // 更新状态
                _currentCentralManagerState = bleCentralDelegateStateCentralManagerUnauthorized;
                nCentralStateChange
                [self resetScanning];
                NSLog(@"CBCentralManagerStateUnauthorized\n");
                break;
            }
                
                // 未知状态
            case CBCentralManagerStateUnknown:
            {
                /* Bad news, let's wait for another event. */
                // 更新状态
                _currentCentralManagerState = bleCentralDelegateStateCentralManagerUnknown;
                nCentralStateChange
                [self resetScanning];
                NSLog(@"CBCentralManagerStateUnknown\n");
                break;
            }
                
            case CBCentralManagerStateUnsupported:
            {
                // 更新状态
                _currentCentralManagerState = bleCentralDelegateStateCentralManagerUnsupported;
                nCentralStateChange
                [self resetScanning];
                NSLog(@"CBCentralManagerStateUnsupported\n");
                break;
            }
                
                // 上电状态
            case CBCentralManagerStatePoweredOn:
            {
                // 更新状态
                _currentCentralManagerState = bleCentralDelegateStateCentralManagerPoweredOn;
                nCentralStateChange
                [self startScanning];
                NSLog(@"CBCentralManagerStatePoweredOn\n");
                break;
            }
                
                // 重置状态
            case CBCentralManagerStateResetting:
            {
                // 更新状态
                _currentCentralManagerState = bleCentralDelegateStateCentralManagerResetting;
                nCentralStateChange
                [self resetScanning];
                NSLog(@"CBCentralManagerStateResetting\n");
                break;
            }
        }
    }
}
// 中心设备连接检索到的外围设备
-(void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals{
    if ([_activeCentralManager isEqual:central]) {
        for (CBPeripheral *aPeripheral in peripherals){
            [central connectPeripheral:aPeripheral options:nil];
        }
        // 更新状态
        _currentCentralManagerState = bleCentralDelegateStateRetrieveConnectedPeripherals;
        nCentralStateChange
    }
}

// 中心设备扫描外围
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    if ([_activeCentralManager isEqual:central]) {
        BOOL checkout = [self checkPeripheralFromBlePeripheralArray:peripheral];
        if (checkout == NO) {
            // 添加到新的Peripheral
            blePeripheral *bp = [[blePeripheral alloc]init];
            bp.activePeripheral = peripheral;
            [_blePeripheralArray addObject:bp];
        }
        
        // 更新状态
        _currentCentralManagerState = bleCentralDelegateStateDiscoverPeripheral;
        nCentralStateChange
    }
}

// 中心设备连接外围设备
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    if ([_activeCentralManager isEqual:central]) {
        blePeripheral *bp = [self getBlePeripheralFromBlePeripheralArray:peripheral];
        if (bp != nil) {
            bp.activePeripheral = peripheral;
            // 如果当前设备是已连接设备开始扫描服务
            CBUUID	*RecSerUUID     = [CBUUID UUIDWithString:kReceiveDataServiceUUID];
            CBUUID  *SenSerUUID     = [CBUUID UUIDWithString:kSendDataServiceUUID];
            NSArray	*serviceArray	= [NSArray arrayWithObjects:RecSerUUID, SenSerUUID, nil];
            [bp startPeripheral:peripheral DiscoverServices:serviceArray];
        }
        
        // 更新状态
        _currentCentralManagerState = bleCentralDelegateStateConnectPeripheral;
        nCentralStateChange
    }
}

// 中心设备断开连接
-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    if ([_activeCentralManager isEqual:central]) {
    }
    // 更新状态
    NSLog(@"domain:%@\nuserInfo:%@",error.domain, error.userInfo);
    _currentCentralManagerState = bleCentralDelegateStateDisconnectPeripheral;
    
    nCentralStateChange
    
}

/****************************************************************************/
/*							check/get peripheral                            */
/****************************************************************************/
#pragma mark 查询peripheral函数
-(BOOL)checkPeripheralFromBlePeripheralArray:(CBPeripheral *)peripheral{
    BOOL checkout = NO;
    if (_blePeripheralArray.count > 0) {
        for (NSUInteger idx=0; idx<_blePeripheralArray.count; idx++) {
            blePeripheral *bp = [_blePeripheralArray objectAtIndex:idx];
            if ([peripheral isEqual:bp.activePeripheral]) {
                checkout = YES;
                break;
            }
        }
    }
    return checkout;
}

#pragma mark 获取peripheral函数
-(blePeripheral *)getBlePeripheralFromBlePeripheralArray:(CBPeripheral *)peripheral{
    blePeripheral *abp = nil;
    if (_blePeripheralArray.count > 0) {
        for (NSUInteger idx=0; idx<_blePeripheralArray.count; idx++) {
            blePeripheral *bp = [_blePeripheralArray objectAtIndex:idx];
            if ([peripheral isEqual:bp.activePeripheral]) {
                abp = bp;
                break;
            }
        }
    }
    return abp;
}

/****************************************************************************/
/*                                  END                                     */
/****************************************************************************/
@end
