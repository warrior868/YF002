


#import "YFAlarmTVC.h"


#define sreenWidth [UIScreen mainScreen].bounds.size.width
#define srennHeight [UIScreen mainScreen].bounds.size.height
@interface YFAlarmTVC ()<UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate>

#pragma mark - IBActions


@property (weak, nonatomic) IBOutlet UIToolbar *toolbarCancelDone;
@property (weak, nonatomic) IBOutlet UIPickerView *customPicker;


@property (nonatomic ,strong) NSMutableArray *timeArray;
@property (nonatomic ,strong) NSMutableArray *onOrOffArray;


#pragma mark - IBActions

- (IBAction)actionCancel:(id)sender;

- (IBAction)actionDone:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation YFAlarmTVC
{
    
    
    NSArray *amPmArray;
    NSArray *hoursArray;
    NSMutableArray *minutesArray;
    BOOL firstTimeLoad;
    NSMutableString *selectTime;
    
    NSInteger textFieldTag;
    NSInteger tagNumber;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
        // set tableView delegate.
    _tableView.delegate = self;
    _tableView.dataSource = self;
    tagNumber = 1;
    
    //_customPicker.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>);
    
        
    //读取userDefault中alarmDicList的值
    NSMutableArray *alarmList = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"alarmList"];
    
    if (alarmList == nil) {
        NSArray *time = [NSArray arrayWithObjects:@"06:30", @"11:30",@"16:30",@"00:00",nil];
        NSArray *onOrOff = [NSArray arrayWithObjects:@"on", @"off",@"off",@"on",nil];
        alarmList= [NSMutableArray arrayWithObjects:time,onOrOff, nil];
        [[NSUserDefaults standardUserDefaults] setObject:alarmList forKey:@"alarmList"];
    }
    
    _timeArray = [[alarmList objectAtIndex:0] mutableCopy];
    _onOrOffArray = [[alarmList objectAtIndex:1] mutableCopy];
    
    firstTimeLoad = YES;
    self.customPicker.hidden = YES;
    self.toolbarCancelDone.hidden = YES;
    
    //NSDate *date = [NSDate date];
    
    // Get Current Year
    
    //NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //[formatter setDateFormat:@"yyyy"];
    
    // Get Current  Hour
    //[formatter setDateFormat:@"hh"];
    //NSString *currentHourString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    // Get Current  Minutes
    //[formatter setDateFormat:@"mm"];
   // NSString *currentMinutesString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    

    // PickerView -  Hours data
    hoursArray = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"];
    // PickerView -  Hours data
    
    minutesArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 60; i++)
    {
        
        [minutesArray addObject:[NSString stringWithFormat:@"%02d",i]];
        
    }

    
    [self.customPicker selectRow:[hoursArray indexOfObject:@"12"] inComponent:0 animated:YES];
    
    [self.customPicker selectRow:[minutesArray indexOfObject:@"30"] inComponent:1 animated:YES];
  
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


#pragma mark - UIPickerViewDelegate


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{      selectTime = [[NSString stringWithFormat:@"%@:%@ ",[hoursArray objectAtIndex:[self.customPicker selectedRowInComponent:0]],[minutesArray objectAtIndex:[self.customPicker selectedRowInComponent:1]]] mutableCopy];
    NSLog(@"time is %@",selectTime);
    
}


#pragma mark - UIPickerViewDatasource

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    
    // Custom View created for each component
    
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 50, 60);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:15.0f]];
    }
    
    
    
    if (component == 0)
    {
        pickerLabel.text =  [hoursArray objectAtIndex:row]; // Hours
    }
    else
    {
        pickerLabel.text =  [minutesArray objectAtIndex:row]; // Mins
    }
    return pickerLabel;
    
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 2;
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (component == 0)
    { // hour
        
        return 23;
        
    }
    else
    { // min
        return 60;
    }
    
    
    
}






- (IBAction)actionCancel:(id)sender
{
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.customPicker.hidden = YES;
                         self.toolbarCancelDone.hidden = YES;
                         
                         
                     }
                     completion:^(BOOL finished){
                         
                         
                     }];
    
    
}

- (IBAction)actionDone:(id)sender
{
    //更新数据数据
    NSInteger fieldTag=textFieldTag/10 -1;
    [_timeArray replaceObjectAtIndex:fieldTag withObject:selectTime ];
    tagNumber=1;
    //通过tag找到对应textfield，改变其参数
     UITextField *textField = (UITextField *)[self.view viewWithTag:(textFieldTag)];
    textField.text =selectTime;
    
     [self.tableView reloadData];
   
    //存储当前闹钟数据
    NSArray *alarmList= [NSArray arrayWithObjects:_timeArray,_onOrOffArray, nil];
    [[NSUserDefaults standardUserDefaults] setObject:alarmList forKey:@"alarmList"];
    
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.customPicker.hidden = YES;
                         self.toolbarCancelDone.hidden = YES;
                         
                         
                     }
                     completion:^(BOOL finished){
                         
                         
                     }];
    
    
    
}
#pragma mark 闹钟开关
-(void)switchAction:(id)sender{
    UITableViewCell * cell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    NSLog(@"点了我 %ld", (long)([path row]+1)*10);
    
    if ([[_onOrOffArray objectAtIndex:[path row]] isEqualToString:@"on"]) {
        [_onOrOffArray replaceObjectAtIndex:[path row] withObject:@"off"];
        
        UITextField *textField = (UITextField *)[self.view viewWithTag:(([path row]+1)*10)];
        textField.textColor =[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
        //存储当前闹钟数据
        NSArray *alarmList= [NSArray arrayWithObjects:_timeArray,_onOrOffArray, nil];
        [[NSUserDefaults standardUserDefaults] setObject:alarmList forKey:@"alarmList"];
        [self.tableView reloadData];
    }else{
        [_onOrOffArray replaceObjectAtIndex:[path row] withObject:@"on"];
        
        UITextField *textField = (UITextField *)[self.view viewWithTag:(([path row]+1)*10)];
        textField.textColor =[UIColor colorWithRed:116.0/255 green:201.0/255 blue:184.0/255 alpha:1.0];;
        //存储当前闹钟数据
        NSArray *alarmList= [NSArray arrayWithObjects:_timeArray,_onOrOffArray, nil];
        [[NSUserDefaults standardUserDefaults] setObject:alarmList forKey:@"alarmList"];
        [self.tableView reloadData];
    }
    
}

#pragma mark - Table view data source
#pragma mark tableview中cell的高度

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 60;
    
    
};


