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

#define kDropDownListTag 1000

@interface YFHomeViewController () <AKPickerViewDataSource,AKPickerViewDelegate,YFPamameterItemTVCDelegate,MZTimerLabelDelegate,UIScrollViewDelegate,LMComBoxViewDelegate,YFRecordTVCDelegate>{
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
}

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
@property (nonatomic, strong) AKPickerView *treatModelPickerView;

@property (nonatomic, strong) NSArray *treatTimePickerViewArray;
@property (nonatomic, strong) NSArray *treatStrengthPickerViewArray;
@property (nonatomic, strong) NSArray *treatWavePickerViewArray;
@property (nonatomic, strong) NSArray *treatModelPickerViewArray;

@property (nonatomic, strong) YFTreatParameterItem *treatParameterItem;
@property (nonatomic, copy) NSString *treatDrug;
@property (nonatomic, copy) NSString *treatDrugQuantity;
//@property (nonatomic,strong) UIView *aview;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//设置倒计时 时间 按钮
@property (weak, nonatomic) IBOutlet UILabel  *timerCountDownLabel;
@property (weak, nonatomic) IBOutlet UIButton *startPauseBtn;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveTreatPamameterItem;
- (IBAction)startOrResumeCountDown:(id)sender;
- (IBAction)resetCountDown:(id)sender;
- (IBAction)saveTreatPamameterItem:(id)sender;

@end

