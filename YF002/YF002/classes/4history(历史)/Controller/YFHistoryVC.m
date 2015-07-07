//
//  YFHistoryVC.m
//  YF002
//
//  Created by Mushroom on 5/31/15.
//  Copyright (c) 2015 Mushroom. All rights reserved.
//

#import "YFHistoryVC.h"

#import "LMComBoxView.h"
#import "LMContainsLMComboxScrollView.h"


#define kDropDownListTag 1000



@interface YFHistoryVC ()  <LMComBoxViewDelegate,SliderSwitchDelegate,UIScrollViewDelegate>
{
    LMContainsLMComboxScrollView *bgScrollView;
    NSMutableDictionary *addressDict;   //地址选择字典
    NSMutableDictionary *areaDic;
    NSArray *province;
    NSArray *city;
    NSArray *district;
    
    NSString *selectedProvince;
    NSString *selectedCity;
    NSString *selectedArea;
    
    UISegmentedControl *segmentControl;
    chatView *chat;
    UIView *dayView;
    UIView *dateView;
    UILabel *dateLab;
    int goY;
    int goW;
    int goM;
}

@end

@implementation YFHistoryVC

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
    _scrollView.backgroundColor = [UIColor whiteColor];
    CGSize newSize = CGSizeMake(self.view.frame.size.width, 600);
    [_scrollView setContentSize:newSize];
    
    
    //读取plist,生成第一级别的dictionary
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:@"treatHistory.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath =  [[NSBundle mainBundle] pathForResource:@"treatHistory" ofType:@"plist"];
    }
    _recordArray = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];

    
    //配置分段开关
    segmentControl = [[UISegmentedControl alloc]initWithFrame:CGRectMake(15, 5, 290, 30)];
    [segmentControl insertSegmentWithTitle:@"周" atIndex:0 animated:YES];
    [segmentControl insertSegmentWithTitle:@"月" atIndex:1 animated:YES];
    [segmentControl insertSegmentWithTitle:@"年" atIndex:2 animated:YES];
    [segmentControl setSelectedSegmentIndex:0];
    
    [segmentControl setTintColor: [UIColor colorWithRed:1.0/255 green:176.0/255 blue:1.0/255 alpha:1.0]];
    [segmentControl setAlpha:0.8f];
    [segmentControl setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
    [self.scrollView addSubview:segmentControl];
    
    [segmentControl addTarget:self action:@selector(controlPress:) forControlEvents:UIControlEventValueChanged];
    [self controlPressOne];

    
    //配置下拉列表
    NSString *plistPath1 = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    areaDic = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath1];
    //[areaDic removeObjectForKey:@"0"];
    [self loadAreaDicWithCGRect:CGRectMake(40, 360, 320, 130)];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)switchChangedSliderSwitch:(SliderSwitch *)sliderSwitch{
    
}
#pragma mark -LMComBoxViewDelegate
//didViewLoad 中加载
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
    [self.scrollView addSubview:bgScrollView];
    
    [self setUpBgScrollView];
   
}

