//
//  TableViewCell.m
//  UUChartView
//
//  Created by shake on 15/1/4.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import "TableViewCell.h"
#import "UUChart.h"

@interface TableViewCell ()<UUChartDataSource>
{
    NSIndexPath *path;
    UUChart *chartView;
}

@property (nonatomic,strong) NSMutableArray *recordArray;
//图表中X轴数据
@property (nonatomic,strong) NSMutableArray *weekArrayX;
@property (nonatomic,strong) NSMutableArray *monthArrayX;
@property (nonatomic,strong) NSMutableArray *yearArrayX;
//图表中Y轴数据
@property (nonatomic,strong) NSMutableArray *weekArrayY;
@property (nonatomic,strong) NSMutableArray *monthArrayY;
@property (nonatomic,strong) NSMutableArray *yearArrayY;
//当前时间的数据
@property (nonatomic,assign) NSInteger nowYear;
@property (nonatomic,assign) NSInteger nowMonth;
@property (nonatomic,assign) NSInteger nowDay;
@property (nonatomic,assign) NSInteger nowWeekday;
@end

@implementation TableViewCell





- (void)configUI:(NSIndexPath *)indexPath
{
    if (chartView) {
        [chartView removeFromSuperview];
        chartView = nil;
    }
    
    path = indexPath;
    //后面选择UUChartBarStyle或者 UUChartLineStyle
    chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20, 150)
                                              withSource:self
                                               withStyle:UUChartLineStyle];
    [chartView showInView:self.contentView];
    //读取记录,生成第一级别的dictionary
    NSString *plistPath =  [[NSBundle mainBundle] pathForResource:@"treatHistory" ofType:@"plist"];
    _recordArray = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    //对数组中的字典按照日期进行排序
    NSMutableArray *sortDescriptors = [NSMutableArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"treatDate" ascending:NO]];
    [_recordArray sortUsingDescriptors:sortDescriptors];
    NSLog(@"_recordArray is  %@ ", _recordArray);
   
    
}



#pragma mark - @required 横坐标标题数组

//横坐标标题数组
- (NSArray *)UUChart_xLableArray:(UUChart *)chart
{
    
    
    
    _weekArrayX = @[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日"];
    _monthArrayX = @[@"五日",@"十日",@"十五日",@"二十日",@"二十五日",@"三十日"];
    _yearArrayX = @[@"二月",@"四月",@"六月",@"八月",@"十月",@"十二月"];
    
        switch (path.row) {
            case 0:
                return _weekArrayX;
            case 1:
                return _monthArrayX;
            default:
                return _yearArrayX;
        }
    
}
#pragma mark - @required 纵坐标标题数组
- (NSArray *)UUChart_yValueArray:(UUChart *)chart
{
   
   
    [self setWeekArrayY];
    _monthArrayY = @[@"10",@"10",@"10",@"10"];
    _yearArrayY = @[@"10",@"10",@"10",@"10"];
    switch (path.row) {
            case 0:
                return @[_weekArrayY];
            case 1:
                return @[_monthArrayY];
            default:
                return @[_yearArrayY];
        }
   
}

- (NSMutableArray *) setWeekArrayY{
    
    
    _weekArrayY = [[NSMutableArray alloc] init];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormat setDateFormat:@"yyyyMMddHHmm"];
    
    NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];
    //设定时间格式，年中的第几天
    NSDateFormatter *dayOfYear = [[NSDateFormatter alloc] init];
    [dayOfYear setDateFormat:@"D'"];
    //年中的第几天转化成整数
    NSInteger todayInt = [[dayOfYear stringFromDate:today] integerValue];
    
    
    //设定都为0的数组
    for (NSInteger i = 0; i<7; i++) {
        [_weekArrayY addObject:@"0"];
    }
    
    
    for (NSInteger e = 0 ; e<[_recordArray count]; e++) {
        //读出纪录中第e个纪录日期
        NSDate *recordDate =[dateFormat dateFromString:[_recordArray[e] objectForKey:@"treatDate" ]];
        NSInteger recordDateInt = [[dayOfYear stringFromDate:recordDate] integerValue];
        NSInteger treatDrugQuantityInt = [[_recordArray[e] objectForKey:@"treatDrugQuantity" ] integerValue];
        //读出纪录中第e个纪录日期
        if ((todayInt-recordDateInt)<7 && treatDrugQuantityInt>0) {
            //把record中读出的值加入到对应周纪录数组中
            NSInteger weekDayInt = todayInt-recordDateInt ;
            treatDrugQuantityInt = [_weekArrayY[weekDayInt]  integerValue] + treatDrugQuantityInt ;
            //替换对应数组内的值
            [_weekArrayY replaceObjectAtIndex:weekDayInt withObject:[NSString stringWithFormat:@"%d",treatDrugQuantityInt]];
            //判断是否超过一周数量，若超出，退出for循环
        }else if ((todayInt-recordDateInt)>=7){
            e=[_recordArray count];
        }
    }
    
    NSLog(@"_weekArrayY is  %@ ", _weekArrayY);
    return  _weekArrayY;
}

#pragma mark -  图表颜色数组
//颜色数组
- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{
    return @[UURed,UUGreen,UUBrown];
}
#pragma mark -  图表纵坐标显示范围
//显示数值范围
- (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart
{
    if (path.row==0 ) {
        return CGRangeMake(50, 0);
    }
    if (path.row==1) {
        return CGRangeMake(60, 10);
    }
    if (path.row==2) {
        return CGRangeMake(100, 0);
    }
    return CGRangeZero;
}

#pragma mark 折线图专享功能

//标记数值区域
- (CGRange)UUChartMarkRangeInLineChart:(UUChart *)chart
{
    
    if (path.row==2) {
        return CGRangeMake(25, 75);
    }
    return CGRangeZero;
}

//判断显示横线条
- (BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index
{
    return YES;
}

//判断显示最大最小值
- (BOOL)UUChart:(UUChart *)chart ShowMaxMinAtIndex:(NSInteger)index
{
    return NO;
//    return path.row==2;
}
@end
