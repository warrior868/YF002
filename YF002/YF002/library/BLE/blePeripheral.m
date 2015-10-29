//
//  blePeripheral.m
//  MonitoringCenter
//
//  Created by David ding on 13-1-10.
//
//

#import "blePeripheral.h"
#import "YFAppDelegate.h"

//================== TransmitMoudel =====================
// TransmitMoudel Receive Data Service UUID
NSString *kReceiveDataServiceUUID                       = @"FFE0";
// TransmitMoudel characteristics UUID
NSString *kReceive05BytesDataCharateristicUUID          = @"FFE1";
NSString *kReceive10BytesDataCharateristicUUID          = @"FFE2";
NSString *kReceive15BytesDataCharateristicUUID          = @"FFE3";
NSString *kReceive20BytesDataCharateristicUUID          = @"FFE4";

// TransmitMoudel Send Data Service UUID
NSString *kSendDataServiceUUID                          = @"FFE5";
// TransmitMoudel characteristics UUID
NSString *kSend05BytesDataCharateristicUUID             = @"FFE6";
NSString *kSend10BytesDataCharateristicUUID             = @"FFE7";
NSString *kSend15BytesDataCharateristicUUID             = @"FFE8";
NSString *kSend20BytesDataCharateristicUUID             = @"FFE9";

@implementation blePeripheral{
    NSTimer         *autoSendDataTimer;
    UInt16          testSendCount;
}


#pragma mark -
#pragma mark Init
/******************************************************/
//          类初始化                                   //
/******************************************************/
// 初始化蓝牙
-(id)init{
    self = [super init];
    if (self) {
        [self initPeripheralWithSeviceAndCharacteristic];
        [self initPropert];
    }
    return self;
}

-(void)setActivePeripheral:(CBPeripheral *)AP{
    _activePeripheral = AP;
    NSString *aname = [[NSString alloc]initWithFormat:@"%@",_activePeripheral.name];
    NSLog(@"aname:%@",aname);
    if (![aname isEqualToString:@"(null)"]) {
        _nameString = aname;
    }
    else{
        _nameString = @"Error Name";
    }
    NSString *auuid = [[NSString alloc]initWithFormat:@"%@", _activePeripheral.identifier];
    if (auuid.length >= 36) {
        _uuidString = [auuid substringWithRange:NSMakeRange(auuid.length-36, 36)];
        NSLog(@"uuidString:%@",_uuidString);
    }
}


-(void)initPeripheralWithSeviceAndCharacteristic{
    // CBPeripheral
    [_activePeripheral setDelegate:nil];
    _activePeripheral = nil;
    // CBService and CBCharacteristic
    _ReceiveDataService = nil;
    _Receive05BytesDataCharateristic = nil;
    _Receive10BytesDataCharateristic = nil;
    _Receive15BytesDataCharateristic = nil;
    _Receive20BytesDataCharateristic = nil;
    _SendDataService = nil;
    _Send05BytesDataCharateristic = nil;
    _Send10BytesDataCharateristic = nil;
    _Send15BytesDataCharateristic = nil;
    _Send20BytesDataCharateristic = nil;
}

-(void)initPropert{
    // Property
    _staticString = @"Init";
    _currentPeripheralState = blePeripheralDelegateStateInit;
    nPeripheralStateChange
    _connectedFinish = kDisconnected;
    _receiveData = 0;
    _sendData = 0;
    _txCounter = 0;
    _rxCounter = 0;
    _ShowStringBuffer = [[NSString alloc]init];
    _AutoSendData = NO;
    
    [autoSendDataTimer invalidate];
    autoSendDataTimer = nil;
    testSendCount = 0;
}

#pragma mark -
#pragma mark Scanning
/****************************************************************************/
/*						   		Scanning                                    */
/****************************************************************************/
// 按UUID进行扫描
-(void)startPeripheral:(CBPeripheral *)peripheral DiscoverServices:(NSArray *)services{
    if ([peripheral isEqual:_activePeripheral] && peripheral.state ==CBPeripheralStateConnected){
        _activePeripheral = peripheral;
        [_activePeripheral setDelegate:(id<CBPeripheralDelegate>)self];
        [_activePeripheral discoverServices:services];
    }
}

