//
//  YFHomeViewController.m
//  YF002
//
//  Created by Mushroom on 5/20/15.
//  Copyright (c) 2015 Mushroom. All rights reserved.
//

#import "YFHomeViewController.h"
#import "YFTreatParameterItem.h"

#import "AKPickerView.h"
#import "MZTimerLabel.h"
#import "JKSideSlipView.h"

@interface YFHomeViewController () <AKPickerViewDataSource,AKPickerViewDelegate>{
    MZTimerLabel *timer;
    JKSideSlipView *_sideSlipView;
}




@property(copy,nonatomic)void (^transTreatItemToTableView)(YFTreatParameterItem *treatParaMeter);
//其中void为返回值的类型
//1：需要传值的类中.h文件中进行声明block方法：，记住是copy;
//
//2：在该类.m文件中进行判断指针不为空即可

if (self.transTreatItemToTableView) {

self.transTreatItemToTableView(_treatParameterItem);

};
//3：接受传值的类中接收
//
//传值类对象.声明block的名称=^(传值的类型传值的变量名){
//    
//    接受传值=传值变量名；
//    
//}；
@property (nonatomic, strong) AKPickerView *treatTimePickerView;
@property (nonatomic, strong) AKPickerView *treatStrengthPickerView;
@property (nonatomic, strong) AKPickerView *treatWavePickerView;
@property (nonatomic, strong) AKPickerView *treatModelPickerView;

@property (nonatomic, strong) NSArray *treatTimePickerViewArray;
@property (nonatomic, strong) NSArray *treatStrengthPickerViewArray;
@property (nonatomic, strong) NSArray *treatWavePickerViewArray;
@property (nonatomic, strong) NSArray *treatModelPickerViewArray;

@property (nonatomic, strong) YFTreatParameterItem *treatParameterItem;
//@property (nonatomic,strong) UIView *aview;


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
//  初始化治疗参数
    _treatParameterItem = [[YFTreatParameterItem alloc] init];
    
//   初始化pickerView
//   第一个pickview X轴xPickerView,y轴yPickerView,y轴增加值xAddPickerView
     NSInteger xPickerView = 70,yPickerView = 60,yAddPickerView = 57;
    [self treatTimePickerViewLoad:CGRectMake(xPickerView, yPickerView, 200, 60)];
    [self treatStrengthPickerViewLoad:CGRectMake(xPickerView,(yPickerView+yAddPickerView) , 200, 60)];
    [self treatWavePickerViewLoad:CGRectMake(xPickerView, (yPickerView+2*yAddPickerView), 200, 60)];
    [self treatModelPickerViewLoad:CGRectMake(xPickerView,(yPickerView+3*yAddPickerView), 200, 60)];
    
//  设置navigationBar 左侧栏的名称
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"状态" style:UIBarButtonItemStyleBordered                                                                            target:self                                                                            action:@selector(switchTouched)];
    
//  设置倒计时 时间 按钮
    timer = [[MZTimerLabel alloc] initWithLabel:_timerCountDownLabel andTimerType:MZTimerLabelTypeTimer];
    [timer setCountDownTime:60];
    [_resetBtn setEnabled:NO];

//  设置sideView
    _sideSlipView = [[JKSideSlipView alloc]initWithSender:self withTreatItem:_treatParameterItem withBlueToothStatus:NO withPowerStatus:50];
   
    [self.view addSubview:_sideSlipView];
    
    
   
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(IBAction)unwind:(UIStoryboardSegue *) segue{
    
}

#pragma mark - AKPickerViewDataSource

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


- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item
{
    
        if([pickerView isEqual:_treatTimePickerView])
        {
            //读取数组中的值设置时间
            NSString *treatTimeSelect =_treatTimePickerViewArray[item];
            //字符串转化成整数
            NSInteger  setTime = [treatTimeSelect integerValue];
            //设置计时时间
            [timer setCountDownTime:setTime*60];
            //设置模型中treatTime的值，以便保存；
            _treatParameterItem.treatTime = treatTimeSelect;
            NSLog(@"Time_%@", _treatParameterItem.treatTime);
        }
        
        else if([pickerView isEqual:_treatStrengthPickerView])
        {
            //读取数组中的值设置时间，设置模型中treatStrength的值，以便保存
            _treatParameterItem.treatTime = _treatStrengthPickerViewArray[item];
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
    NSString *string1 = [NSString stringWithFormat:@"%@-%@-%@-%@",_treatParameterItem.treatTime,_treatParameterItem.treatStrength,_treatParameterItem.treatWave,_treatParameterItem.treatModel];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:string1 delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
    [myAlertView show];
    [_sideSlipView reloadTreatItem:_treatParameterItem withBlueToothStatus:YES withPowerStatus:40];
    
}
#pragma mark - MZTimerlabel 开始 暂停 重置按钮的方法
- (IBAction)startOrResumeCountDown:(id)sender {
    
    if([timer counting]){
        [timer pause];
        
        [_startPauseBtn setTitle:@"继续" forState:UIControlStateNormal];
        
        [_resetBtn setEnabled:YES];
        [_saveTreatPamameterItem setEnabled:YES];
        
    }else{
        
        [timer start];
        [_startPauseBtn setTitle:@"暂停" forState:UIControlStateNormal];
        [_saveTreatPamameterItem setEnabled:NO];
    }
    
}

- (IBAction)resetCountDown:(id)sender {
    [timer reset];
    
    if(![timer counting]){
        [_startPauseBtn setTitle:@"开始" forState:UIControlStateNormal];
    }
     [_resetBtn setEnabled:NO];
}

#pragma mark - sideView 按钮方法
- (void)switchTouched{
    [_sideSlipView switchMenu];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