-(void)setUpBgScrollView
{
    
    
    NSArray *keys = [NSArray arrayWithObjects:@"province",@"city",@"area", nil];
    for(NSInteger i=0;i<2;i++)
    {
        NSInteger x = 40+(60)*i  ;
        NSInteger xWidth =  115;
        if (i==1) {x = 155 ;
            xWidth = 85 ;} else if (i ==2){
            x =  240 ;
            xWidth =  40;};
        LMComBoxView *comBox = [[LMComBoxView alloc]initWithFrame:CGRectMake(x, 0, xWidth, 27)];
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
    NSLog(@"===%@===%@===%@",selectedProvince,selectedCity,selectedArea);
    
}
#pragma mark -  设置表格
- (void)initDateView
{
    if(!dateView){
        dateView = [[UIView alloc]initWithFrame:CGRectMake(segmentControl.frame.origin.x+segmentControl.frame.origin.x-20, segmentControl.frame.origin.y+segmentControl.frame.size.height+8, 290, 35)];
        dateView.opaque = NO;
        [self.view addSubview:dateView];
        //中间日期显示初始化
        dateLab = [[UILabel alloc]initWithFrame:CGRectMake(segmentControl.frame.origin.x+segmentControl.frame.origin.x+20, 7, dateView.frame.size.width-100, 25)];
        [dateLab setBackgroundColor:[UIColor clearColor]];
        [dateLab setTextColor:[UIColor colorWithRed:150.0/255 green:150.0/255 blue:150.0/255 alpha:1.0]];
        [dateLab setFont:[UIFont fontWithName:@"Arial" size:15]];
        [dateLab setTextAlignment:NSTextAlignmentCenter];
        [dateView addSubview:dateLab];
        //左右按钮初始化
        for(int i=0; i<2; i++){
            UIImage* image =[UIImage imageNamed:[NSString stringWithFormat:@"dateLabel%d", i]];
            UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(10+250*i, 7, 24, 24);
            btn.tag = i;
            [btn setBackgroundImage:image forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(goOrBack:) forControlEvents:UIControlEventTouchUpInside];
            [dateView addSubview:btn];}
    }
    //Y轴刻度数值
    for(int i=0; i<5; i++){
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(segmentControl.frame.origin.x+segmentControl.frame.origin.x-28,dateView.frame.origin.y+53+i*45, 30, 20)];
        [label setText:[NSString stringWithFormat:@"%d", 40-i*10]];
        [label setTextColor:[UIColor colorWithRed:150.0/255 green:150.0/255 blue:150.0/255 alpha:1.0]];
        [label setFont:[UIFont systemFontOfSize:11]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setBackgroundColor:[UIColor clearColor]];
        [self.scrollView addSubview:label];
    }
}
#pragma mark 左右按钮选择不同日期
- (void)goOrBack:(UIButton* )btn
{
    for(id obj in chat.subviews){
        if([obj isKindOfClass:[InfoView class]]){
            [obj removeFromSuperview];}
    }
    if(chat.lines){
        [chat.lines removeAllObjects];
        [chat.points removeAllObjects];
        [dayView removeFromSuperview];
        dayView = nil;
        [chat setNeedsDisplay];
    }
    if(btn.tag==1){
        switch ([segmentControl selectedSegmentIndex]) {
            case 0:{
                goW++;
                [dateLab setText:[self returnWeekDayWithD:[self getCurrentTimeWith:week] W:goW]];
                [self readyDrawLineWithTip:0];
                break;
            }
            case 1:{
                goM++;
                [dateLab setText:[self returnMonthDayWithM:[self getCurrentTimeWith:month] andDay:[self getCurrentTimeWith:day] W:goM]];
                [self readyDrawLineWithTip:1];
                break;
            }
            case 2:{
                goY++;
                [dateLab setText:[self returnCurrentYear:goY]];
                [self readyDrawLineWithTip:2];
                break;
            }
            default:
                break;
        }
    }else{
        
        switch ([segmentControl selectedSegmentIndex]) {
            case 0:{
                goW--;
                [dateLab setText:[self returnWeekDayWithD:[self getCurrentTimeWith:week] W:goW]];
                [self readyDrawLineWithTip:0];
                break;
            }
            case 1:{
                goM--;
                [dateLab setText:[self returnMonthDayWithM:[self getCurrentTimeWith:month] andDay:[self getCurrentTimeWith:day] W:goM]];
                [self readyDrawLineWithTip:1];
                break;
            }
            default:{
                goY--;
                [dateLab setText:[self returnCurrentYear:goY]];
                [self readyDrawLineWithTip:2];
                break;
            }
        }
    }
}
//获取当前年月日，星期
- (int)getCurrentTimeWith:(State)state
{
    NSDate* date = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comps = [calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit) fromDate:date];
    switch (state) {
        case year:{
            return (int)[comps year];
        }
            break;
        case month:{
            return (int)[comps month];
            break;
        }
        case day:{
            return (int)[comps day];
            break;
        }
        case week:{
            return (int)[comps weekday]-1>0?(int)[comps weekday]-1:7;
            break;
        }
        default:
            break;
    }
}

