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
//
//    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44,768, 1004)];
   _scrollView.directionalLockEnabled = YES; //只能一个方向滑动
    _scrollView.pagingEnabled = NO; //是否翻页
//    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.showsVerticalScrollIndicator =YES; //垂直方向的滚动指示
    _scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
    _scrollView.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
    _scrollView.delegate = self;
    CGSize newSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+70);
    [_scrollView setContentSize:newSize];
//    [self.view addSubview:_scrollView];
    
//  初始化治疗参数
    _treatParameterItem = [[YFTreatParameterItem alloc] initWithIndex:2];
    NSLog(@"%@", _treatParameterItem.datafromTreatItem);
//   初始化pickerView
//   第一个pickview X轴xPickerView,y轴yPickerView,y轴增加值xAddPickerView
     NSInteger xPickerView = 70,yPickerView = 150,yAddPickerView = 50;
    [self treatTimePickerViewLoad:CGRectMake(xPickerView, yPickerView, 200, 60)];
    [self treatStrengthPickerViewLoad:CGRectMake(xPickerView,(yPickerView+yAddPickerView) , 200, 60)];
    [self treatWavePickerViewLoad:CGRectMake(xPickerView, (yPickerView+2*yAddPickerView), 200, 60)];
    [self treatModelPickerViewLoad:CGRectMake(xPickerView,(yPickerView+3*yAddPickerView), 200, 60)];
    [self pickerView:_treatTimePickerView didSelectItem:2];
    [_treatTimePickerView selectItem:2 animated:NO];
    [_treatStrengthPickerView selectItem:2 animated:NO];
    [_treatWavePickerView selectItem:2 animated:NO];
    [_treatModelPickerView selectItem:2 animated:NO];
//  设置navigationBar 左侧栏的名称以及按键调用的方法
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"状态" style:UIBarButtonItemStyleBordered                                                                            target:self                                                                            action:@selector(switchTouched)];
    
//  设置MZTimerLabel倒计时  按钮
    _timer = [[MZTimerLabel alloc] initWithLabel:_timerCountDownLabel andTimerType:MZTimerLabelTypeTimer];
    [_timer setCountDownTime:60];
    [_resetBtn setEnabled:NO];
    _timer.resetTimerAfterFinish = YES;
    _timer.delegate = self;
    _timer.timeFormat = @"mm:ss";


  
 
//// 设置代理与ViewController
    YFRecordTVC *yfRecordTVC = [[YFRecordTVC alloc] init];
    yfRecordTVC.delegate = self;

//    YFPamameterItemTableViewController *parameterItemTVC = [[YFPamameterItemTableViewController alloc] init];
//    parameterItemTVC.delegate = self;
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    areaDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    [self loadAreaDicWithCGRect:CGRectMake(20, 407, 320, 136)];
    
    //  设置sideView
    _sideSlipView = [[JKSideSlipView alloc] initWithSender:self];
    _sideSlipView = [[JKSideSlipView alloc]initWithSender:self];
    _sideSlipView.backgroundColor = [UIColor redColor];
    
    MenuView *menu = [MenuView menuView];
