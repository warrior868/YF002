//
//  YFHomeViewController.m
//  YF002
//
//  Created by Mushroom on 5/20/15.
//  Copyright (c) 2015 Mushroom. All rights reserved.
//

#import "YFHomeViewController.h"
#import "YFTreatParameterItem.h"
#import "YFPamameterItemTableViewController.h"
#import "YFRecordTVC.h"
#import "YFChooseParameterVC.h"

#import "AKPickerView.h"

#import "MZTimerLabel.h"

#import "JKSideSlipView.h"
#import "MenuView.h"
#import "MenuCell.h"

#import "LMComBoxView.h"
#import "LMContainsLMComboxScrollView.h"

#import "STAlertView.h"

#import "MMMaterialDesignSpinner.h"
#import "Masonry.h"


#import "SVProgressHUD.h"
#import "PeripheralInfo.h"
//背景模糊



#define width [UIScreen mainScreen].bounds.size.width
#define height [UIScreen mainScreen].bounds.size.height
#define channelOnPeropheralView @"peripheralView"
#define kDropDownListTag 1000

@interface YFHomeViewController () <AKPickerViewDataSource,AKPickerViewDelegate,MZTimerLabelDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDelegate>{
    MZTimerLabel *_timer;
    JKSideSlipView *_sideSlipView;
    LMContainsLMComboxScrollView *bgScrollView;
   
    NSMutableDictionary *addressDict;   //地址选择字典
    NSDictionary *areaDic;
    NSArray *province;
    NSArray *city;
    NSArray *district;
    
    NSString *selectedProvince;
    NSString *selectedCity;
    NSString *selectedArea;
    
    //蓝牙连接参数
    NSMutableArray *peripherals;
    NSInteger batteryValue;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//保存时弹出窗口的属性
@property (nonatomic, strong) STAlertView *stAlertView;

//在YFPamameterItemTableViewController 数组中选择第几个治疗参数
@property (assign,nonatomic) NSInteger  treatItemNumber;

//左侧滑动窗口实例属性
@property (nonatomic ,strong) MenuView   *menu;


//计时动画圈圈属性
@property (nonatomic ,strong) MMMaterialDesignSpinner *spinnerView;

//pickView的属性
@property (nonatomic, strong) AKPickerView *treatTimePickerView;
@property (nonatomic, strong) AKPickerView *treatStrengthPickerView;
@property (nonatomic, strong) AKPickerView *treatWavePickerView;
//倒计时所在的层视图
@property (weak, nonatomic) IBOutlet UIView *timeCountLayer;

@property (nonatomic, strong) NSArray *treatTimePickerViewArray;
@property (nonatomic, strong) NSArray *treatStrengthPickerViewArray;
@property (nonatomic, strong) NSArray *treatWavePickerViewArray;

@property (nonatomic, strong) YFTreatParameterItem *treatParameterItem;
@property (nonatomic, copy) NSString *treatDrug;
@property (nonatomic, copy) NSString *treatDrugQuantity;


@property (weak, nonatomic) IBOutlet UITableView *bluetoothTableview;


//设置倒计时 时间 按钮
@property (weak, nonatomic) IBOutlet UILabel  *timerCountDownLabel;
@property (weak, nonatomic) IBOutlet UIButton *startPauseBtn;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
- (IBAction)startOrResumeCountDown:(id)sender;
- (IBAction)resetCountDown:(id)sender;

//开启编辑参数按钮
@property (weak, nonatomic) IBOutlet UIButton *editParameter;
- (IBAction)editParameter:(id)sender;
@property (nonatomic,strong) UIView *coverView;





@end

@implementation YFHomeViewController
#pragma mark - 初始化的内容
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:187.0/255 green:135.0/255 blue:87.0/135 alpha:0.8]}];
// 0.滚动的scrollView
    self.scrollView.frame = CGRectMake(0, 0, 320, 560);
    [self.scrollView setContentSize:CGSizeMake(320, 600)];
    
    
   