-(void)disconnectPeripheral:(CBPeripheral *)peripheral{
    if ([peripheral isEqual:_activePeripheral]){
        // 内存释放
        [self initPeripheralWithSeviceAndCharacteristic];
        [self initPropert];
    }
}

#pragma mark -
#pragma mark CBPeripheral
/****************************************************************************/
/*                              CBPeripheral								*/
/****************************************************************************/
// 扫描服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    if (!error)
    {
        if ([peripheral isEqual:_activePeripheral]){
            // 新建服务数组
            NSArray *services = [peripheral services];
            if (!services || ![services count])
            {
                NSLog(@"发现错误的服务 %@\r\n", peripheral.services);
            }
            else
            {
                // 开始扫描服务
                _staticString = @"Discover services";
                _currentPeripheralState = blePeripheralDelegateStateDiscoverServices;
                nPeripheralStateChange
                for (CBService *services in peripheral.services)
                {
                    NSLog(@"发现服务UUID: %@\r\n", services.UUID);
                    //================== TransmitMoudel =====================// FFE0
                    if ([[services UUID] isEqual:[CBUUID UUIDWithString:kReceiveDataServiceUUID]])
                    {
                        // 扫描接收数据服务特征值
                        _ReceiveDataService = services;
                        [peripheral discoverCharacteristics:nil forService:_ReceiveDataService];
                    }
                    //================== TransmitMoudel =====================// FFE5
                    else if ([[services UUID] isEqual:[CBUUID UUIDWithString:kSendDataServiceUUID]])
                    {
                        // 扫描发送数据服务特征值
                        _SendDataService = services;
                        [peripheral discoverCharacteristics:nil forService:_SendDataService];
                    }
                    //======================== END =========================
                }
            }
        }
    }
}

// 从服务中扫描特征值
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (!error) {
        if ([peripheral isEqual:_activePeripheral]){
            // 开始扫描特征值
            _staticString = @"Discover characteristics";
            _currentPeripheralState = blePeripheralDelegateStateDiscoverCharacteristics;
            nPeripheralStateChange
            // 新建特征值数组
            NSArray *characteristics = [service characteristics];
            CBCharacteristic *characteristic;
            //================== TransmitMoudel =====================// FFE1 FFE2 FFE3 FFE4
            if ([[service UUID] isEqual:[CBUUID UUIDWithString:kReceiveDataServiceUUID]])
            {
                for (characteristic in characteristics)
                {
                    NSLog(@"发现特值UUID: %@\n", [characteristic UUID]);
                    if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:kReceive05BytesDataCharateristicUUID]])
                    {
                        _Receive05BytesDataCharateristic = characteristic;
                        [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                    }
                    else if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:kReceive10BytesDataCharateristicUUID]])
                    {
                        _Receive10BytesDataCharateristic = characteristic;
                        [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                    }
                    else if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:kReceive15BytesDataCharateristicUUID]])
                    {
                        _Receive15BytesDataCharateristic = characteristic;
                        [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                    }
                    else if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:kReceive20BytesDataCharateristicUUID]])
                    {
                        _Receive20BytesDataCharateristic = characteristic;
                        [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                    }
                }
            }
            //================== TransmitMoudel =====================// FFE6 FFE7 FFE8 FFE9
            else if ([[service UUID] isEqual:[CBUUID UUIDWithString:kSendDataServiceUUID]])
            {
                for (characteristic in characteristics)
                {
                    NSLog(@"发现特值UUID: %@\n", [characteristic UUID]);
                    if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:kSend05BytesDataCharateristicUUID]])
                    {
                        _Send05BytesDataCharateristic = characteristic;
                    }
                    else if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:kSend10BytesDataCharateristicUUID]])
                    {
                        _Send10BytesDataCharateristic = characteristic;
                    }
                    else if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:kSend15BytesDataCharateristicUUID]])
                    {
                        _Send15BytesDataCharateristic = characteristic;
                    }
                    else if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:kSend20BytesDataCharateristicUUID]])
                    {
                        _Send20BytesDataCharateristic = characteristic;
                        
                        // 完成连接
                        [self FinishConnected];
                    }
                }
            }
            //======================== END =========================
        }
    }
}