@implementation YFHomeViewController
#pragma mark - 初始化的内容
- (void)viewDidLoad {
    
    [super viewDidLoad];

//   创建滚动视图
    _scrollView.directionalLockEnabled = YES;
    //只能一个方向滑动
    _scrollView.pagingEnabled = NO;
    //是否翻页
    _scrollView.showsVerticalScrollIndicator =YES;
    //垂直方向的滚动指示
    _scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    //滚动指示的风格
    _scrollView.showsHorizontalScrollIndicator = NO;
    //水平方向的滚动指示
    _scrollView.delegate = self;
    CGSize newSize = CGSizeMake(self.view.frame.size.width, 600);
    [_scrollView setContentSize:newSize];


    
//  创建倒计时的圈圈动画
    MMMaterialDesignSpinner *spinnerView = [[MMMaterialDesignSpinner alloc] initWithFrame:CGRectZero];
    self.spinnerView = spinnerView;
    self.spinnerView.bounds = CGRectMake(0, 0, 140, 140);
    self.spinnerView.lineWidth = 3.0f;
    self.spinnerView.tintColor = [UIColor colorWithRed:70.f/255 green:188.f/255 blue:76.f/255 alpha:0.8];
    self.spinnerView.center = CGPointMake(CGRectGetMidX(self.view.bounds), 78);
   
    [self.view insertSubview:self.spinnerView atIndex:2];
    
//  初始化治疗参数
    _treatParameterItem = [[YFTreatParameterItem alloc] initWithIndex:1];
     NSLog(@"%@", _treatParameterItem.datafromTreatItem);

//   创建 pickerView 第一个pickview X轴xPickerView,y轴yPickerView,y轴增加值xAddPickerView
    NSInteger xPickerView = 70,yPickerView = 148,yAddPickerView = 50;
    [self treatTimePickerViewLoad:CGRectMake(xPickerView, yPickerView, 200, 60)];
    [self treatStrengthPickerViewLoad:CGRectMake(xPickerView,(yPickerView+yAddPickerView) , 200, 60)];
    [self treatWavePickerViewLoad:CGRectMake(xPickerView, (yPickerView+2*yAddPickerView), 200, 60)];
    [self treatModelPickerViewLoad:CGRectMake(xPickerView,(yPickerView+3*yAddPickerView), 200, 60)];
     //   初始化载入每个pickerView选中的行
    [_treatTimePickerView selectItem:[[_treatParameterItem.treatTime substringWithRange:NSMakeRange(1, 1)] integerValue] animated:NO];
    [_treatStrengthPickerView selectItem:[[_treatParameterItem.treatStrength substringWithRange:NSMakeRange(1, 1)] integerValue] animated:NO];
    [_treatWavePickerView selectItem:[[_treatParameterItem.treatWave substringWithRange:NSMakeRange(1, 1)] integerValue] animated:NO];
    [_treatModelPickerView selectItem:[[_treatParameterItem.treatModel substringWithRange:NSMakeRange(1, 1)] integerValue] animated:NO];

//  设置navigationBar 左侧栏的名称以及按键调用的方法
    UIImage *leftBarButtonItem = [UIImage imageNamed:@"blueToothGray" ];
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithImage:leftBarButtonItem landscapeImagePhone:nil style:UIBarButtonItemStyleBordered target:self action:@selector(switchTouched)];
    [self.navigationItem.leftBarButtonItem setImage:[leftBarButtonItem imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    
//  创建 MZTimerLabel倒计时  按钮
    _timer = [[MZTimerLabel alloc] initWithLabel:_timerCountDownLabel andTimerType:MZTimerLabelTypeTimer];
    //读出初始化时间,字符串转数值
    NSTimeInterval initTime = (NSTimeInterval )[[_treatParameterItem.treatTime substringWithRange:NSMakeRange(1, 1)] integerValue];
    //设置初始化时间
    if (initTime == 0) {
        [_timer setCountDownTime:60];
    }else{
        [_timer setCountDownTime:initTime*5*60];}
    //关闭时间设置中的重置按钮
    [_resetBtn setEnabled:NO];
    _timer.resetTimerAfterFinish = YES;
    _timer.delegate = self;
    _timer.timeFormat = @"mm:ss";


  
 
// 设置代理与ViewController
    
    YFRecordTVC *yfRecordTVC = [[YFRecordTVC alloc] initWithNibName:@"YFRecordTVC" bundle:nil];
    yfRecordTVC.delegate = self;

// 创建药物下拉菜单
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    areaDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    [self loadAreaDicWithCGRect:CGRectMake(20, 407, 320, 140)];
    
//  设置sideView
    _sideSlipView = [[JKSideSlipView alloc] initWithSender:self];
    _menu = [MenuView menuView];
    [self loadSideViewData];
    [_sideSlipView setContentView:_menu];
    _menu.myTableView.separatorStyle =UITableViewCellSeparatorStyleSingleLine;
    _menu.myTableView.separatorColor = [UIColor colorWithRed:0.1 green:0.8 blue:0.1 alpha:1.0];
    [self.view addSubview:_sideSlipView];
    
// 创建 蓝牙
    _manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    _cbReady = false;
    _nDevices = [[NSMutableArray alloc]init];
    _nServices = [[NSMutableArray alloc]init];
    _nCharacteristics = [[NSMutableArray alloc]init];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -LMComBoxViewDelegate
-(void)loadAreaDicWithCGRect:(CGRect) cgrect{
    NSArray *components = [areaDic allKeys];
    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *provinceTmp = [NSMutableArray array];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[areaDic objectForKey: index] allKeys];
        [provinceTmp addObject: [tmp objectAtIndex:0]];
    }
    
    province = [NSArray arrayWithArray:provinceTmp];
    
    NSString *index = [sortedArray objectAtIndex:0];
    NSString *selected = [province objectAtIndex:0];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [[areaDic objectForKey:index]objectForKey:selected]];
    
    NSArray *cityArray = [dic allKeys];
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:0]]];
    city = [NSArray arrayWithArray:[cityDic allKeys]];
    
    selectedCity = [city objectAtIndex:0];
    district = [NSArray arrayWithArray:[cityDic objectForKey:selectedCity]];
    
    addressDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                   province,@"province",
                   city,@"city",
                   district,@"area",nil];
    
    selectedProvince = [province objectAtIndex:0];
    selectedArea = [district objectAtIndex:0];
    
    bgScrollView = [[LMContainsLMComboxScrollView alloc]initWithFrame:cgrect];
    bgScrollView.backgroundColor = [UIColor clearColor];
    bgScrollView.showsVerticalScrollIndicator = NO;
    bgScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:bgScrollView];
    
    [self setUpBgScrollView];
    
}
-(void)setUpBgScrollView{
   
    
    NSArray *keys = [NSArray arrayWithObjects:@"province",@"city",@"area", nil];
    for(NSInteger i=0;i<3;i++)
    {
        NSInteger x = 40+(60)*i  ;
        NSInteger xWidth =  115;
        if (i==1) {
            
            x = 155 ;
            xWidth = 85 ;
          
        } else if (i ==2){
            x =  240 ;
            xWidth =  40;
        };
        
        LMComBoxView *comBox = [[LMComBoxView alloc]initWithFrame:CGRectMake(x, 0, xWidth, 29)];
        comBox.backgroundColor = [UIColor whiteColor];
        comBox.arrowImgName = @"down_dark0.png";
        NSMutableArray *itemsArray = [NSMutableArray arrayWithArray:[addressDict objectForKey:[keys objectAtIndex:i]]];
        comBox.titlesList = itemsArray;
        comBox.delegate = self;
        comBox.supView = bgScrollView;
        [comBox defaultSettings];
        comBox.tag = kDropDownListTag + i;
        [bgScrollView addSubview:comBox];
    }
}