//  1.初始化治疗参数
    _treatParameterItem = [[YFTreatParameterItem alloc] initWithIndex:1];
     NSLog(@"%@", _treatParameterItem.datafromTreatItem);

//   2.创建 pickerView 第一个时间选择pickview X轴xPickerView,y轴yPickerView,y轴增加值xAddPickerView
    NSInteger xPickerView = 80,yPickerView =10,yAddPickerView = 40;
    [self treatTimePickerViewLoad:CGRectMake(xPickerView, yPickerView, 240, 30)];
    [self treatStrengthPickerViewLoad:CGRectMake(xPickerView,(yPickerView+yAddPickerView) , 240, 30)];
    [self treatWavePickerViewLoad:CGRectMake(xPickerView, (yPickerView+2*yAddPickerView), 240, 30)];
    //[self treatModelPickerViewLoad:CGRectMake(xPickerView,(yPickerView+3*yAddPickerView), 200, 60)];
     //   初始化载入每个pickerView选中的行
    [_treatTimePickerView selectItem:[[_treatParameterItem.treatTime substringWithRange:NSMakeRange(0, 1)] integerValue] animated:NO];
    [_treatStrengthPickerView selectItem:[[_treatParameterItem.treatStrength substringWithRange:NSMakeRange(0, 1)] integerValue] animated:NO];
    [_treatWavePickerView selectItem:[[_treatParameterItem.treatWave substringWithRange:NSMakeRange(0, 1)] integerValue] animated:NO];
    //[_treatModelPickerView selectItem:[[_treatParameterItem.treatModel substringWithRange:NSMakeRange(1, 1)] integerValue] animated:NO];

// 3.开启编辑参数按钮 圆角实现
    [_editParameter.layer setMasksToBounds:YES];
    [_editParameter.layer setCornerRadius:5];

//  设置navigationBar 左侧栏的名称以及按键调用的方法
  //  UIImage *leftBarButtonItem = [UIImage imageNamed:@"blueToothGray" ];
  //  self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithImage:leftBarButtonItem landscapeImagePhone:nil style:UIBarButtonItemStyleBordered target:self action:@selector(switchTouched)];
  //  [self.navigationItem.leftBarButtonItem setImage:[leftBarButtonItem imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    
//  4.创建 MZTimerLabel倒计时  按钮
    _timer = [[MZTimerLabel alloc] initWithLabel:_timerCountDownLabel andTimerType:MZTimerLabelTypeTimer];
    // 4.1读出初始化时间,字符串转数值
    NSTimeInterval initTime = (NSTimeInterval )[[_treatParameterItem.treatTime substringWithRange:NSMakeRange(0, 1)] integerValue];
    // 4.2设置初始化时间
    if (initTime == 0) {
        [_timer setCountDownTime:60];
    }else{
        [_timer setCountDownTime:initTime*5*60];}
    // 4.3关闭时间设置中的重置按钮
    [_resetBtn setEnabled:NO];
    _timer.resetTimerAfterFinish = YES;
    _timer.delegate = self;
    _timer.timeFormat = @"mm:ss";


    //  4.4创建倒计时的圈圈动画
    MMMaterialDesignSpinner *spinnerView = [[MMMaterialDesignSpinner alloc] initWithFrame:CGRectZero];
    self.spinnerView = spinnerView;
    self.spinnerView.bounds = CGRectMake(0, 0, 210, 210);
    self.spinnerView.lineWidth = 3.6f;
    self.spinnerView.tintColor = [UIColor colorWithRed:194.f/255 green:53.f/255 blue:127.f/255 alpha:0.3];
    self.spinnerView.center = CGPointMake(CGRectGetMidX(self.view.bounds)-2, 128);
    
    [self.timeCountLayer insertSubview:self.spinnerView atIndex:2];
 

    
