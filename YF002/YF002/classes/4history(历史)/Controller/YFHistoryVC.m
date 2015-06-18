//
//  YFHistoryVC.m
//  YF002
//
//  Created by Mushroom on 5/31/15.
//  Copyright (c) 2015 Mushroom. All rights reserved.
//

#import "YFHistoryVC.h"
#import "TableViewCell.h"

#import "LMComBoxView.h"
#import "LMContainsLMComboxScrollView.h"


#define kDropDownListTag 1000

@interface YFHistoryVC ()  <LMComBoxViewDelegate,SliderSwitchDelegate,UIScrollViewDelegate>
{
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
@property (nonatomic ,strong) TableViewCell *lineChart;
@end

@implementation YFHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //读取plist,生成第一级别的dictionary
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:@"treatHistory.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath =  [[NSBundle mainBundle] pathForResource:@"treatHistory" ofType:@"plist"];
    }
    _recordArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
    
   
    //三选项按钮
    _slideSwitchH=[[SliderSwitch alloc]init];
    [_slideSwitchH setFrameHorizontal:(CGRectMake(20,75, 280, 30)) numberOfFields:3 withCornerRadius:6.0];
    _slideSwitchH.delegate=self;
    [_slideSwitchH setFrameBackgroundColor:[UIColor colorWithRed:0.34 green:0.76 blue:0.52 alpha:1]];
    [_slideSwitchH setSwitchFrameColor:[UIColor colorWithRed:0.96 green:0.35 blue:0.32 alpha:1]];
    [_slideSwitchH setText:@"周" atLabelIndex:1];
    [_slideSwitchH setText:@"月" atLabelIndex:2];
    [_slideSwitchH setText:@"年" atLabelIndex:3];
    [_slideSwitchH setSwitchBorderWidth:3];
    [self.view addSubview:_slideSwitchH];
    
    
    
    //配置图表
    _lineChart = [[TableViewCell alloc] init];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    NSLog(@"%@", path);
    [_lineChart configUI:path];
    [self.view addSubview:_lineChart];
    _lineChart.frame = CGRectMake(0, 120, 100, 100) ;
    
    //配置下拉列表
    NSString *plistPath1 = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    areaDic = [NSDictionary dictionaryWithContentsOfFile:plistPath1];
    [self loadAreaDicWithCGRect:CGRectMake(46, 310, 320, 130)];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -sliderSwitchDelegate
- (void)switchChangedSliderSwitch:(SliderSwitch *)sliderSwitch{
    if ( sliderSwitch == _slideSwitchH) {
        if ( sliderSwitch.selectedIndex == 0) {
//            self.view.backgroundColor=[UIColor redColor];
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
            NSLog(@"%@", path);
            [_lineChart configUI:path];
        } else if (sliderSwitch.selectedIndex == 1) {
//            self.view.backgroundColor=[UIColor blueColor];
            NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:0];
            NSLog(@"%@", path);
            [_lineChart configUI:path];
        } else if (sliderSwitch.selectedIndex == 2) {
//            self.view.backgroundColor=[UIColor greenColor];
            NSIndexPath *path = [NSIndexPath indexPathForRow:2 inSection:0];
            NSLog(@"%@", path);
            [_lineChart configUI:path];
        }
}
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
    [self.view addSubview:bgScrollView];
    
    [self setUpBgScrollView];
   
}

-(void)setUpBgScrollView
{
    
    
    NSArray *keys = [NSArray arrayWithObjects:@"province",@"city",@"area", nil];
    for(NSInteger i=0;i<2;i++)
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
        
        LMComBoxView *comBox = [[LMComBoxView alloc]initWithFrame:CGRectMake(x, 0, xWidth, 27)];
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
    NSLog(@"===%@===%@===%@",selectedProvince,selectedCity,selectedArea);
}

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