- (NSString* )returnCurrentYear:(int)d
{
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY"];
    NSString* str = [formatter stringFromDate:date];
    
    return [NSString stringWithFormat:@"%d年",[str intValue]+d];
}

//返回本周的日期范围
- (NSString* )returnWeekDayWithD:(int)w W:(int)n
{
    NSDate* date1 = [NSDate dateWithTimeIntervalSinceNow:60*60*24*(n*7-w+1)];
    NSDate* date2 = [NSDate dateWithTimeIntervalSinceNow:60*60*24*(n*7-w+7)];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd"];
    NSString* str1 = [formatter stringFromDate:date1];
    NSString* str2 = [formatter stringFromDate:date2];
    return [NSString stringWithFormat:@"%@月%@日 - %@月%@日", [[str1 componentsSeparatedByString:@"-"] objectAtIndex:0], [[str1 componentsSeparatedByString:@"-"] objectAtIndex:1], [[str2 componentsSeparatedByString:@"-"] objectAtIndex:0], [[str2 componentsSeparatedByString:@"-"] objectAtIndex:1]];
}

int backDaysM(int m){
    switch (m) {
        case 2:{
            return 28;
            break;
        }
        case 4:
        case 6:
        case 9:
        case 11:{
            return 30;
            break;
        }
        default:
            return 31;
            break;
    }
    
}

- (int)backDaysWithM:(int)m andW:(int)w
{
    int days=0;
    if(w>0){
        for(int i=1; i<=w; i++){
            m++;
            if(m>12)m=1;
            days+=backDaysM(m);
        }
    }else if(w<0){
        for(int i=1; i<=(-w); i++){
            m--;
            if(m<=0)m=12;
            days-=backDaysM(m);
        }
    }else{
        days = 0;
    }
    return days;
}

- (int)backaDaysWithM:(int)m andW:(int)w
{
    int days=0;
    if(w>0){
        for(int i=0; i<w; i++){
            if(i!=0)m++;
            if(m>12)m=1;
            days+=backDaysM(m);
        }
    }else if(w<0){
        for(int i=0; i<(-w); i++){
            if(i!=0)m--;
            if(m<=0){
                m=12;
            }
            days-=backDaysM(m);
        }
    }else{
        days = 0;
    }
    return days;
}

#pragma mark  返回当月的日期范围
- (NSString* )returnMonthDayWithM:(int)m andDay:(int)d W:(int)w
{
    int day=backDaysM(m);
    int days=0;
    int days2=0;
    if(w>0){
        days = [self backaDaysWithM:m andW:w];
        days2 = [self backDaysWithM:m andW:w];
    }else{
        days = [self backDaysWithM:m andW:w];
        days2 = [self backaDaysWithM:m andW:w];
    }
    
    NSLog(@"%d-%d", days, days2);
    NSDate* date1 = [NSDate dateWithTimeIntervalSinceNow:60*60*24*(days-d+1)];
    NSDate* date2 = [NSDate dateWithTimeIntervalSinceNow:60*60*24*(days2+day-d)];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd"];
    NSString* str1 = [formatter stringFromDate:date1];
    NSString* str2 = [formatter stringFromDate:date2];
    return [NSString stringWithFormat:@"%@月%@日 - %@月%@日", [[str1 componentsSeparatedByString:@"-"] objectAtIndex:0], [[str1 componentsSeparatedByString:@"-"] objectAtIndex:1], [[str2 componentsSeparatedByString:@"-"] objectAtIndex:0], [[str2 componentsSeparatedByString:@"-"] objectAtIndex:1]];
}

