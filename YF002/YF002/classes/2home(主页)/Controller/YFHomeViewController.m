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


#import "MMMaterialDesignSpinner.h"
#import <QuartzCore/QuartzCore.h>



#import "SVProgressHUD.h"
#import "PeripheralInfo.h"
#import "cell.h"
//背景模糊



#define width [UIScreen mainScreen].bounds.size.width
#define height [UIScreen mainScreen].bounds.size.height
#define channelOnPeropheralView @"peripheralView"
#define kDropDownListTag 1000

@interface YFHomeViewController () <AKPickerViewDataSource,AKPickerViewDelegate,MZTimerLabelDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDelegate>{
    MZTimerLabel *_timer;
    

    
    //蓝牙连接参数
    NSMutableArray *peripherals;
    NSInteger batteryValue;
    BOOL setAutoState;
    //蓝牙peripheral部分参数
     UITextField *txCounterTextField;
     UITextField *rxCounterTextField;
     UITextView *showStringTextView;
     UILabel *statusLabel;
     UITextField *inputTextField;
     UIButton *autoManualModeButton;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//保存时弹出窗口的属性
//@property (nonatomic, strong) STAlertView *stAlertView;

//在YFPamameterItemTableViewController 数组中选择第几个治疗参数
@property (assign,nonatomic) NSInteger  treatItemNumber;




//计时动画圈圈属性
@property (nonatomic ,strong) MMMaterialDesignSpinner *spinnerView;

//pickView的属性
@property (nonatomic, strong) AKPickerView *treatTimePickerView;
@property (nonatomic, strong) AKPickerView *treatStrengthPickerView;
@property (nonatomic, strong) AKPickerView *treatWavePickerView;


@property (nonatomic, strong) NSArray *treatTimePickerViewArray;
@property (nonatomic, strong) NSArray *treatStrengthPickerViewArray;
@property (nonatomic, strong) NSArray *treatWavePickerViewArray;

@property (nonatomic, strong) YFTreatParameterItem *treatParameterItem;
@property (nonatomic, copy) NSString *treatDrug;
@property (nonatomic, copy) NSString *treatDrugQuantity;





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
@property (nonatomic,assign) BOOL _isStateOn;

@property (weak, nonatomic) IBOutlet UIView *allPickerView;
//倒计时所在的层视图
@property (weak, nonatomic) IBOutlet UIView *timeCountView;
@property (weak, nonatomic) IBOutlet UIImageView *timeCountBackground;
//蓝牙连接按钮
@property (nonatomic,strong) UIButton *btn;
@property (nonatomic,strong) NSMutableString *sender;

@end

@implementation YFHomeViewController
#pragma mark - 初始化的内容
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:187.0/255 green:135.0/255 blue:87.0/255 alpha:0.8]}];
// 0.滚动的scrollView
    self.scrollView.frame = CGRectMake(0, 0, width, 560);
    [self.scrollView setContentSize:CGSizeMake(width, 600)];
    
    _allPickerView.frame = CGRectMake(0, 0, width, 170);
    _allPickerView.center = CGPointMake(width/2, 85);
    _editParameter.center =CGPointMake(width/2, 148);
    _timeCountView.center = CGPointMake(width/2, 305);
    // 3.开启编辑参数按钮 圆角实现
    [_editParameter.layer setMasksToBounds:YES];
    [_editParameter.layer setCornerRadius:5];
    //__isStateOn = YES;
 