//    [menu didSelectRowAtIndexPath:^(id cell, NSIndexPath *indexPath) {
//        NSLog(@"click");
//        [_sideSlipView hide];
////        NextViewController *next = [[NextViewController alloc]init];
////        [self.navigationController pushViewController:next animated:YES];
//    }];
    menu.items = @[@{@"title":@"蓝牙已连接",@"imagename":@"电池电量"},@{@"title":@"预设时间",@"imagename":@"2"},@{@"title":@"强度",@"imagename":@"3"},@{@"title":@"波形",@"imagename":@"4"},@{@"title":@"电极",@"imagename":@"5"}];
    [_sideSlipView setContentView:menu];
    [self.view addSubview:_sideSlipView];
    
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
-(void)setUpBgScrollView
{
   
    
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
//        comBox.
//        if (i==1) {
//            
//           
//            
//        } else if (i ==2){
//            
//            
//        };
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

#pragma mark -LMComBoxViewDelegate
-(void)selectAtIndex:(int)index inCombox:(LMComBoxView *)_combox
{
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

- (void)sendSelectedItemToHomeVC:(NSInteger)item{
    // 选中的列表第几个值后，重新赋值给_YFTreatItem;
}

- (NSArray *)getArrayHomeVC{
    
  //  self.delegate.tableViewArray = self.treatParameterItem.datafromTreatItem;
    return _treatParameterItem.datafromTreatItem;
}

#pragma mark -YFRecordTVC Delegate
- (NSArray *)ArrayToRecordTVC{
    return  _treatParameterItem.datafromTreatHistory;
}

#pragma mark - 跳转链接segue
-(IBAction)unwind:(UIStoryboardSegue *) segue{
    
}

#pragma mark - AKPickerView DataSource

- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView
{

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
    _treatTimePickerView = [[AKPickerView alloc] initWithFrame:pickerViewCGRect];
    
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
    pickerView.pickerViewStyle = AKPickerViewStyleFlat;
    pickerView.maskDisabled = false;
}

#pragma mark - pickerView 图片选择

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
    else if([pickerView isEqual:_treatWavePickerView])
    {
        return _treatWavePickerViewArray[item];
    }
    else
    {
        return _treatModelPickerViewArray[item];
    }
    
    
}

//- (UIImage *)pickerView:(AKPickerView *)pickerView imageForItem:(NSInteger)item
//{
//    
//    return [UIImage imageNamed:_treatWavePickerViewArray[item]];
//}
#pragma mark - pickerView 选择的项目

- (NSUInteger)nnumberOfItemsInPickerView:(AKPickerView *)pickerView{
    if([pickerView isEqual:_treatTimePickerView])
    {
        return 2;
    }
    else if([pickerView isEqual:_treatStrengthPickerView])
    {   return 2;
    }
    else if([pickerView isEqual:_treatWavePickerView])
    {   return 3;
    }
    else
        return 3;
}

//用pickerView 选出的treatItem 参数
- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item
{
    
        if([pickerView isEqual:_treatTimePickerView])
        {
            //读取数组中的值设置时间
            NSString *treatTimeSelect =_treatTimePickerViewArray[item];
            //字符串转化成整数
            NSInteger  setTime = [treatTimeSelect integerValue];
            //设置计时时间
            [_timer setCountDownTime:setTime*2];
            //设置模型中treatTime的值，以便保存；
            _treatParameterItem.treatTime = treatTimeSelect;
            NSLog(@"Time_%@", _treatParameterItem.treatTime);
        }
        
        else if([pickerView isEqual:_treatStrengthPickerView])
        {
            //读取数组中的值设置时间，设置模型中treatStrength的值，以便保存
            _treatParameterItem.treatTime = _treatStrengthPickerViewArray[item];
            NSLog(@"Time_%@", _treatParameterItem.treatTime);
        }
        else if([pickerView isEqual:_treatWavePickerView])
        {
           //读取数组中的值设置时间，设置模型中treatWave的值，以便保存
            _treatParameterItem.treatWave = _treatWavePickerViewArray[item];
            NSLog(@"Time_%@",_treatParameterItem.treatWave);

        }
        else
        {
            //读取数组中的值设置时间，设置模型中treatModel的值，以便保存
            _treatParameterItem.treatModel = _treatModelPickerViewArray[item];
            NSLog(@"Time_%@",_treatParameterItem.treatModel);
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
                                        } otherButtonBlock:^(NSString * result){
                                        
                                            [self saveTreatItemToListWithName:result];
                                            
                                            
                                        }];
    
    //You can make any customization to the native UIAlertView
    self.stAlertView.alertView.alertViewStyle =UIAlertViewStylePlainTextInput;
    [[self.stAlertView.alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    
    [self.stAlertView show];
    
}
//    保存的参数形成字典加入到治疗参数列表中，并存储到plist中
- (void) saveTreatItemToListWithName:(NSString *)name{
    if (name == nil) {

    }
    else{
        NSDictionary *newDic = @{@"treatName":name,
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
//        NSLog(@"applist %@", applist);
        
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
        
    }else{
        
        [_timer start];
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
//    [_sideSlipView reloadTreatItem:_treatParameterItem withBlueToothStatus:YES withPowerStatus:50]  ;
    
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