// 6.创建 蓝牙
    //初始化
    //[SVProgressHUD showInfoWithStatus:@"准备打开设备"];
    
    //初始化其他数据 init other
    peripherals = [[NSMutableArray alloc]init];
    
    //初始化BabyBluetooth 蓝牙库
    baby = [BabyBluetooth shareBabyBluetooth];
    //设置蓝牙委托
    [self babyDelegate];
   // baby.scanForPeripherals().begin();
    //1：设置连接的设备的过滤器
    __block BOOL isFirst = YES;
    [baby setFilterOnConnetToPeripherals:^BOOL(NSString *peripheralName) {
        //这里的规则是：连接第一个AAA打头的设备
        if(isFirst && [peripheralName hasPrefix:@"Sim"]){
            isFirst = NO;
            return YES;
        }
        return NO;
    }];
    
    //2 扫描、连接
    baby.scanForPeripherals().connectToPeripherals().begin();
    NSLog(@"搜索完成");
  // 7.push链接
    [self performSegueWithIdentifier:@"forChoose" sender:self];
    
    //0.1编辑参数按钮所在的coverView；
    _coverView.frame =CGRectMake(0, 0, width, 160);
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.alpha =0.5;
    [_scrollView addSubview:_coverView];
}


-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"viewDidAppear");
       self.navigationController.navigationBarHidden = NO;
    //停止之前的连接
    //[baby cancelAllPeripheralsConnection];
    //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
    
//baby.scanForPeripherals().begin().stop(10);
    //baby.having(self.currPeripheral).connectToPeripherals().begin();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - YFPamameterItemTableViewController Delegate
- (void)sendSelectedItemToHomeVC:(NSInteger) rowForNewTreatItem{
    // 选中的列表第几个值后，重新赋值给_defaultTreatItem;
    self.treatItemNumber = rowForNewTreatItem;
    
    NSDictionary *newTreatItem = _treatParameterItem.datafromTreatItem[rowForNewTreatItem];
    _treatParameterItem.treatTime = [newTreatItem objectForKey:@"treatTime"];
    _treatParameterItem.treatStrength = [newTreatItem objectForKey:@"treatStrength"];
    _treatParameterItem.treatWave = [newTreatItem objectForKey:@"treatWave"];
    _treatParameterItem.treatModel = [newTreatItem objectForKey:@"treatModel"];
    ;
    // 重新对每个pickerView进行重选;
    [_treatTimePickerView selectItem:[[_treatParameterItem.treatTime substringWithRange:NSMakeRange(1, 1)] integerValue] animated:NO];
    [_treatStrengthPickerView selectItem:[[_treatParameterItem.treatStrength substringWithRange:NSMakeRange(1, 1)] integerValue] animated:NO];
    [_treatWavePickerView selectItem:[[_treatParameterItem.treatWave substringWithRange:NSMakeRange(1, 1)] integerValue] animated:NO];
   // [_treatModelPickerView selectItem:[[_treatParameterItem.treatModel substringWithRange:NSMakeRange(1, 1)] integerValue] animated:NO];
    
}

#pragma mark -YFPamameterTableViewController Delegate (Get Array)
- (NSArray *)getArrayHomeVC{
    
    return _treatParameterItem.datafromTreatItem;
}
- (NSInteger )getRowFromHomeVC{
    return _treatItemNumber;
}
*/


#pragma mark  跳转链接segue
-(IBAction)unwind:(UIStoryboardSegue *) segue{
    
}


#pragma mark - AKPickerView DataSource
- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView{

    if([pickerView isEqual:_treatTimePickerView])
    {
        return [_treatTimePickerViewArray count];
    }
    
    else if([pickerView isEqual:_treatStrengthPickerView])
    {
        return [_treatStrengthPickerViewArray count];
    }
    else ([pickerView isEqual:_treatWavePickerView]);
    {
        return [_treatWavePickerViewArray count];
    }
    
}