// 0.1设置左上角蓝牙连接按钮的背景图片
    // 0.11新建一个按钮
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = CGRectMake(20, 8, 30, 30);
    [_btn setBackgroundImage:[UIImage imageNamed:@"bluetoothOff"] forState:UIControlStateNormal];
    // 0.12增加selector的方法
    [_btn addTarget: self action: @selector(bluetoothConnect) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:_btn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    //0.13使导航栏右边的字体大小
    
    
    
   
//  1.初始化治疗参数
    _treatParameterItem = [[YFTreatParameterItem alloc] initWithIndex:2];
     NSLog(@"%@", _treatParameterItem.datafromTreatItem);

//   2.创建 pickerView 第一个时间选择pickview X轴xPickerView,y轴yPickerView,y轴增加值xAddPickerView
    NSInteger xPickerView = 80,yPickerView =10,yAddPickerView = 40;
    [self treatTimePickerViewLoad:CGRectMake(xPickerView, yPickerView, 240, 30)];
    [self treatStrengthPickerViewLoad:CGRectMake(xPickerView,(yPickerView+yAddPickerView) , 240, 30)];
    [self treatWavePickerViewLoad:CGRectMake(xPickerView, (yPickerView+2*yAddPickerView), 240, 30)];
    //[self treatModelPickerViewLoad:CGRectMake(xPickerView,(yPickerView+3*yAddPickerView), 200, 60)];
     //   初始化载入每个pickerView选中的行
    [self loadTreatItemToPickerView];
 
    
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
    self.spinnerView.frame = CGRectMake(0, 0, 220, 220);
    self.spinnerView.lineWidth = 3.6f;
    self.spinnerView.tintColor = [UIColor colorWithRed:194.f/255 green:53.f/255 blue:127.f/255 alpha:0.3];
    self.spinnerView.center = CGPointMake(_timeCountBackground.center.x, _timeCountBackground.center.y);
   [self.timeCountView insertSubview:self.spinnerView atIndex:2];
 

    
// 6.创建 蓝牙
    //初始化
    // 使用全局全量
    // CBCentral里面的使用全局全量
    blead = [[UIApplication sharedApplication]delegate];
    _blePeripheralTableView.delegate = self;
    
    
    // 清空所有显示
    _currentPeripheral.txCounter = 0;
    _currentPeripheral.rxCounter = 0;
    _currentPeripheral.ShowStringBuffer =@"0";
    // CBCentral里面的注册通知回调
    nCBCentralStateChange
    nCBPeripheralStateChange
    nCBUpdataShowStringBuffer
    
    
    
  // 7.push链接
    //延时1秒
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
          //跳转到选择界面
          [self performSegueWithIdentifier:@"forChoose" sender:self];
    });
  
    //7.1 监听选择视图返回的值，得到值后进行相应操作
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeNameNotification:) name:@"ChangeNameNotification" object:nil];
    

}


-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"viewDidAppear");
       self.navigationController.navigationBarHidden = NO;
   
    //如果还在及时，则圆圈动画继续
    if([_timer counting]){
        [self.spinnerView stopAnimating];
        [self.spinnerView startAnimating];
     }
    
    
    //停止之前的连接
   
}
#pragma mark - 蓝牙通讯数据格式
/*
开头加E
 （0）查询或工作 1.按照新指令工作 2.查询状态指令
 （1）操作    1.开始  2.暂停  3.继续  4.停止
 （2）强度   1. 第一档（最弱） 2.第二档  3.第三档  4.第四档  5.第五档（最强）
 （3）波形   1.方波  2.锯齿波  3.正弦波  4.尖波  5.随机波形
 （4）时间   1.1分钟  2.5分钟  3.10分钟  4.15分钟  5.20分钟
 （5）开关机   1.开机  2.关机
 （6）预留
结束加F
 
 
 */
#pragma mark -  选择视图返回的值进行处理
-(void)ChangeNameNotification:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification userInfo];
    NSString *fromChooseVC = [nameDictionary objectForKey:@"value"];
    if ([fromChooseVC isEqualToString:@"1"]) {
        NSLog(@"选择了1");
        //选择对于的treatParameterItem
        [_treatParameterItem newParameterWithIndex:2];
        [self loadTreatItemToPickerView];
        //editParameter关闭编辑并且把开启参数编辑按钮可用
        [self closeEditParameter];

        
    } else {
        if ([fromChooseVC isEqualToString:@"2"]) {
            NSLog(@"选择了2/推荐参数");
            //选择对于的treatParameterItem
            [_treatParameterItem newParameterWithIndex:0];
            [self loadTreatItemToPickerView];
            //editParameter关闭编辑并且把开启参数编辑按钮不可用
            [self openEditParameter];
            //_editParameter.userInteractionEnabled = NO;
        } else {
            if ([fromChooseVC isEqualToString:@"3"]) {
                NSLog(@"选择了3/上次治疗参数");
                //选择对于的treatParameterItem
                [_treatParameterItem newParameterWithIndex:1];
                [self loadTreatItemToPickerView];
                //editParameter关闭编辑并且把开启参数编辑按钮不可用
                [self openEditParameter];
                //_editParameter.userInteractionEnabled = NO;
            }
        }
    }
}
//移除观察者
//-(void)dealloc{
 //   [[NSNotificationCenter defaultCenter] removeObserver:self];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





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
            [_timer setCountDownTime:setTime*60*5];
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
- (void) loadTreatItemToPickerView{
//载入每个pickerView选中的行
[_treatTimePickerView selectItem:[[_treatParameterItem.treatTime substringWithRange:NSMakeRange(0, 1)] integerValue] animated:NO];
[_treatStrengthPickerView selectItem:[[_treatParameterItem.treatStrength substringWithRange:NSMakeRange(0, 1)] integerValue] animated:NO];
[_treatWavePickerView selectItem:[[_treatParameterItem.treatWave substringWithRange:NSMakeRange(0, 1)] integerValue] animated:NO];
}
#pragma mark - 保存参数按钮

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