#pragma mark  根据周月年返回dateView日期的值
- (NSString* )returnCurrentTimeStrWithTip:(int)tip
{
    switch (tip) {
        case 0:{
            return [self returnWeekDayWithD:[self getCurrentTimeWith:week] W:0];
            break;}
        case 1:{
            return [self returnMonthDayWithM:[self getCurrentTimeWith:month] andDay:[self getCurrentTimeWith:day] W:0];
            break; }
        default:
            return [self returnCurrentYear:0];
        break;}
}
#pragma mark  设置Y轴刻度的值
- (NSArray* )returnPointXandYWithTip:(int)tip
{
    NSMutableArray *Points = [[NSMutableArray alloc]init];
    //根据划分几个网格来设置点数据
    int gap = chat.frame.size.width/([self rePointCountWithTip:tip]-2);
    
    for(int i=0; i<[self rePointCountWithTip:tip]-1; i++){
        CGPoint point1 =CGPointMake(1+gap*i, arc4random()%180);
        [Points addObject:[NSValue valueWithCGPoint:point1]];
    }
    return [NSArray arrayWithObjects:Points, nil];
    
}

#pragma mark  根据tip画表格线
- (void)readyDrawLineWithTip:(int)tip
{
    [self initDateView];
    if(!chat){
        chat = [[chatView alloc]initWithFrame:CGRectMake(30, dateView.frame.origin.y+40, 250, 210)];
        [chat setBackgroundColor:[UIColor clearColor]];
        chat.opaque= NO;
        [self.scrollView addSubview:chat];
    }
    if(!dayView){
        dayView = [[UIView alloc]initWithFrame:CGRectMake(0, chat.frame.origin.y+chat.frame.size.height, [[UIScreen mainScreen] bounds].size.width, 10)];
        dayView.opaque = NO;
        [self.scrollView addSubview:dayView];
    }
    if(!chat.lines.count){
        int gap = chat.frame.size.width/([self reLineCountWithTip:tip]-2);
        for(int i=0; i<[self reLineCountWithTip:tip]; i++){
            Line* line = [[Line alloc]init];
            if(i!=[self reLineCountWithTip:tip]-1){
                line.firstPoint = CGPointMake(1+gap*i, 0);
                line.secondPoint = CGPointMake(1+gap*i, 205);
                UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(25+gap*i, 0, 34, 10)];
                [lab setText:[self reWeeksWithDay:i UseTip:tip]];
                [lab setBackgroundColor:[UIColor clearColor]];
                [lab setTextColor:[UIColor grayColor]];
                [lab setFont:[UIFont systemFontOfSize:11]];
                [dayView addSubview:lab];
            }else{
                line.firstPoint = CGPointMake(0, 205);
                line.secondPoint = CGPointMake(247, 205);
            }
            [chat.lines addObject:line];
        }
        
        int gap2 = chat.frame.size.width/([self rePointCountWithTip:tip]-2);
        if(([self rePointCountWithTip:tip]-2)*gap2>=250){
            gap2-=2;
        }
        chat.points = [[self returnPointXandYWithTip:tip] mutableCopy];
    }
    NSArray *lastPoint = [chat.points lastObject] ;
    NSLog(@"lastPoint is %@",lastPoint);
}

//根据tip返回点数
- (int)rePointCountWithTip:(int)tip
{
    switch (tip) {
        case 0:{return 8;break;}
        case 1:{return 9;break;}
        default:{return 8;break;}
    }
}
//根据tip返回线的条数
- (int)reLineCountWithTip:(int)tip{
    switch (tip) {
        case 0:{return 8;break;}
        case 1:{return 9;break;}
        default:{return 8;break;}
    }
}