#pragma mark tableview中增加闹钟
-(void)addNewAlarmBtn{
    
    [_timeArray insertObject:@"12:30" atIndex:_timeArray.count];
    [_onOrOffArray insertObject:@"off" atIndex:_onOrOffArray.count];
    //存储当前闹钟数据
    NSArray *alarmList= [NSArray arrayWithObjects:_timeArray,_onOrOffArray, nil];
    [[NSUserDefaults standardUserDefaults] setObject:alarmList forKey:@"alarmList"];

    
    [self.tableView reloadData ];
}


#pragma mark tableview中section的数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark tableview中每个section中cell数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return _timeArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50;
}


#pragma mark tableview 中的footerView
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    //UIButton 新增按钮的创建
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0, 10, 120,40);
    button.backgroundColor = [UIColor colorWithRed:116.0/255 green:201.0/255 blue:184.0/255 alpha:1.0];
    [button addTarget:self action:@selector(addNewAlarmBtn) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor colorWithRed:187.0/255 green:135.0/255 blue:87.0/255 alpha:1.0] forState:UIControlStateNormal];
    [button setTitle:@"新增处方" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    button.layer.cornerRadius = 5.0;
    
    UIView *footerView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, sreenWidth, 60)];
    [footerView addSubview:button];
    button.center = footerView.center;
    return footerView;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_timeArray removeObjectAtIndex:indexPath.row];
        [_onOrOffArray removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //存储当前闹钟数据
        NSArray *alarmList= [NSArray arrayWithObjects:_timeArray,_onOrOffArray, nil];
        [[NSUserDefaults standardUserDefaults] setObject:alarmList forKey:@"alarmList"];
        
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *SimpleTableIdentifier=@"weekName";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    //如果行元素为空的话 则新建一行
    if(cell==nil){
        cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier
                    ];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sreenWidth, 60)];
        cellView.backgroundColor = [UIColor clearColor];
        [cell addSubview:cellView];
        
        
        //UITextField 的创建
        UITextField *time = [[UITextField alloc] initWithFrame:CGRectMake(60,20, 90, 40)];   //声明并指定其位置和长宽
        time.text = [_timeArray objectAtIndex:indexPath.row ];
        time.textColor = [UIColor colorWithRed:116.0/255 green:201.0/255 blue:184.0/255 alpha:1.0];;
        time.tag=([indexPath row]+1)*10;
        time.delegate=self;
        time.font = [UIFont fontWithName:@"Helvetica-Bold" size:28];
        [cellView addSubview:time];
        time.center = CGPointMake(sreenWidth/2, cellView.frame.size.height/2);
        //UISwitch 的创建
        UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(280, 20, 40, 10)];
        if ([[_onOrOffArray objectAtIndex:indexPath.row] isEqualToString:@"on"]) {
            [switchButton setOn:YES];
        }else{
            [switchButton setOn:NO];
            time.textColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
            
        }
        
        [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [cellView addSubview:switchButton];
        //开关颜色
        switchButton.onTintColor =[UIColor colorWithRed:116.0/255 green:201.0/255 blue:184.0/255 alpha:1.0];
        switchButton.center = CGPointMake(sreenWidth/2+120, cellView.frame.size.height/2);
        
        
        
        //UIImage 的创建
        UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(30,10, 30, 30)];
        cellImage.image=[UIImage imageNamed:@"clockicon"] ;
        [cellView addSubview:cellImage];
        cellImage.center = CGPointMake(sreenWidth/2-120, cellView.frame.size.height/2);
        
      }
   
    
    

        return cell;
    
    
    
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.view endEditing:YES];
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
//    [UIView animateWithDuration:0.5
//                          delay:0.1
//                        options: UIViewAnimationOptionCurveEaseIn
//                     animations:^{
//                         
//                         self.customPicker.hidden = NO;
//                         self.toolbarCancelDone.hidden = NO;
//                         
//                     }
//                     completion:^(BOOL finished){
//                         
//                     }];
    
    
    self.customPicker.hidden = NO;
    self.toolbarCancelDone.hidden = NO;
    
    NSLog(@"textField tag is %ld", (long)textField.tag);
    if (tagNumber ==1) {
         textFieldTag = textField.tag;
        tagNumber =2;
    }
   
    
    
    return YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return  YES;
    
}




@end