#pragma mark - editParameter 编辑参数的按钮
- (IBAction)editParameter:(id)sender {
//禁用pickView
    if ( _treatStrengthPickerView.userInteractionEnabled ) {
        
        [self openEditParameter];
        
    }else{
      
        [self closeEditParameter];
    }
  [UIView animateWithDuration:0.5 animations:^{
        _coverView.alpha = 1.0f;
    }];
}

- (void) openEditParameter{
    //pickerView中的text字体颜色成透明色， pickView不可使用手势
    [_treatWavePickerView setUserInteractionEnabled:NO];
    [_treatStrengthPickerView setUserInteractionEnabled:NO];
    [_treatTimePickerView setUserInteractionEnabled:NO];
    _treatStrengthPickerView.textColor = [UIColor clearColor];
    _treatTimePickerView.textColor = [UIColor clearColor];
    _treatWavePickerView.textColor = [UIColor clearColor];
    [_treatStrengthPickerView reloadData];
    [_treatTimePickerView reloadData];
    [_treatWavePickerView reloadData];
    //编辑按钮颜色成灰色
    _editParameter.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.7];
    _editParameter.titleLabel.text = @"打开参数编辑";
}

- (void) closeEditParameter{
    //pickerView中的text字体颜色恢复成原来颜色， pickView可使用手势
    [_treatWavePickerView setUserInteractionEnabled:YES];
    [_treatStrengthPickerView setUserInteractionEnabled:YES];
    [_treatTimePickerView setUserInteractionEnabled:YES];
    _treatStrengthPickerView.textColor = [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:0.8];
    _treatTimePickerView.textColor = [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:0.8];
    _treatWavePickerView.textColor = [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:0.8];
    [_treatStrengthPickerView reloadData];
    [_treatTimePickerView reloadData];
    [_treatWavePickerView reloadData];
    //编辑按钮颜色成白色
    
    _editParameter.backgroundColor = [UIColor whiteColor];
    _editParameter.titleLabel.text = @"关闭参数编辑";
}
#pragma mark - 开始 暂停 重置按钮的方法
- (IBAction)startOrResumeCountDown:(id)sender {
    
    if([_timer counting]){
        [_timer pause];
        
        [_startPauseBtn setTitle:@"继续" forState:UIControlStateNormal];
        
        [_resetBtn setEnabled:YES];
        
        //圆圈动画结束
        [self.spinnerView stopAnimating];
        
        //发送暂停蓝牙数据，数据格式
         NSString *str1 =  [_sender stringByReplacingCharactersInRange:NSMakeRange(2, 1) withString:@"2"];
        _sender = [str1 mutableCopy];
        NSLog(@"发送暂停蓝牙数据，数据格式位%@",_sender);
        [self SendInputButton:[_sender copy]];

    }else{
        
        //给蓝牙设备发送指令以便其工作
        if (_currentPeripheral.connectedFinish == YES) {
            //开始计时
            [_timer start];
            //editParameter关闭编辑并且把开启参数编辑按钮不可用
            [self openEditParameter];
            _editParameter.userInteractionEnabled = NO;
            //导航栏右上角参数更改不可用
            self.navigationItem.rightBarButtonItem.enabled =NO;
            //导航栏左上角按钮不可用
            [_btn setUserInteractionEnabled:NO];
            //圆圈动画开始
            [self.spinnerView startAnimating];
            
            //判断是否是继续
            
                if ( [_startPauseBtn.titleLabel.text isEqualToString:@"开始"]) {
                    //发送开始蓝牙数据，数据格式
                    [self initSendStartData];
                    NSLog(@"发送开始蓝牙数据，数据格式位%@",_sender);
                    [self SendInputButton:[_sender copy]];
                    //把开始按钮设置位继续；
                    [_startPauseBtn setTitle:@"暂停" forState:UIControlStateNormal];
                }else{
                    //发送继续蓝牙数据，数据格式
                    NSString *str1 =  [_sender stringByReplacingCharactersInRange:NSMakeRange(2, 1) withString:@"3"];
                    _sender = [str1 mutableCopy];
                    NSLog(@"发送继续蓝牙数据，数据格式位%@",_sender);
                    [self SendInputButton:[_sender copy]];
                }
            }
        else {
            [SVProgressHUD showErrorWithStatus:@"没有找到可控制的蓝牙，确定蓝牙已经连接？"];
            
        }
           
        }
        
    }
    