#pragma mark - LMComBoxViewDelegate
-(void)selectAtIndex:(int)index inCombox:(LMComBoxView *)_combox{
    NSInteger tag = _combox.tag - kDropDownListTag;
    switch (tag) {
        case 0:
        {
            selectedProvince =  [[addressDict objectForKey:@"province"]objectAtIndex:index];
            //字典操作
            NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: [NSString stringWithFormat:@"%d", index]]];
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
            NSArray *cityArray = [dic allKeys];
            NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
                
                if ([obj1 integerValue] > [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedDescending;//递减
                }
                
                if ([obj1 integerValue] < [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedAscending;//上升
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (int i=0; i<[sortedArray count]; i++) {
                NSString *index = [sortedArray objectAtIndex:i];
                NSArray *temp = [[dic objectForKey: index] allKeys];
                [array addObject: [temp objectAtIndex:0]];
            }
            city = [NSArray arrayWithArray:array];
            
            NSDictionary *cityDic = [dic objectForKey: [sortedArray objectAtIndex: 0]];
            district = [NSArray arrayWithArray:[cityDic objectForKey:[city objectAtIndex:0]]];
            //刷新市、区
            addressDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                           province,@"province",
                           city,@"city",
                           district,@"area",nil];
            LMComBoxView *cityCombox = (LMComBoxView *)[bgScrollView viewWithTag:tag + 1 + kDropDownListTag];
            cityCombox.titlesList = [NSMutableArray arrayWithArray:[addressDict objectForKey:@"city"]];
            [cityCombox reloadData];
            LMComBoxView *areaCombox = (LMComBoxView *)[bgScrollView viewWithTag:tag + 2 + kDropDownListTag];
            areaCombox.titlesList = [NSMutableArray arrayWithArray:[addressDict objectForKey:@"area"]];
            [areaCombox reloadData];
            
            selectedCity = [city objectAtIndex:0];
            selectedArea = [district objectAtIndex:0];
            break;
        }
        case 1:
        {
            selectedCity = [[addressDict objectForKey:@"city"]objectAtIndex:index];
            
            NSString *provinceIndex = [NSString stringWithFormat: @"%d", [province indexOfObject: selectedProvince]];
            NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: provinceIndex]];
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
            NSArray *dicKeyArray = [dic allKeys];
            NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
                
                if ([obj1 integerValue] > [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                
                if ([obj1 integerValue] < [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
            
            NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [sortedArray objectAtIndex: index]]];
            NSArray *cityKeyArray = [cityDic allKeys];
            district = [NSArray arrayWithArray:[cityDic objectForKey:[cityKeyArray objectAtIndex:0]]];
            //刷新区
            addressDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                           province,@"province",
                           city,@"city",
                           district,@"area",nil];
            LMComBoxView *areaCombox = (LMComBoxView *)[bgScrollView viewWithTag:tag + 1 + kDropDownListTag];
            areaCombox.titlesList = [NSMutableArray arrayWithArray:[addressDict objectForKey:@"area"]];
            [areaCombox reloadData];
            
            selectedArea = [district objectAtIndex:0];
            break;
        }
        case 2:
        {
            selectedArea = [[addressDict objectForKey:@"area"]objectAtIndex:index];
            break;
        }
        default:
            break;
    }
    _treatDrug = selectedCity;
    _treatDrugQuantity = selectedArea;
    NSLog(@"===%@===%@===%@",selectedProvince,selectedCity,selectedArea);
}

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
    [_treatModelPickerView selectItem:[[_treatParameterItem.treatModel substringWithRange:NSMakeRange(1, 1)] integerValue] animated:NO];
    
}

#pragma mark -YFPamameterTableViewController Delegate (Get Array)
- (NSArray *)getArrayHomeVC{
    
    return _treatParameterItem.datafromTreatItem;
}
- (NSInteger )getRowFromHomeVC{
    return _treatItemNumber;
}

