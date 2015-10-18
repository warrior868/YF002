//
//  blePeripheral.h
//  MonitoringCenter
//
//  Created by David ding on 13-1-10.
//
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>

// 透传模块包含服务
extern NSString *kReceiveDataServiceUUID;
extern NSString *kSendDataServiceUUID;

// 指定扫描广播UUID
#define kConnectedServiceUUID                   @"FFF0"

#define kConnectedFinish                        YES
#define kDisconnected                           NO

// 自动发送数据时间周期
#define kAutoSendTestDataTimer                  0.5f

// 数据包长度
#define TRANSMIT_05BYTES_DATA_LENGHT            5
#define TRANSMIT_10BYTES_DATA_LENGHT            10
#define TRANSMIT_15BYTES_DATA_LENGHT            15
#define TRANSMIT_20BYTES_DATA_LENGHT            20

// 消息通知
//==============================================
// 发送消息
#define nPeripheralStateChange                  [[NSNotificationCenter defaultCenter]postNotificationName:@"CBPeripheralStateChange" object:nil];
#define nUpdataShowStringBuffer                 [[NSNotificationCenter defaultCenter]postNotificationName:@"CBUpdataShowStringBuffer" object:nil];

// 接收消息
#define nCBPeripheralStateChange                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CBPeripheralStateChange ) name:@"CBPeripheralStateChange" object:nil];
#define nCBUpdataShowStringBuffer               [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CBUpdataShowStringBuffer ) name:@"CBUpdataShowStringBuffer" object:nil];
//==============================================

/****************************************************************************/
/*                      PeripheralDelegateState的类型                        */
/****************************************************************************/
// Peripheral的消息类型
enum {
    blePeripheralDelegateStateInit = 0,
    blePeripheralDelegateStateDiscoverServices,
    blePeripheralDelegateStateDiscoverCharacteristics,
    blePeripheralDelegateStateKeepActive,
};
typedef NSInteger blePeripheralDelegateState;


@interface blePeripheral : NSObject
//======================================================
// CBPeripheral
@property(strong, nonatomic)    CBPeripheral            *activePeripheral;
//======================================================
// CBService and CBCharacteristic
@property(readonly)             CBService               *ReceiveDataService;
@property(readonly)             CBCharacteristic        *Receive05BytesDataCharateristic;
@property(readonly)             CBCharacteristic        *Receive10BytesDataCharateristic;
@property(readonly)             CBCharacteristic        *Receive15BytesDataCharateristic;
@property(readonly)             CBCharacteristic        *Receive20BytesDataCharateristic;
@property(readonly)             CBService               *SendDataService;
@property(readonly)             CBCharacteristic        *Send05BytesDataCharateristic;
@property(readonly)             CBCharacteristic        *Send10BytesDataCharateristic;
@property(readonly)             CBCharacteristic        *Send15BytesDataCharateristic;
@property(readonly)             CBCharacteristic        *Send20BytesDataCharateristic;
//======================================================
// Property
@property(readonly)             NSUInteger              currentPeripheralState;
@property(readonly)             NSString                *nameString;
@property(readonly)             NSString                *uuidString;
@property(readwrite)            NSString                *staticString;

@property(readonly)             BOOL                    connectedFinish;
@property(nonatomic)            BOOL                    AutoSendData;
@property(readonly)             NSData                  *receiveData;
@property(nonatomic)            NSData                  *sendData;
@property(readwrite)            uint                    txCounter;
@property(readwrite)            uint                    rxCounter;
@property(readwrite)            NSString                *ShowStringBuffer;
//======================================================

// method
-(void)startPeripheral:(CBPeripheral *)peripheral DiscoverServices:(NSArray *)services;
-(void)disconnectPeripheral:(CBPeripheral *)peripheral;
-(void)initPeripheralWithSeviceAndCharacteristic;
-(void)initPropert;
@end