#pragma mark - AKPickerViewDataSource 选择器初始化
- (void)treatTimePickerViewLoad:(CGRect )pickerViewCGRect{
    if (_treatTimePickerView == nil) {
        _treatTimePickerView = [[AKPickerView alloc] initWithFrame:pickerViewCGRect];
    }
    //初始化治疗时间pickerView
    [self pickerViewParameterLoad:_treatTimePickerView];
    //取出数据模型中关于treatTime的plist中数组 治疗时间
    _treatTimePickerViewArray = [_treatParameterItem.datafromTreatItemList objectForKey:@"treatTime"];
    [_treatTimePickerView reloadData];
}
- (void)treatStrengthPickerViewLoad:(CGRect )pickerViewCGRect{
    _treatStrengthPickerView = [[AKPickerView alloc] initWithFrame:pickerViewCGRect];
    
    [self pickerViewParameterLoad:_treatStrengthPickerView];
    //取出数据模型中关于treatStrength的plist中数组
    _treatStrengthPickerViewArray =[_treatParameterItem.datafromTreatItemList objectForKey:@"treatStrength"];
    [_treatStrengthPickerView reloadData];
}
- (void)treatWavePickerViewLoad:(CGRect )pickerViewCGRect{
    _treatWavePickerView = [[AKPickerView alloc] initWithFrame:pickerViewCGRect];
    //self.view.bounds
    [self pickerViewParameterLoad:_treatWavePickerView];
    //取出数据模型中关于treatWave的plist中数组
    _treatWavePickerViewArray = [_treatParameterItem.datafromTreatItemList objectForKey:@"treatWave"];
    [_treatWavePickerView reloadData];
}


- (void)pickerViewParameterLoad:(AKPickerView *)pickerView{
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.scrollView addSubview:pickerView];
    
    pickerView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    pickerView.textColor = [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:0.8];
    pickerView.highlightedFont = [UIFont fontWithName:@"HelveticaNeue" size:18];
    pickerView.highlightedTextColor = [UIColor colorWithRed:100.0/255 green:100.0/255 blue:100.0/255 alpha:1.0];
    pickerView.interitemSpacing = 13;
    //pickerView.fisheyeFactor = 0.001;
    pickerView.pickerViewStyle = AKPickerViewStyle3D;
    pickerView.maskDisabled = false;
}

#pragma mark - AFPickerView 返回字体显示

- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item
{
    if([pickerView isEqual:_treatTimePickerView])
    {
        return _treatTimePickerViewArray[item];
    }
    
    else if([pickerView isEqual:_treatStrengthPickerView])
    {
        return _treatStrengthPickerViewArray[item];
    }
    
    else ([pickerView isEqual:_treatWavePickerView]);
    {
        return _treatWavePickerViewArray[item];
    }
}

#pragma mark - AFPickerView 选择的项目
- (NSUInteger)nnumberOfItemsInPickerView:(AKPickerView *)pickerView{
    if([pickerView isEqual:_treatTimePickerView])
    {
        
        NSString *treatTime = _treatParameterItem.treatTime ;
        NSString *treatTimeNumber = [treatTime substringWithRange:NSMakeRange(0, 1)];
        return [treatTimeNumber integerValue];
    }
    else if([pickerView isEqual:_treatStrengthPickerView])
    {
        NSString *treatStrength = _treatParameterItem.treatStrength ;
        NSString *treatStrengthNumber = [treatStrength substringWithRange:NSMakeRange(0, 1)];
        return [treatStrengthNumber integerValue];
    }
    else if([pickerView isEqual:_treatWavePickerView])
    {
        NSString *treatWave = _treatParameterItem.treatWave ;
        NSString *treatWaveNumber = [treatWave substringWithRange:NSMakeRange(0, 1)];
        return [treatWaveNumber integerValue];
    }
    else{
    NSString *treatModel = _treatParameterItem.treatModel;
    NSString *treatModelNumber = [treatModel substringWithRange:NSMakeRange(0, 1)];
        return [treatModelNumber integerValue];
    }
}