-(void)initSendStartData{
    NSString *str1 = @"E1100011F";
    NSString *str2 = [str1 stringByReplacingCharactersInRange:NSMakeRange(2, 1) withString:@"1"];
    NSString *str3 = [str2 stringByReplacingCharactersInRange:NSMakeRange(3, 1) withString:_treatParameterItem.treatStrength];
    NSString *str4 =[[NSString alloc] init];
    if ([_treatParameterItem.treatWave  isEqualToString:@"A"]) {
        str4 = [str3 stringByReplacingCharactersInRange:NSMakeRange(4, 1) withString:@"1"];
    } else if ([_treatParameterItem.treatWave  isEqualToString:@"B"]){
        [str3 stringByReplacingCharactersInRange:NSMakeRange(4, 1) withString:@"2"];
    }else if ([_treatParameterItem.treatWave  isEqualToString:@"C"]){
        str4 =[str3 stringByReplacingCharactersInRange:NSMakeRange(4, 1) withString:@"3"];
    }else if ([_treatParameterItem.treatWave  isEqualToString:@"D"]){
        str4 = [str3 stringByReplacingCharactersInRange:NSMakeRange(4, 1) withString:@"4"];
    }else if ([_treatParameterItem.treatWave  isEqualToString:@"R"]){
        str4 =  [str3 stringByReplacingCharactersInRange:NSMakeRange(4, 1) withString:@"5"];
    }
    _sender =[[str4 stringByReplacingCharactersInRange:NSMakeRange(5, 1) withString:_treatParameterItem.treatTime] mutableCopy];
}