#pragma mark -YFRecordTVC Delegate
- (NSArray *)ArrayToRecordTVC{
    return  _treatParameterItem.datafromTreatHistory;
}

#pragma mark - 跳转链接segue
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
    else if([pickerView isEqual:_treatWavePickerView])
    {
        return [_treatWavePickerViewArray count];
    }
    else
    {
        return [_treatModelPickerViewArray count];
    }
}

#pragma mark - AKPickerViewDataSource 选择器初始化
- (void)treatTimePickerViewLoad:(CGRect )pickerViewCGRect{
    if (_treatTimePickerView == nil) {
        _treatTimePickerView = [[AKPickerView alloc] initWithFrame:pickerViewCGRect];
    }
    
    [self pickerViewParameterLoad:_treatTimePickerView];
    //取出数据模型中关于treatTime的plist中数组
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
- (void)treatModelPickerViewLoad:(CGRect )pickerViewCGRect{
    _treatModelPickerView = [[AKPickerView alloc] initWithFrame:pickerViewCGRect];
    [self pickerViewParameterLoad:_treatModelPickerView];
    //取出数据模型中关于treatModel的plist中数组
     _treatModelPickerViewArray = [_treatParameterItem.datafromTreatItemList objectForKey:@"treatModel"];
    [_treatModelPickerView reloadData];
}
- (void)pickerViewParameterLoad:(AKPickerView *)pickerView{
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:pickerView];
    
    pickerView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    pickerView.highlightedFont = [UIFont fontWithName:@"HelveticaNeue" size:18];
    pickerView.interitemSpacing = 15;
    pickerView.fisheyeFactor = 0.001;
    pickerView.pickerViewStyle = AKPickerViewStyle3D;
    pickerView.maskDisabled = false;
}

#pragma mark - AFPickerView 图片选择
- (UIImage *)pickerView:(AKPickerView *)pickerView imageForItem:(NSInteger)item{
    if([pickerView isEqual:_treatTimePickerView])
    {
        return [UIImage imageNamed:_treatTimePickerViewArray[item]];
    }
    
    else if([pickerView isEqual:_treatStrengthPickerView])
    {
        return [UIImage imageNamed:_treatStrengthPickerViewArray[item]];
    }
    
    else if([pickerView isEqual:_treatWavePickerView])
    {
        return [UIImage imageNamed:_treatWavePickerViewArray[item]];
    }
    
    else
    {
        return [UIImage imageNamed:_treatModelPickerViewArray[item]];
    }
}

#pragma mark - AFPickerView 选择的项目
- (NSUInteger)nnumberOfItemsInPickerView:(AKPickerView *)pickerView{
    if([pickerView isEqual:_treatTimePickerView])
    {
        
        NSString *treatTime = _treatParameterItem.treatTime ;
        NSString *treatTimeNumber = [treatTime substringWithRange:NSMakeRange(1, 1)];
        return [treatTimeNumber integerValue];
    }
    else if([pickerView isEqual:_treatStrengthPickerView])
    {
        NSString *treatStrength = _treatParameterItem.treatStrength ;
        NSString *treatStrengthNumber = [treatStrength substringWithRange:NSMakeRange(1, 1)];
        return [treatStrengthNumber integerValue];
    }
    else if([pickerView isEqual:_treatWavePickerView])
    {
        NSString *treatWave = _treatParameterItem.treatWave ;
        NSString *treatWaveNumber = [treatWave substringWithRange:NSMakeRange(1, 1)];
        return [treatWaveNumber integerValue];
    }
    else{
    NSString *treatModel = _treatParameterItem.treatModel;
    NSString *treatModelNumber = [treatModel substringWithRange:NSMakeRange(1, 1)];
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
            NSString *treatTimeSelectNumber = [treatTimeSelect substringWithRange:NSMakeRange(1, 1)];
            //字符串转化成整数
            NSInteger  setTime = [treatTimeSelectNumber integerValue];
            //设置计时时间
            if (setTime == 0) {
                [_timer setCountDownTime:1*60];
            }else{
                [_timer setCountDownTime:setTime*5*60];}
            //设置模型中treatTime的值，以便保存；
            _treatParameterItem.treatTime = treatTimeSelect;
            NSLog(@"Time_%@", _treatParameterItem.treatTime);
        }
        
        else if([pickerView isEqual:_treatStrengthPickerView])
        {
            //读取数组中的值设置时间，设置模型中treatStrength的值，以便保存
            _treatParameterItem.treatStrength = _treatStrengthPickerViewArray[item];
            
        }
        else if([pickerView isEqual:_treatWavePickerView])
        {
           //读取数组中的值设置时间，设置模型中treatWave的值，以便保存
            _treatParameterItem.treatWave = _treatWavePickerViewArray[item];

        }
        else
        {
            //读取数组中的值设置时间，设置模型中treatModel的值，以便保存
            _treatParameterItem.treatModel = _treatModelPickerViewArray[item];
        }
    
        
}