//用pickerView 选出的treatItem 参数
- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item{
    
        if([pickerView isEqual:_treatTimePickerView])
        {
            //读取数组中的值设置时间
            NSString *treatTimeSelect =_treatTimePickerViewArray[item];
            //字符串转化后面的序号
            NSString *treatTimeSelectNumber = [treatTimeSelect substringWithRange:NSMakeRange(0, 1)];
            //字符串转化成整数
            NSInteger  setTime = [treatTimeSelectNumber integerValue];
            //设置计时时间
            if (setTime == 0) {
                [_timer setCountDownTime:1*5];
            }else{
                [_timer setCountDownTime:setTime*1*5];}
            //设置模型中treatTime的值，以便保存；
            _treatParameterItem.treatTime = treatTimeSelect;
            NSLog(@"Time_%@", _treatParameterItem.treatTime);
        }
        
        else if([pickerView isEqual:_treatStrengthPickerView])
        {
            //读取数组中的值设置时间，设置模型中treatStrength的值，以便保存
            _treatParameterItem.treatStrength = _treatStrengthPickerViewArray[item];
            
        }
        else ([pickerView isEqual:_treatWavePickerView]);
        {
           //读取数组中的值设置时间，设置模型中treatWave的值，以便保存
            _treatParameterItem.treatWave = _treatWavePickerViewArray[item];
        }
        
}

#pragma mark - 保存参数按钮

    /*- (IBAction)saveTreatPamameterItem:(id)sender{
//    带输入的alertView，并保存的参数形成字典加入到治疗参数列表中
    self.stAlertView = [[STAlertView alloc] initWithTitle:@"提示"
                                                  message:@"请输入你要存储的名称"
                                            textFieldHint:@"请输入你要存储的名称"
                                           textFieldValue:nil
                                        cancelButtonTitle:@"取消"
                                         otherButtonTitle:@"确定"
                                        cancelButtonBlock:^{
                                            NSLog(@"取消了存储");
                                        } otherButtonBlock:^(NSString * result){                                            [self saveTreatItemToListWithName:result];
                                            
                                        }];
    
    //You can make any customization to the native UIAlertView
    self.stAlertView.alertView.alertViewStyle =UIAlertViewStylePlainTextInput;
    [[self.stAlertView.alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    
    [self.stAlertView show];
    
}
     */
//    保存的参数形成字典加入到治疗参数列表中，并存储到plist中
- (void) saveTreatItemToListWithName:(NSString *)name{
    //读取当前日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmm"];
    NSString *date =  [formatter stringFromDate:[NSDate date]];
    
    if (name == nil) {

    }
    else{
        NSDictionary *newDic = @{@"treatName":name,
                                 @"treatDate":date,
                                 @"treatTime":_treatParameterItem.treatTime,
                                 @"treatStrength":_treatParameterItem.treatStrength,
                                 @"treatWave":_treatParameterItem.treatWave,
                                 @"treatModel":_treatParameterItem.treatModel,
                                 };
        [_treatParameterItem.datafromTreatItem addObject:newDic ];
        //读取路径
        NSString *plistPath1;
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        plistPath1 = [rootPath stringByAppendingPathComponent:@"treatItem.plist"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath1] == NO) {
            NSFileManager *fm = [NSFileManager defaultManager];
            [fm createFileAtPath:plistPath1 contents:nil attributes:nil];
        }
        
        //把数组加入到文件中
        [_treatParameterItem.datafromTreatItem writeToFile:plistPath1 atomically:YES];
        
        //读出保存的文件看看
        //        NSString *plistPath2 = [[NSBundle mainBundle] pathForResource:@"treatItem" ofType:@"plist"];
        NSMutableArray *applist1 = [[NSMutableArray alloc] initWithContentsOfFile:plistPath1];
         NSLog(@"applist1  %@", applist1);
        //NSLog(@" 输入的事 %@", newDic);
    };
    
}

