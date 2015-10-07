//
//  YFNewFeatureViewPVC.m
//  YF002
//
//  Created by Mushroom on 10/6/15.
//  Copyright (c) 2015 Mushroom. All rights reserved.
//

#import "YFNewFeatureViewPVC.h"

#import <QuartzCore/QuartzCore.h>

#import "MYBlurIntroductionView.h"

@interface YFNewFeatureViewPVC () <UIScrollViewDelegate,MYIntroductionDelegate>
// guide1中的属性
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *guide1YF002;
@property (weak, nonatomic) IBOutlet UIImageView *guide1Person;
@property (weak, nonatomic) IBOutlet UIImageView *guide1Iphone;
@property (weak, nonatomic) IBOutlet UILabel *guide1Text1Lab;
@property (weak, nonatomic) IBOutlet UILabel *guide1Text2Lab;


// guide2中的属性

// guide3中的属性
@end

@implementation YFNewFeatureViewPVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
   // _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    //我们的scrollView的frame应该是屏幕大小
    _scrollView.contentSize = CGSizeMake(screenSize.width * 3, screenSize.height);
    //但是我们希望我们scrollView的可被展现区域是3个屏幕横排那么大
    _scrollView.alwaysBounceHorizontal = YES;//横向一直可拖动
    _scrollView.pagingEnabled = YES;//关键属性，打开page模式。
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;//不要显示滚动条~
    
 
// guide1
     //
//     _guide1Person.alpha = 0.0;
//    _guide1YF002.alpha =0.0;
//    _guide1Text1Lab.alpha =0.0;
//    _guide1Text2Lab.alpha = 0.0;
//    _guide1Iphone.alpha =0.0;

   
}

-(void)viewDidAppear:(BOOL)animated{
    
   
    
    
//    _guide1Iphone.transform = CGAffineTransformMakeTranslation(0, 60);
//    _guide1YF002.transform = CGAffineTransformMakeTranslation(0, -60);
//    [UIView animateWithDuration:1.8
//                     animations:^{
//                         _guide1Person.alpha = 1.0;
//                         _guide1Iphone.transform = CGAffineTransformMakeTranslation(0, 0);
//                         
//                     }];
//    [UIView animateWithDuration:3.0 animations:^{
//        _guide1Iphone.alpha = 1.0f;
//    }];
//    
//[UIView animateWithDuration:1.5  animations:^{                      _guide1Text1Lab.alpha = 1.0;
//        _guide1Text1Lab.transform = CGAffineTransformMakeTranslation(100, 0);                  }
//                     completion:^(BOOL finished){
//            [UIView animateWithDuration:2.0  animations:^{
//            _guide1Text2Lab.alpha = 1.0;
//            _guide1Text2Lab.center = CGPointMake(200, 300);                                       }];
//        }];

//[UIView animateWithDuration:1.0 delay:2.0 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{_guide1YF002.alpha =1;
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:2.0 animations:^{
//            _guide1YF002.alpha =1;
//            _guide1YF002.transform = CGAffineTransformMakeTranslation(0, 0);
//        }];
//            	    //do stuff here
//            }];
   
}

- (void)firstGuideAnimation{

    _guide1Iphone.transform = CGAffineTransformMakeTranslation(- 100, 0);
    _guide1Text1Lab.transform = CGAffineTransformMakeTranslation(100, 0);
    _guide1Text2Lab.transform = CGAffineTransformMakeTranslation(- 120, 0);
    
    [UIView animateWithDuration:3.0
                     animations:^{

                         _guide1Iphone.transform = CGAffineTransformMakeTranslation(0, 0);
                         _guide1Text1Lab.transform = CGAffineTransformMakeTranslation(0, 0);
                         _guide1Text2Lab.transform = CGAffineTransformMakeTranslation(0, 0);
                     }];
};

- (void)DrawGradientColor:(CGContextRef)context
                     rect:(CGRect)clipRect
                    point:(CGPoint) startPoint
                    point:(CGPoint) endPoint
                  options:(CGGradientDrawingOptions) options
               startColor:(UIColor*)startColor
                 endColor:(UIColor*)endColor
{
    UIColor* colors [2] = {startColor,endColor};
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat colorComponents[8];
    
    for (int i = 0; i < 2; i++) {
        UIColor *color = colors[i];
        CGColorRef temcolorRef = color.CGColor;
        
        const CGFloat *components = CGColorGetComponents(temcolorRef);
        for (int j = 0; j < 4; j++) {
            colorComponents[i * 4 + j] = components[j];
        }
    }
    
    CGGradientRef gradient =  CGGradientCreateWithColorComponents(rgb, colorComponents, NULL, 2);
    
    CGColorSpaceRelease(rgb);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, options);
    CGGradientRelease(gradient);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