#pragma mark - 保存参数按钮
- (IBAction)saveTreatPamameterItem:(id)sender{
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
        [_saveTreatPamameterItem setEnabled:YES];
        //圆圈动画结束
        [self.spinnerView stopAnimating];
        
    }else{
        
        [_timer start];
        //圆圈动画开始
        [self.spinnerView startAnimating];
        [_startPauseBtn setTitle:@"暂停" forState:UIControlStateNormal];
        [_saveTreatPamameterItem setEnabled:NO];
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
    [_saveTreatPamameterItem setEnabled:YES];
    //提示用户结束治疗
    NSString *msg = @"您已经完成治疗";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [alertView show];
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
    [self scanClick];
    [_menu.myTableView reloadData];

    
}
- (void) loadSideViewData{
    
    if (1) {
        _batteryValue = 70.0;
        _menu.items =
        @[
          @{@"title":@"蓝牙已连接",@"imagename":@"70%",@"data":@"70% "},
          @{@"title":[NSString stringWithFormat:@"电池电量%d%%",(NSInteger)_batteryValue],@"imagename":@"70%",@"data":@"70%"},
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

#pragma mark - BlueTooth
-(void)updateLog:(NSString *)s{
    static unsigned int count = 0;
    NSLog(@"[ %d ]  %@\r\n",count,s);
//    [_textView setText:[NSString stringWithFormat:@"[ %d ]  %@\r\n%@",count,s,_textView.text]];
    count++;
}

//BlueTooth  扫描
-(void)scanClick{
    [self updateLog:@"正在扫描外设..."];
    //[_activity startAnimating];
    [_manager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    
    double delayInSeconds = 30.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.manager stopScan];
   //     [_activity stopAnimating];
        [self updateLog:@"扫描超时,停止扫描"];
    });
}

//BlueTooth  连接

-(void)connectClick:(id)sender{
    if (_cbReady ==false) {
        [self.manager connectPeripheral:_peripheral options:nil];
        _cbReady = true;
       // [_connect setTitle:@"断开" forState:UIControlStateNormal];
    }else {
        [self.manager cancelPeripheralConnection:_peripheral];
        _cbReady = false;
        //[_connect setTitle:@"连接" forState:UIControlStateNormal];
    }
}

//BlueTooth  报警
-(void)sendClick:(UIButton *)bu
{
    unsigned char data = 0x02;
    [_peripheral writeValue:[NSData dataWithBytes:&data length:1] forCharacteristic:_writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
}

#pragma mark -      -  BlueTooth  开始查看服务，蓝牙开启
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            [self updateLog:@"蓝牙已打开,请扫描外设"];
            break;
        default:
            break;
    }
}

#pragma mark -      -  BlueTooth  查到外设后，停止扫描，连接设备
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    [self updateLog:[NSString stringWithFormat:@"已发现 peripheral: %@ rssi: %@, UUID: %@ advertisementData: %@ ", peripheral, RSSI, peripheral.identifier, advertisementData]];
    _peripheral = peripheral;
    NSLog(@"%@",_peripheral);
    [self.manager stopScan];
    //[_activity stopAnimating];
    BOOL replace = NO;
    // Match if we have this device from before
    for (int i=0; i < _nDevices.count; i++) {
        CBPeripheral *p = [_nDevices objectAtIndex:i];
        if ([p isEqual:peripheral]) {
            [_nDevices replaceObjectAtIndex:i withObject:peripheral];
            replace = YES;
        }
    }
    if (!replace) {
        [_nDevices addObject:peripheral];
    //[_deviceTable reloadData];
    }
}

//BlueTooth  连接外设成功，开始发现服务
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    [self updateLog:[NSString stringWithFormat:@"成功连接 peripheral: %@ with UUID: %@",peripheral,peripheral.identifier]];
    
    [self.peripheral setDelegate:self];
    [self.peripheral discoverServices:nil];
    [self updateLog:@"扫描服务"];
    
}
// BlueTooth  连接外设失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%@",error);
}