- (IBAction)resetCountDown:(id)sender {
    
    
    if(![_timer counting]){
        [_timer reset];
        [_startPauseBtn setTitle:@"开始" forState:UIControlStateNormal];
        //导航栏右上角参数更改不可用
        self.navigationItem.rightBarButtonItem.enabled =YES;
        //发送停止蓝牙数据，数据格式
        NSString *str1 =  [_sender stringByReplacingCharactersInRange:NSMakeRange(2, 1) withString:@"4"];
        _sender = [str1 mutableCopy];
        NSLog(@"发送停止蓝牙数据，数据格式位%@",_sender);
        [self SendInputButton:[_sender copy]];
    }
     [_resetBtn setEnabled:NO];
     //editParameter开启参数编辑按钮可用
    _editParameter.userInteractionEnabled = YES;
    //导航栏左上角按钮不可用
    [_btn setUserInteractionEnabled:YES];
}
- (void)timerLabel:(MZTimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    //圆圈动画结束
    [self.spinnerView stopAnimating];
    
    //设置结束后，按钮设置成开始；
    [_startPauseBtn setTitle:@"开始" forState:UIControlStateNormal];
    
    //editParameter开启参数编辑按钮可用
    _editParameter.hidden = NO;
    
    //导航栏右上角参数更改不可用
    self.navigationItem.rightBarButtonItem.enabled =YES;
    
    //提示用户完成治疗,出现用户选择画面
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




#pragma mark - ----蓝牙部分-----

#pragma mark  蓝牙连接或断开
- (void) bluetoothConnect{
    if (blead.ble.currentCentralManagerState == bleCentralDelegateStateCentralManagerPoweredOff) {
        [SVProgressHUD showInfoWithStatus:@"请打开本机的蓝牙设备"];
    }else{
        if (_currentPeripheral.connectedFinish == YES) {
            [blead.ble disconnectPeripheral:_currentPeripheral.activePeripheral];
            //更改蓝牙图标
            [_btn setBackgroundImage:[UIImage imageNamed:@"bluetoothOff"] forState:UIControlStateNormal];
        }else{
            
            //寻找开头位YF002的蓝牙名称字段，进行连接
            for (NSInteger i = 0; i<[blead.ble.blePeripheralArray count]; i++) {
                blePeripheral *peripheral= [blead.ble.blePeripheralArray objectAtIndex:i];
                NSString *shotName =[peripheral.nameString substringWithRange:NSMakeRange(0, 5)];
                if ([shotName isEqualToString:@"YF002"]) {
                    _currentPeripheral =peripheral;
                    [blead.ble connectPeripheral:_currentPeripheral.activePeripheral];
                    // 初始化页面状态
                    
                    setAutoState = NO;
                    inputTextField.text = @"xuyg";
                    [self CBUpdataShowStringBuffer];
                    
                    // 注册通知回调
                    nCBPeripheralStateChange
                    nCBUpdataShowStringBuffer
                    
                    //更改蓝牙图标
                    [_btn setBackgroundImage:[UIImage imageNamed:@"bluetoothOn"] forState:UIControlStateNormal];
                    break;
                }else{
                [SVProgressHUD showInfoWithStatus:@"没有找到可以使用的设备"];
                 //蓝牙图标为关
                 [_btn setBackgroundImage:[UIImage imageNamed:@"bluetoothOff"] forState:UIControlStateNormal];
                }
            }
        }
       
        
        
//        if (_currentPeripheral.activePeripheral.state == CBPeripheralStateConnected) {
//            [blead.ble connectPeripheral:_currentPeripheral.activePeripheral];
//        }
    }
   
   
    [_btn.layer addAnimation:[self opacityForever_Animation:0.2] forKey:nil];
   
    
}
//闪烁的动画
-(CABasicAnimation *)opacityForever_Animation:(float)time
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = 5;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

#pragma mark 蓝牙peripheral发送部分按钮

- (void)SendInputButton:(NSString *)sender {
    // 手动模式下，才可以发送数据
    if (_currentPeripheral.connectedFinish == YES) {
        NSString *inputString = sender;
        Byte length = inputString.length;
        if (0 < length && length <= 5) {
            char index;
            Byte viewData[5];
            for (index = 0; index <5; index++) {
                viewData[index] = 0x00;
            }
            NSString *aString;
            for (index = 0; index < length; index++) {
                aString = [inputString substringWithRange:NSMakeRange(index, 1)];
                sscanf([aString cStringUsingEncoding:NSASCIIStringEncoding], "%s", &viewData[index]);
                if (viewData[index] == 0x00 ) {
                    viewData[index] = 0x20;
                }
            }
            // 发送数据
            _currentPeripheral.sendData = [[NSData alloc]initWithBytes:&viewData length:TRANSMIT_05BYTES_DATA_LENGHT];
        }
        
        else if(5 < length && length <= 10){
            char index;
            Byte viewData[10];
            for (index = 0; index <10; index++) {
                viewData[index] = 0x00;
            }
            NSString *aString;
            for (index = 0; index < length; index++) {
                aString = [inputString substringWithRange:NSMakeRange(index, 1)];
                sscanf([aString cStringUsingEncoding:NSASCIIStringEncoding], "%s", &viewData[index]);
                if (viewData[index] == 0x00 ) {
                    viewData[index] = 0x20;
                }
            }
            // 发送数据
            _currentPeripheral.sendData = [[NSData alloc]initWithBytes:&viewData length:TRANSMIT_10BYTES_DATA_LENGHT];
        }
        
        else if(10 < length && length <= 15){
            char index;
            Byte viewData[15];
            for (index = 0; index <15; index++) {
                viewData[index] = 0x00;
            }
            NSString *aString;
            for (index = 0; index < length; index++) {
                aString = [inputString substringWithRange:NSMakeRange(index, 1)];
                sscanf([aString cStringUsingEncoding:NSASCIIStringEncoding], "%s", &viewData[index]);
                if (viewData[index] == 0x00 ) {
                    viewData[index] = 0x20;
                }
            }
            // 发送数据
            _currentPeripheral.sendData = [[NSData alloc]initWithBytes:&viewData length:TRANSMIT_15BYTES_DATA_LENGHT];
        }
        
        else if(15 < length && length <= 20){
            char index;
            Byte viewData[21];
            for (index = 0; index <20; index++) {
                viewData[index] = 0x00;
            }
            NSString *aString;
            for (index = 0; index < length; index++) {
                aString = [inputString substringWithRange:NSMakeRange(index, 1)];
                sscanf([aString cStringUsingEncoding:NSASCIIStringEncoding], "%s", &viewData[index]);
                if (viewData[index] == 0x00 ) {
                    viewData[index] = 0x20;
                }
            }
            // 发送数据
            _currentPeripheral.sendData = [[NSData alloc]initWithBytes:&viewData length:TRANSMIT_20BYTES_DATA_LENGHT];
        }
        else{
            statusLabel.text = @"Error send data";
        }
    }else{
        statusLabel.text = @"设备尚未连接";
    }
    
    
}

#pragma mark  通知回调函数
#pragma mark - CBCentral里面的通知回调函数
-(void)CBCentralStateChange{
    if (blead.ble.currentCentralManagerState == bleCentralDelegateStateDisconnectPeripheral
) {
        _currentPeripheral=nil;
        [SVProgressHUD showErrorWithStatus:@"与设备断开了连接，请检查"];
        //重置时间
        [_timer pause];
        [_timer reset];
        [_startPauseBtn setTitle:@"开始" forState:UIControlStateNormal];
        //导航栏右上角参数更改不可用
        self.navigationItem.rightBarButtonItem.enabled =YES;
        //圆圈动画结束
        [self.spinnerView stopAnimating];
        //更改蓝牙图标
        [_btn setBackgroundImage:[UIImage imageNamed:@"bluetoothOff"] forState:UIControlStateNormal];
        [_btn setUserInteractionEnabled:YES];
        //editParameter开启参数编辑按钮可用
        _editParameter.userInteractionEnabled = YES;

    }
    [self CBUpdataShowStringBuffer];
}

-(void)CBPeripheralStateChange{
    [self CBUpdataShowStringBuffer];
}


#pragma mark - CBPeripheral里面的注册通知回调通知回调函数
-(void)CBUpdataShowStringBuffer{
    if (_currentPeripheral.connectedFinish == YES) {
        txCounterTextField.text = [[NSString alloc]initWithFormat:@"%d",_currentPeripheral.txCounter];
        rxCounterTextField.text = [[NSString alloc]initWithFormat:@"%d",_currentPeripheral.rxCounter];
        showStringTextView.text = _currentPeripheral.ShowStringBuffer;
        statusLabel.text = _currentPeripheral.staticString;
        
        // 自动滚动
        int16_t showTextViewRow = _currentPeripheral.txCounter + _currentPeripheral.rxCounter;
        
        float f = 17*showTextViewRow;
        if (showTextViewRow == 200) {
           
        }
        
        if (showTextViewRow > 8) {
            [showStringTextView setContentOffset:CGPointMake(0, f-130) animated:NO];
        }
    }else{
        [_blePeripheralTableView reloadData];
        // [self bluetoothConnect];
    }
    
    
}


#pragma mark  找出来的peripheral在表格中处理的函数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return blead.ble.blePeripheralArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellTableIdentifier";
    UINib *nib = [UINib nibWithNibName:@"cell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // 自动更新
    cell.currentPeripheral = [blead.ble.blePeripheralArray objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        blePeripheral *bp = [blead.ble.blePeripheralArray objectAtIndex:indexPath.row];
        [blead.ble disconnectPeripheral:bp.activePeripheral];
        [bp initPeripheralWithSeviceAndCharacteristic];
        [bp initPropert];
        [blead.ble.blePeripheralArray removeObjectAtIndex:indexPath.row];
        [blead.ble resetScanning];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    //在移动到的位置加入新的一行，内容为所选择的那一行
    [blead.ble.blePeripheralArray insertObject:[blead.ble.blePeripheralArray objectAtIndex:fromIndexPath.row] atIndex: toIndexPath.row];
    //删除所选行的下一行
    [blead.ble.blePeripheralArray removeObjectAtIndex:(NSUInteger)fromIndexPath.row+1];
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

#pragma mark - 表格点击cell处理函数
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (blead.ble.blePeripheralArray.count > indexPath.row) {
        //Sub *svc = [[Sub alloc]init];
        // 显示当前设备子页面
       // svc.currentPeripheral = [blead.ble.blePeripheralArray objectAtIndex:indexPath.row];
        
        if (!(_currentPeripheral.activePeripheral.state == CBPeripheralStateConnected)) {
            [blead.ble connectPeripheral:_currentPeripheral.activePeripheral];
        }
        else{
            if (_currentPeripheral.connectedFinish == YES) {
                //[self.navigationController pushViewController:svc animated:YES];
            }
            else{
                [blead.ble disconnectPeripheral:_currentPeripheral.activePeripheral];
            }
        }
    }
    else{
        NSLog(@"ERROR ROW");
    }
}


#pragma mark -  Bluetooth Table view data source




@end