- (NSString* )reWeeksWithDay:(int)day UseTip:(int)tip
{
    if(tip==0){
        switch (day) {
            case 0:{return @"星期一";break;}
            case 1:{return @"星期二";break;}
            case 2:{return @"星期三";break;}
            case 3:{return @"星期四";break;}
            case 4:{return @"星期五";break;}
            case 5:{return @"星期六";break;}
            default:return @"星期日";break;}
    }else if(tip==1){
        switch (day) {
            case 0:{return @"1日";break;}
            case 1:{return @"4日";break;}
            case 2:{return @"8日";break;}
            case 3:{return @"12日";break;}
            case 4:{return @"16日";break;}
            case 5:{return @"20日";break;}
            case 6:{return @"24日";break;}
            default:return @"28日";break;}
    }else{
        switch (day) {case 0:{return @"1月";break;}
            case 1:{return @"2月";break;}
            case 2:{return @"4月";break;}
            case 3:{return @"6月";break;}
            case 4:{return @"8月";break;}
            case 5:{return @"10月";break;}
            default:return @"12月";break;}
    }
}

//初始化时第一次使用周显示
- (void)controlPressOne
{
    for(id obj in chat.subviews){
        if([obj isKindOfClass:[InfoView class]]){
            [obj removeFromSuperview];
        }
    }
    if(chat.lines){
        [chat.lines removeAllObjects];
        [chat.points removeAllObjects];
        [dayView removeFromSuperview];
        dayView = nil;
        [chat setNeedsDisplay];
    }
    [self readyDrawLineWithTip:0];
    [dateLab setText:[self returnCurrentTimeStrWithTip:0]];
}
//按钮选择对应周月年
- (void)controlPress:(id)sender
{
    for(id obj in chat.subviews){
        if([obj isKindOfClass:[InfoView class]]){
            [obj removeFromSuperview];
        }
    }
    switch ([segmentControl selectedSegmentIndex]) {
            
        case 0:{
            if(chat.lines){
                [chat.lines removeAllObjects];
                [chat.points removeAllObjects];
                [dayView removeFromSuperview];
                dayView = nil;
                [chat setNeedsDisplay];
            }
            goY=0;goM=0;
            [self readyDrawLineWithTip:0];
            [dateLab setText:[self returnCurrentTimeStrWithTip:0]];
            NSLog(@"0");
            break;
        }
        case 1:{
            if(chat.lines){
                [chat.lines removeAllObjects];
                [chat.points removeAllObjects];
                [dayView removeFromSuperview];
                dayView = nil;
                [chat setNeedsDisplay];
            }
            goY=0;goW=0;
            [self readyDrawLineWithTip:1];
            [dateLab setText:[self returnCurrentTimeStrWithTip:1]];
            NSLog(@"1");
            break;
        }
        default:{
            if(chat.lines){
                [chat.lines removeAllObjects];
                [chat.points removeAllObjects];
                [dayView removeFromSuperview];
                dayView = nil;
                [chat setNeedsDisplay];
            }
            goY=0;goW=0;
            [self readyDrawLineWithTip:2];
            [dateLab setText:[self returnCurrentTimeStrWithTip:2]];
            NSLog(@"2");
            break;
        }
    }
}
/*
 - (void)drawLineWithCount
 {
 //    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(100, 200, 10, 10)];
 //    [self.view addSubview:imageView1];
 //
 //    UIGraphicsBeginImageContext(imageView1.frame.size);   //开始画线
 //    [imageView1.image drawInRect:CGRectMake(0, 0, imageView1.frame.size.width, imageView1.frame.size.height)];
 //    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
 //
 //    CGContextRef line = UIGraphicsGetCurrentContext();
 //    CGContextSetFillColorWithColor(line, [UIColor blueColor].CGColor);
 //    CGPoint p = CGPointMake(0, 0);
 //    CGContextFillEllipseInRect(line, CGRectMake(p.x, p.y, 15, 8));
 //    imageView1.image = UIGraphicsGetImageFromCurrentImageContext();
 }
 */


#pragma mark - UITableView Datasource

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    //    return section?2:4;
//    return 1;
//    
//}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *cellIdentifier = @"TableViewCell";
//    
//    
//    
//    
//    return cell;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 170;
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
