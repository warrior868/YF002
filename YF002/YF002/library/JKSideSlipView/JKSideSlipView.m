//
//  JKSideSlipView.m
//  JKSideSlipView
//
//  Created by Jakey on 15/1/10.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//
//slip distance
#define SLIP_WIDTH 220

#import "JKSideSlipView.h"
#import "YFTreatParameterItem.h"
#import <Accelerate/Accelerate.h>

@implementation JKSideSlipView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSAssert(nil, @"please init with -initWithSender:sender");
    }
    return self;
    
}
//- (void)initWithSender:(UIViewController*)sender
//         withTreatItem:(YFTreatParameterItem *)treatParameterItem
//   withBlueToothStatus:(BOOL)blueToothStatus
//       withPowerStatus:(NSInteger)powerStatus
- (instancetype)initWithSender:(UIViewController *)sender {
   
    CGRect bounds = [UIScreen mainScreen].bounds;
    CGRect frame = CGRectMake(-SLIP_WIDTH, 0, SLIP_WIDTH, bounds.size.height);
    self = [super initWithFrame:frame];
    if (self) {
        [self buildViews:sender];
        NSArray* demoNib = [[NSBundle mainBundle] loadNibNamed:@"JKSideSlipView" owner:self options:nil];
        _aView = [demoNib lastObject];
        
//        _aView.bounds = CGRectMake(0, 0, 180, 480);
        [self addSubview:_aView ];
    }
    return self;
}

- (void)awakeFromNib {
    // 视图内容布局
//    self.backgroundColor = [UIColor yellowColor];
    //    self.titleLabel.textColor = [UIColor whiteColor];
    self.treatTimeLabel.text = @"星期天";
   
}

-(void)buildViews:(UIViewController*)sender{
    _sender = sender;
    //    点击tableview中的行
    //    _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(switchMenu)];
    _tap.numberOfTapsRequired = 1;
    //    手势操作
    _leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    _leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    //    [_sender.view addGestureRecognizer:_rightSwipe];
    //    _rightSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(show)];
    _rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    //    [_sender.view addGestureRecognizer:_tap];
    [_sender.view addGestureRecognizer:_leftSwipe];
    
    _blurImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SLIP_WIDTH, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _blurImageView.userInteractionEnabled = NO;
    _blurImageView.alpha = 0;
    _blurImageView.backgroundColor = [UIColor grayColor];
    //_blurImageView.layer.borderWidth = 5;
    //_blurImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self addSubview:_blurImageView];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //        [self setup];
        
    }
    return self;
}



//- (void)initWithSender:(UIViewController*)sender withTreatItem:(YFTreatParameterItem *)treatParameterItem withBlueToothStatus:(BOOL)blueToothStatus withPowerStatus:(NSInteger)powerStatus{
//    
//
//    
//    self.treatTimeLabel.text = _treatItemSSV.treatTime;
////    NSLog(@"_treatItemSSV.treatTime--%@",_treatItemSSV.treatTime);
////    NSLog(@"self.treatTimeLabel.text--%@",self.treatTimeLabel.text);
//    self.treatStrengthLabel.text = _treatItemSSV.treatStrength;
//    
//   
//    [self reloadTreatItem:treatParameterItem withBlueToothStatus:blueToothStatus withPowerStatus:powerStatus];
//    
//    
//    //((UIScrollView *)self.view).contentSize = CGSizeMake(self.view.frame.size.width, demoView.frame.size.height);
//    
//}





- (void)reloadTreatItem:(YFTreatParameterItem *)treatParameterItem withBlueToothStatus:(BOOL)blueToothStatus withPowerStatus:(NSInteger)powerStatus {
//    if (blueToothStatus) {
//        _treatItemSSV = treatParameterItem;
//        self.isBlueToothConnect.text = @"蓝牙已经连接";
//        self.powerRemain.text = [NSString stringWithFormat:@"%ld%%",(long)powerStatus];
//        self.treatTimeLabel.text = _treatItemSSV.treatTime;
//        self.treatStrengthLabel.text = _treatItemSSV.treatStrength;
//        self.treatWaveLabel.text = _treatItemSSV.treatWave;
//        self.treatModelLabel.text = _treatItemSSV.treatModel;
//        NSLog(@"reload treatParameterItem.treatTime--%@",_treatItemSSV.treatTime);
//    }
//    else{
//        self.isBlueToothConnect.text = @"蓝牙未连接";
//        self.powerRemain.text = @"-";
//        self.treatTimeLabel.text = @"-";
//        self.treatStrengthLabel.text = @"-";
//        self.treatWaveLabel.text = @"-";
//        self.treatModelLabel.text = @"-";
//       }
    _blurImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SLIP_WIDTH, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _blurImageView.userInteractionEnabled = NO;
    _blurImageView.alpha = 0;
    _blurImageView.backgroundColor = [UIColor grayColor];
    //_blurImageView.layer.borderWidth = 5;
    //_blurImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self addSubview:_blurImageView];
//    NSLog(@"treatParameterItem.treatTime--%@",treatParameterItem.treatTime);
//    NSLog(@"self.treatTimeLabel.text--%@",self.treatTimeLabel.text);
}




-(void)setContentView:(UIView*)contentView{
     
    if (contentView) {
        _contentView = contentView;
    }
    
//    NSArray* demoNib = [[NSBundle mainBundle] loadNibNamed:@"JKSideSlipView" owner:self options:nil];
//    _aView = [demoNib lastObject];
//    _aView.bounds = CGRectMake(0, 0, 180, 480);
    [self addSubview:_aView];

}
-(void)show:(BOOL)show{
    UIImage *image =  [self imageFromView:_sender.view];
   
    if (!isOpen) {
        _blurImageView.alpha = 0;

    }
    
    CGFloat x = show?0:-SLIP_WIDTH;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(x, 0, self.frame.size.width, self.frame.size.height);
        if(!isOpen){
            _blurImageView.image = image;
            _blurImageView.image= [self blurryImage:_blurImageView.image withBlurLevel:0.2];
        }
    } completion:^(BOOL finished) {
        isOpen = show;
        if(!isOpen){
            
            _blurImageView.alpha = 0;
            _blurImageView.image = nil;
            NSLog(@"hidden");
        }

    }];
    
}


-(void)switchMenu{
    [self show:!isOpen];
}
-(void)show{
    
    [self show:YES];
   
}

-(void)hide {
    [self show:NO];
}

#pragma mark - shot
- (UIImage *)imageFromView:(UIView *)theView
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
#pragma mark - Blur


- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    if ((blur < 0.0f) || (blur > 1.0f)) {
        blur = 0.5f;
    }
    
    int boxSize = (int)(blur * 100);
    boxSize -= (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL,
                                       0, 0, boxSize, boxSize, NULL,
                                       kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(image.CGImage));
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}



@end