// 更新特征值
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if ([error code] == 0) {
        if ([peripheral isEqual:_activePeripheral]){
            //===================== AntiLost ========================FE21、FE22、FE23、FE24、FE25
            if ([characteristic isEqual:_Receive05BytesDataCharateristic])
            {
                //if (characteristic.value.length == TRANSMIT_05BYTES_DATA_LENGHT) {
                    _receiveData = characteristic.value;
                    [self receiveData:_receiveData];
                //}
            }
            // 接收温湿度数据
            else if ([characteristic isEqual:_Receive10BytesDataCharateristic])
            {
                //if (characteristic.value.length == TRANSMIT_10BYTES_DATA_LENGHT) {
                    _receiveData = characteristic.value;
                    [self receiveData:_receiveData];
                //}
            }
            // 读取名字
            else if ([characteristic isEqual:_Receive15BytesDataCharateristic])
            {
                //if (characteristic.value.length == TRANSMIT_15BYTES_DATA_LENGHT) {
                    _receiveData = characteristic.value;
                    [self receiveData:_receiveData];
                //}
            }
            
            else if ([characteristic isEqual:_Receive20BytesDataCharateristic])
            {
                //if (characteristic.value.length == TRANSMIT_20BYTES_DATA_LENGHT) {
                    _receiveData = characteristic.value;
                    [self receiveData:_receiveData];
                //}
            }
            //======================== END =========================
        }
    }
    else{
        NSLog(@"参数更新出错: %ld",(long)[error code]);
    }
}

