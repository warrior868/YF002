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
@property (nonatomic,strong) NSArray *week;
@property (nonatomic,strong) NSArray *month;
@property (nonatomic,strong) NSArray *year;
@end

@implementation TableViewCell





- (void)configUI:(NSIndexPath *)indexPath
{
    if (chartView) {
        [chartView removeFromSuperview];
        chartView = nil;
    }
    
    path = indexPath;
//   后面选择UUChartBarStyle或者 UUChartLineStyle
    chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20, 150)
                                              withSource:self
                                               withStyle:UUChartLineStyle];
    [chartView showInView:self.contentView];
}



#pragma mark - @required

//横坐标标题数组
- (NSArray *)UUChart_xLableArray:(UUChart *)chart
{
    _week = @[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日"];
    _month = @[@"五日",@"十日",@"十五日",@"二十日",@"二十五日",@"三十日"];
    _year = @[@"二月",@"四月",@"六月",@"八月",@"十月",@"十二月"];
    if (path.section==0) {
        switch (path.row) {
            case 0:
                return _week;
            case 1:
                return _month;
            case 2:
                return _year;
           
            default:
                break;
        }
    }else{
        switch (path.row) {
            case 0:
                return _week;
            case 1:
                return _month;
            default:
                break;
        }
    }
    return _week;
}
//数值多重数组
- (NSArray *)UUChart_yValueArray:(UUChart *)chart
{
    
    NSArray *ary = @[@"22",@"44",@"15",@"40",@"42",@"40",@"42"];
    NSArray *ary1 = @[@"22",@"54",@"15",@"30",@"42",@"77"];
    NSArray *ary2 = @[@"76",@"34",@"54",@"23",@"16",@"32",@"17"];
    NSArray *ary3 = @[@"3",@"12",@"25",@"55",@"52"];
    NSArray *ary4 = @[@"23",@"42",@"25",@"15",@"30",@"42",@"32",@"40",@"42",@"25",@"33"];
    
    if (path.section==0) {
        switch (path.row) {
            case 0:
                return @[ary];
            case 1:
                return @[ary1];
            case 2:
                return @[ary2];
            default:
                return @[ary,ary1,ary2];
        }
    }else{
        if (path.row) {
            return @[ary1,ary2];
        }else{
            return @[ary4];
        }
    }
}

#pragma mark - @optional
//颜色数组
- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{
    return @[UUGreen,UURed,UUBrown];
}
//显示数值范围
- (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart
{
    if (path.section==0 && (path.row==0|path.row==1)) {
        return CGRangeMake(80, 10);
    }
    if (path.section==1 && path.row==0) {
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