-(void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    //NSLog(@"%s,%@",__PRETTY_FUNCTION__,peripheral);
    int rssi = abs([peripheral.RSSI intValue]);
    CGFloat ci = (rssi - 49) / (10 * 4.);
    NSString *length = [NSString stringWithFormat:@"发现BLT4.0热点:%@,距离:%.1fm",_peripheral,pow(10,ci)];
    NSLog(@"距离：%@",length);
}
#pragma mark -      -  BlueTooth  已发现服务
-(void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    
    [self updateLog:@"发现服务."];
    int i=0;
    for (CBService *s in peripheral.services) {
        [self.nServices addObject:s];
    }
    for (CBService *s in peripheral.services) {
        [self updateLog:[NSString stringWithFormat:@"%d :服务 UUID: %@(%@)",i,s.UUID.data,s.UUID]];
        i++;
        [peripheral discoverCharacteristics:nil forService:s];
    }
}

#pragma mark -      -  BlueTooth  已搜索到Characteristics
-(void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    [self updateLog:[NSString stringWithFormat:@"发现特征的服务:%@ (%@)",service.UUID.data ,service.UUID]];
    
    for (CBCharacteristic *c in service.characteristics) {
        [self updateLog:[NSString stringWithFormat:@"特征 UUID: %@ (%@)",c.UUID.data,c.UUID]];
        
        if ([c.UUID isEqual:[CBUUID UUIDWithString:@"2A06"]]) {
            _writeCharacteristic = c;
        }
        if ([c.UUID isEqual:[CBUUID UUIDWithString:@"2A19"]]) {
            [_peripheral readValueForCharacteristic:c];
        }
        
        if ([c.UUID isEqual:[CBUUID UUIDWithString:@"FFA1"]]) {
            [_peripheral readRSSI];
        }
        [_nCharacteristics addObject:c];
    }
}


#pragma mark -      -  BlueTooth  获取外设发来的数据，不论是read和notify。
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    // BOOL isSaveSuccess;
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A19"]]) {
        NSString *value = [[NSString alloc]initWithData:characteristic.value encoding:NSUTF8StringEncoding];
        _batteryValue = [value floatValue];
        NSLog(@"电量%f",_batteryValue);
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFA1"]]) {
        NSString *value = [[NSString alloc]initWithData:characteristic.value encoding:NSUTF8StringEncoding];
        //_batteryValue = [value floatValue];
        NSLog(@"信号%@",value);
    }
    
    else
        NSLog(@"didUpdateValueForCharacteristic%@",[[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding]);
}

//将视频保存到目录文件夹下
-(BOOL)saveToDocument:(NSData *) data withFilePath:(NSString *) filePath
{
    if ((data == nil) || (filePath == nil) || [filePath isEqualToString:@""]) {
        return NO;
    }
    @try {
        //将视频写入指定路径
        [data writeToFile:filePath atomically:YES];
        return  YES;
    }
    @catch (NSException *exception) {
        NSLog(@"保存失败");
    }
    return NO;
}

//根据当前时间将视频保存到VideoFile文件夹中
-(NSString *)imageSavedPath:(NSString *) VideoName
{
    //获取Documents文件夹目录
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    //获取文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //指定新建文件夹路径
    NSString *videoDocPath = [documentPath stringByAppendingPathComponent:@"VideoFile"];
    //创建VideoFile文件夹
    [fileManager createDirectoryAtPath:videoDocPath withIntermediateDirectories:YES attributes:nil error:nil];
    //返回保存图片的路径（图片保存在VideoFile文件夹下）
    NSString * VideoPath = [videoDocPath stringByAppendingPathComponent:VideoName];
    return VideoPath;
}

//中心读取外设实时数据
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
    }
    // Notification has started
    if (characteristic.isNotifying) {
        [peripheral readValueForCharacteristic:characteristic];
        
    } else { // Notification has stopped
        // so disconnect from the peripheral
        NSLog(@"Notification stopped on %@.  Disconnecting", characteristic);
        [self.manager cancelPeripheralConnection:self.peripheral];
    }
}
//用于检测中心向外设写数据是否成功
-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"=======%@",error.userInfo);
    }else{
        NSLog(@"发送数据成功");
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
         YFPamameterItemTableViewController *yfAddToDo = [segue destinationViewController];
         yfAddToDo.delegate = self;
     
     
     
 }
@end