#pragma mark -
#pragma mark read/write/notification
/******************************************************/
//          读写通知等基础函数                           //
/******************************************************/
// 写数据到特征值
-(void) writeValue:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic data:(NSData *)data{
    if ([peripheral isEqual:_activePeripheral] && peripheral.state ==CBPeripheralStateConnected)
    {
        if (characteristic != nil) {
            NSLog(@"成功写数据到特征值: %@ 数据:%@\n", characteristic.UUID, data);
            [peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
        }
    }
}

// 从特征值读取数据
-(void) readValue:(CBPeripheral *)peripheral characteristicUUID:(CBCharacteristic *)characteristic{
    if ([peripheral isEqual:_activePeripheral] && peripheral.state ==CBPeripheralStateConnected)
    {
        if (characteristic != nil) {
            NSLog(@"成功从特征值:%@ 读数据\n", characteristic);
            [peripheral readValueForCharacteristic:characteristic];
        }
    }
}

// 发通知到特征值
-(void) notification:(CBPeripheral *)peripheral characteristicUUID:(CBCharacteristic *)characteristic state:(BOOL)state{
    if ([peripheral isEqual:_activePeripheral] && peripheral.state ==CBPeripheralStateConnected)
    {
        if (characteristic != nil) {
            NSLog(@"成功发通知到特征值: %@\n", characteristic);
            [peripheral setNotifyValue:state forCharacteristic:characteristic];
        }
    }
}

#pragma mark -
#pragma mark Set property
/******************************************************/
//              BLE属性操作函数                          //
/******************************************************/
-(void)FinishConnected{
    // 更新标志
    _connectedFinish = YES;
    _staticString = @"Connected finish";
    _currentPeripheralState = blePeripheralDelegateStateKeepActive;
    nPeripheralStateChange
    NSLog(@"连接完成\n");
}

-(void)receiveData:(NSData *)data{
    Byte dataLength = data.length;
    // 接收计数加1
    _rxCounter++;
    
    Byte data2Byte[dataLength];
    [data getBytes:&data2Byte length:dataLength];
    NSString *dataASCII = [[NSString alloc]initWithBytes:data2Byte length:dataLength encoding:NSASCIIStringEncoding];
    [self addReceiveASCIIStringToShowStringBuffer:dataASCII];
    _staticString = [[NSString alloc]initWithFormat:@"Receive:%@",dataASCII];
    nUpdataShowStringBuffer
}

-(void)addReceiveASCIIStringToShowStringBuffer:(NSString *)aString{
    // 在接到的数据前面叠加"PC:"后面加入换行后添加到显示缓存
    NSString *rxASCII = [[NSString alloc]initWithFormat:@"        PC:"];
    rxASCII = [rxASCII stringByAppendingString:aString];
    rxASCII = [rxASCII stringByAppendingString:@"\n"];
    _ShowStringBuffer = [_ShowStringBuffer stringByAppendingString:rxASCII];
}

-(void)setSendData:(NSData *)data{
    Byte dataLength = data.length;
    
    if ((dataLength == TRANSMIT_05BYTES_DATA_LENGHT) || (dataLength == TRANSMIT_10BYTES_DATA_LENGHT) || (dataLength == TRANSMIT_15BYTES_DATA_LENGHT) || (dataLength == TRANSMIT_20BYTES_DATA_LENGHT)) {
        // 发送计数加1
        _txCounter++;
        
        Byte data2Byte[dataLength];
        [data getBytes:&data2Byte length:dataLength];
        NSString *dataASCII = [[NSString alloc]initWithBytes:data2Byte length:dataLength encoding:NSASCIIStringEncoding];
        if (dataLength == TRANSMIT_05BYTES_DATA_LENGHT)
        {
            [self writeValue:_activePeripheral characteristic:_Send05BytesDataCharateristic data:data];
        }
        else if (dataLength == TRANSMIT_10BYTES_DATA_LENGHT)
        {
            [self writeValue:_activePeripheral characteristic:_Send10BytesDataCharateristic data:data];
        }
        else if (dataLength == TRANSMIT_15BYTES_DATA_LENGHT)
        {
            [self writeValue:_activePeripheral characteristic:_Send15BytesDataCharateristic data:data];
        }
        else if (dataLength == TRANSMIT_20BYTES_DATA_LENGHT)
        {
            [self writeValue:_activePeripheral characteristic:_Send20BytesDataCharateristic data:data];
        }
        [self addSendASCIIStringToShowStringBuffer:dataASCII];
        _staticString = [[NSString alloc]initWithFormat:@"已经向蓝牙发送了:%@",dataASCII];
        NSLog(@"已经向蓝牙发送了:%@",_staticString);
        nUpdataShowStringBuffer
    }
}

-(void)addSendASCIIStringToShowStringBuffer:(NSString *)aString{
    // 在发送的数据前面叠加"IP:"后面加入换行后添加到显示缓存
    NSString *txASCII = [[NSString alloc]initWithFormat:@"IP:"];
    txASCII = [txASCII stringByAppendingString:aString];
    txASCII = [txASCII stringByAppendingString:@"\n"];
    _ShowStringBuffer = [_ShowStringBuffer stringByAppendingString:txASCII];
}

-(void)setAutoSendData:(BOOL)AutoSendData{
    if (AutoSendData == YES) {
        // 自动发送测试数据
        if (autoSendDataTimer != nil) {
            [autoSendDataTimer invalidate];
        }
        autoSendDataTimer = [NSTimer scheduledTimerWithTimeInterval:kAutoSendTestDataTimer target:self selector:@selector(AutoSendDataEvent) userInfo:nil repeats:YES];
    }
    else{
        [autoSendDataTimer invalidate];
        autoSendDataTimer = nil;
        testSendCount = 0;
    }
}

-(void)AutoSendDataEvent{
    // 发送数据自动加1
    if (_activePeripheral.state ==CBPeripheralStateConnected) {
        testSendCount++;
        NSString *txAccString = [[NSString alloc]initWithFormat:@"%05d", testSendCount];
        NSString *test20ByteASCII = [[NSString alloc]initWithFormat:@"ABCDEFGHIJKLMNO"];
        test20ByteASCII = [test20ByteASCII stringByAppendingString:txAccString];
        [self setSendData:[test20ByteASCII dataUsingEncoding:NSASCIIStringEncoding]];
    }
    else{
        [autoSendDataTimer invalidate];
        autoSendDataTimer = nil;
        testSendCount = 0;
        
        _connectedFinish = kDisconnected;
        _AutoSendData = NO;
        
        _staticString = @"Disconnect";
        _currentPeripheralState = blePeripheralDelegateStateInit;
        nPeripheralStateChange
    }
}

@end
