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

@property (nonatomic, strong) AKPickerView *treatTimePickerView;
@property (nonatomic, strong) AKPickerView *treatStregthPickerView;
@property (nonatomic, strong) AKPickerView *treatWavePickerView;
@property (nonatomic, strong) AKPickerView *treatModelPickerView;

@property (nonatomic, strong) NSArray *treatTimePickerViewArray;
@property (nonatomic, strong) NSArray *treatStregthPickerViewArray;
@property (nonatomic, strong) NSArray *treatWavePickerViewArray;
@property (nonatomic, strong) NSArray *treatModelPickerViewArray;

@property (nonatomic, strong) YFTreatParameterItem *defaultTreatItem;
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
//    初始化治疗参数
    _defaultTreatItem = [[YFTreatParameterItem alloc] init];
    
//    初始化pickerView
    [self treatTimePickerViewLoad];
    [self treatStregthPickerViewLoad];
    [self treatWavePickerViewLoad];
    [self treatModelPickerViewLoad];
    
//  设置navigationBar 左侧栏的名称
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"状态" style:UIBarButtonItemStyleBordered                                                                            target:self                                                                            action:@selector(switchTouched)];
    
//  设置倒计时 时间 按钮
    timer = [[MZTimerLabel alloc] initWithLabel:_timerCountDownLabel andTimerType:MZTimerLabelTypeTimer];
    [timer setCountDownTime:60];
    [_resetBtn setEnabled:NO];

//  设置sideView
    _sideSlipView = [[JKSideSlipView alloc]initWithSender:self withTreatItem:_defaultTreatItem withBlueToothStatus:NO withPowerStatus:50];
    _sideSlipView.backgroundColor = [UIColor redColor];
    
  //  [_sideSlipView setContentView:menu];
    [self.view addSubview:_sideSlipView];
    
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AKPickerViewDataSource

- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView
{

    if([pickerView isEqual:_treatTimePickerView])
    {
        return [_treatTimePickerViewArray count];
    }
    
    else if([pickerView isEqual:_treatStregthPickerView])
    {
        return [_treatStregthPickerViewArray count];
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
- (void)treatTimePickerViewLoad{
    _treatTimePickerView = [[AKPickerView alloc] initWithFrame:CGRectMake(70, 60, 200, 60)];
    
    [self pickerViewParameterLoad:_treatTimePickerView];
    
    _treatTimePickerViewArray = @[@"1分钟",@"5分钟",@"10分钟",@"15分钟",@"20分钟",];
    [_treatTimePickerView reloadData];
}
- (void)treatStregthPickerViewLoad{
    _treatStregthPickerView = [[AKPickerView alloc] initWithFrame:CGRectMake(70, 118, 200, 60)];
    
    [self pickerViewParameterLoad:_treatStregthPickerView];
    
    _treatStregthPickerViewArray = @[@"M1",@"M2", @"M3",@"M4",];
    [_treatStregthPickerView reloadData];
}
- (void)treatWavePickerViewLoad{
    _treatWavePickerView = [[AKPickerView alloc] initWithFrame:CGRectMake(70, 175, 200, 60)];
    //self.view.bounds
    [self pickerViewParameterLoad:_treatWavePickerView];
    _treatWavePickerViewArray = @[@"Chiba", @"Tokyo",@"Osaka",@"Aichi",];
    
    
    [_treatWavePickerView reloadData];
}
- (void)treatModelPickerViewLoad{
    _treatModelPickerView = [[AKPickerView alloc] initWithFrame:CGRectMake(70, 228, 200, 60)];
    [self pickerViewParameterLoad:_treatModelPickerView];
     _treatModelPickerViewArray = @[@"左侧",@"右侧",@"两侧",];
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
    
    else if([pickerView isEqual:_treatStregthPickerView])
    {
        return _treatStregthPickerViewArray[item];
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
- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item
{
    
        if([pickerView isEqual:_treatTimePickerView])
        {
            //设置时间
            NSInteger  setTime = item*5*60;
            if (setTime == 0) {
                setTime =1*60;
            }
            [timer setCountDownTime:setTime];
            self.defaultTreatItem.treatTime = [NSString stringWithFormat:@"%d", setTime];
            NSLog(@"Time_%@", _defaultTreatItem.treatTime);
        }
        
        else if([pickerView isEqual:_treatStregthPickerView])
        {
            self.defaultTreatItem.treatStrength = _treatStregthPickerViewArray[item];
            NSLog(@"Stregth_%@",_treatStregthPickerViewArray[item]);
        }
        else if([pickerView isEqual:_treatWavePickerView])
        {
            self.defaultTreatItem.treatWave = _treatWavePickerViewArray[item];
            NSLog(@"Wave_%@",_treatWavePickerViewArray[item]);
        }
        else
        {
            self.defaultTreatItem.treatModel = _treatModelPickerViewArray[item];
            NSLog(@"Model_%@",_treatModelPickerViewArray[item]);
        }
    
        
}


#pragma mark - 保存参数按钮
- (IBAction)saveTreatPamameterItem:(id)sender{
    NSString *string1 = [NSString stringWithFormat:@"%@-%@-%@-%@",_defaultTreatItem.treatTime,_defaultTreatItem.treatStrength,_defaultTreatItem.treatWave,_defaultTreatItem.treatModel];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:string1 delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
    [myAlertView show];
    [_sideSlipView reloadTreatItem:_defaultTreatItem withBlueToothStatus:YES withPowerStatus:40];
    
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