#pragma mark - MZTimerlabel 开始 暂停 重置按钮的方法
- (IBAction)startOrResumeCountDown:(id)sender {
    
    if([_timer counting]){
        [_timer pause];
        
        [_startPauseBtn setTitle:@"继续" forState:UIControlStateNormal];
        
        [_resetBtn setEnabled:YES];
        
        //圆圈动画结束
        [self.spinnerView stopAnimating];
        
    }else{
        
        [_timer start];
        //圆圈动画开始
        [self.spinnerView startAnimating];
        [_startPauseBtn setTitle:@"暂停" forState:UIControlStateNormal];
        
    }
    
}
- (IBAction)resetCountDown:(id)sender {
    [_timer reset];
    
    if(![_timer counting]){
        [_startPauseBtn setTitle:@"开始" forState:UIControlStateNormal];
    }
     [_resetBtn setEnabled:NO];
}
- (void)timerLabel:(MZTimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    //圆圈动画结束
    [self.spinnerView stopAnimating];
    //设置结束后，按钮设置成开始；
    [_startPauseBtn setTitle:@"开始" forState:UIControlStateNormal];
    //设置结束后，保存参数按钮设置为开启
    
    //提示用户完成治疗
    [self performSegueWithIdentifier:@"showDone" sender:self];
    //1.把治疗结果记录在history中

    //1.1读取当前日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmm"];
    NSString *date =  [formatter stringFromDate:[NSDate date]];
    NSLog(@"date is %@",date);
    //1.2把使用记录添加到记录列表里面
    NSString *treatDrug ;
    if (_treatDrug == nil) {
        treatDrug = @"无";
    }else{
        treatDrug = _treatDrug;
    }
    NSString *treatDrugQuantity ;
    if (_treatDrug == nil) {
        treatDrugQuantity = @"无";
    }else{
        treatDrugQuantity = _treatDrugQuantity;
    }
    NSDictionary *newHistoryDic = @{@"treatDate":date,
                                    @"treatTime":_treatParameterItem.treatTime,
                                    @"treatStrength":_treatParameterItem.treatStrength,
                                    @"treatWave":_treatParameterItem.treatWave,
                                    @"treatModel":_treatParameterItem.treatModel,
                                    @"treatDrug":treatDrug,
                                    @"treatDrugQuantity":treatDrugQuantity};
    //读取治疗记录文件
    NSString *plistPath1;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    plistPath1 = [rootPath stringByAppendingPathComponent:@"treatHistory.plist"];
    //判断是否存在记录的文件，没有的话建文件
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath1] ) {
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm createFileAtPath:plistPath1 contents:nil attributes:nil];
    }
    
    //把newDic字典加入到数组中
    [_treatParameterItem.datafromTreatHistory addObject:newHistoryDic];
    //把数组加入到文件中
    [_treatParameterItem.datafromTreatHistory writeToFile:plistPath1 atomically:YES];
    NSLog(@"%@",_treatParameterItem.datafromTreatHistory);
}

#pragma mark - sideView 按钮方法
- (void)switchTouched{
    [_sideSlipView switchMenu];
    
    [self loadSideViewData];
    //蓝牙进行扫描
  //  [self scanClick];
    [_menu.myTableView reloadData];

    
}
- (void) loadSideViewData{
    
    if (1) {
        batteryValue = 70;
        _menu.items =
        @[
          @{@"title":@"蓝牙已连接",@"imagename":@"70%",@"data":@"70% "},
          @{@"title":[NSString stringWithFormat:@"电池电量%d%%", batteryValue],@"imagename":@"70%",@"data":@"70%"},
          @{@"title":@"时间",@"imagename":_treatParameterItem.treatTime,
            @"data":[NSString stringWithFormat:@"%@",_treatParameterItem.treatTime]},
          @{@"title":@"强度",@"imagename":_treatParameterItem.treatStrength,
            @"data":[NSString stringWithFormat:@"%@",_treatParameterItem.treatStrength]},
          @{@"title":@"波形",@"imagename":_treatParameterItem.treatWave,
            @"data":[NSString stringWithFormat:@"%@",_treatParameterItem.treatWave]},
          @{@"title":@"电极",@"imagename":_treatParameterItem.treatModel,
            @"data":[NSString stringWithFormat:@"%@",_treatParameterItem.treatModel]}
          ];

    } else{
        
    }
    }


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - BabyBluetooth 蓝牙部分

//蓝牙网关初始化和委托方法设置
-(void)babyDelegate{
    
    __weak typeof(self) weakSelf = self;
    [baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
            [SVProgressHUD showInfoWithStatus:@"设备打开成功，开始扫描设备"];
        }
    }];
    
    //设置扫描到设备的委托
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"搜索到了设备:%@",peripheral.name);
//        if ([peripheral.name isEqual:@"SimpleBLEPeripheral"]) {
//            self.services = [[NSMutableArray alloc]init];
//            [self babyOneDelegate];
//            
//            //开始扫描设备
//            [self performSelector:@selector(loadData) withObject:nil afterDelay:2];
//            [SVProgressHUD showInfoWithStatus:@"准备连接设备"];

 //       }
    }];
    //设置设备连接成功的委托
    [baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        NSLog(@"设备：%@--连接成功 ViewController",peripheral.name);
        //3 获取设备的services、characteristic、description以及value
        
        //停止扫描
        [baby cancelScan];
        //初始化
        _currPeripheral = peripheral;
        _services = [[NSMutableArray alloc]init];
        [self babyOneDelegate];
        [self performSelector:@selector(loadData) withObject:nil afterDelay:2];

    }];
    //设置设备连接失败的委托
    [baby setBlockOnFailToConnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--连接失败",peripheral.name);
    }];
    //设置设备断开连接的委托
    [baby setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--断开连接",peripheral.name);
    }];
    
    //设置发现设备的Services的委托
    [baby setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *service in peripheral.services) {
            NSLog(@"搜索到服务:%@",service.UUID.UUIDString);
        }
        //找到cell并修改detaisText
//        for (int i=0;i<peripherals.count;i++) {
//            UITableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
//            if (cell.textLabel.text == peripheral.name) {
//                cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu个service",(unsigned long)peripheral.services.count];
//            }
//        }
    }];
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===service name:%@",service.UUID);
        for (CBCharacteristic *c in service.characteristics) {
            NSLog(@"charateristic name is :%@",c.UUID);
        }
    }];
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
    }];
    //设置发现characteristics的descriptors的委托
    [baby setBlockOnDiscoverDescriptorsForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CBDescriptor name is :%@",d.UUID);
        }
    }];
    //设置读取Descriptor的委托
    [baby setBlockOnReadValueForDescriptors:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    
    //设置查找设备的过滤器
    [baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName) {
        
        //设置查找规则是名称大于1 ， the search rule is peripheral.name length > 2
        if (peripheralName.length >2) {
            return YES;
        }
        return NO;
    }];
    
    
    [baby setBlockOnCancelAllPeripheralsConnectionBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelAllPeripheralsConnectionBlock");
    }];
    
    [baby setBlockOnCancelPeripheralConnectionBlock:^(CBCentralManager *centralManager, CBPeripheral *peripheral) {
        NSLog(@"setBlockOnCancelPeripheralConnectionBlock");
    }];
    
    [baby setBlockOnCancelScanBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelScanBlock");
    }];
    
    /*设置babyOptions
     
     参数分别使用在下面这几个地方，若不使用参数则传nil
     - [centralManager scanForPeripheralsWithServices:scanForPeripheralsWithServices options:scanForPeripheralsWithOptions];
     - [centralManager connectPeripheral:peripheral options:connectPeripheralWithOptions];
     - [peripheral discoverServices:discoverWithServices];
     - [peripheral discoverCharacteristics:discoverWithCharacteristics forService:service];
     
     该方法支持channel版本:
     [baby setBabyOptionsAtChannel:<#(NSString *)#> scanForPeripheralsWithOptions:<#(NSDictionary *)#> connectPeripheralWithOptions:<#(NSDictionary *)#> scanForPeripheralsWithServices:<#(NSArray *)#> discoverWithServices:<#(NSArray *)#> discoverWithCharacteristics:<#(NSArray *)#>]
     */
    
    //示例:
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    //连接设备->
    //    [baby setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:nil scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
    
}

#pragma mark  蓝牙连接代理设置
-(void)babyOneDelegate{
    
    __weak typeof(self)weakSelf = self;
    BabyRhythm *rhythm = [[BabyRhythm alloc]init];
    
    
    //设置设备连接成功的委托,同一个baby对象，使用不同的channel切换委托回调
    
    [baby setBlockOnConnectedAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral) {
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--连接成功",peripheral.name]];
    }];
    
    //设置发现设备的Services的委托
    [baby setBlockOnDiscoverServicesAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *s in peripheral.services) {
            ///插入section到tableview
    [weakSelf insertSectionToTableView:s];
        }
        
        [rhythm beats];
    }];
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristicsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===service name:%@",service.UUID);
        //插入row到tableview
        [weakSelf insertRowToTableView:service];
        
    }];
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
    }];
    //设置发现characteristics的descriptors的委托
    [baby setBlockOnDiscoverDescriptorsForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CBDescriptor name is :%@",d.UUID);
        }
    }];
    //设置读取Descriptor的委托
    [baby setBlockOnReadValueForDescriptorsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    
    //设置beats break委托
    [rhythm setBlockOnBeatsBreak:^(BabyRhythm *bry) {
        NSLog(@"setBlockOnBeatsBreak call");
        
        //如果完成任务，即可停止beat,返回bry可以省去使用weak rhythm的麻烦
        //        if (<#condition#>) {
        //            [bry beatsOver];
        //        }
        
    }];
    
    //设置beats over委托
    [rhythm setBlockOnBeatsOver:^(BabyRhythm *bry) {
        NSLog(@"setBlockOnBeatsOver call");
    }];
    
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    /*连接选项->
     CBConnectPeripheralOptionNotifyOnConnectionKey :当应用挂起时，如果有一个连接成功时，如果我们想要系统为指定的peripheral显示一个提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnDisconnectionKey :当应用挂起时，如果连接断开时，如果我们想要系统为指定的peripheral显示一个断开连接的提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnNotificationKey:
     当应用挂起时，使用该key值表示只要接收到给定peripheral端的通知就显示一个提
     */
    NSDictionary *connectOptions = @{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnNotificationKey:@YES};
    
    [baby setBabyOptionsAtChannel:channelOnPeropheralView scanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:connectOptions scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
    
}
-(void)loadData{
    [SVProgressHUD showInfoWithStatus:@"开始连接设备"];
    baby.having(self.currPeripheral).and.channel(channelOnPeropheralView).then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
    //    baby.connectToPeripheral(self.currPeripheral).begin();
}


#pragma mark 插入table数据
-(void)insertSectionToTableView:(CBService *)service{
    NSLog(@"搜索到服务:%@",service.UUID.UUIDString);
    PeripheralInfo *info = [[PeripheralInfo alloc]init];
    [info setServiceUUID:service.UUID];
    [self.services addObject:info];
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:self.services.count-1];
    
   // [_bluetoothTableview insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
   
    
}

-(void)insertRowToTableView:(CBService *)service{
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    int sect = -1;
    for (int i=0;i<self.services.count;i++) {
        PeripheralInfo *info = [self.services objectAtIndex:i];
        if (info.serviceUUID == service.UUID) {
            sect = i;
        }
    }
    if (sect != -1) {
        PeripheralInfo *info =[self.services objectAtIndex:sect];
        for (int row=0;row<service.characteristics.count;row++) {
            CBCharacteristic *c = service.characteristics[row];
            [info.characteristics addObject:c];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:sect];
            [indexPaths addObject:indexPath];
            NSLog(@"add indexpath in row:%d, sect:%d",row,sect);
        }
        PeripheralInfo *curInfo =[self.services objectAtIndex:sect];
        NSLog(@"%@",curInfo.characteristics);
     //   [self.bluetoothTableview insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
    
    
}
#pragma mark -  Bluetooth Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    //return 1;
    return self.services.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    PeripheralInfo *info = [self.services objectAtIndex:section];
    return [info.characteristics count];
    //return 1;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CBCharacteristic *characteristic = [[[self.services objectAtIndex:indexPath.section] characteristics]objectAtIndex:indexPath.row];
    NSString *cellIdentifier = @"characteristicCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",characteristic.UUID];
    cell.detailTextLabel.text = characteristic.description;
    return cell;
}







#pragma mark - Navigation

- (IBAction)editParameter:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
                _coverView.alpha = 1.0f;
            }];
}

@end
