//
//  YFRegsiterVC.m
//  YF002
//
//  Created by Mushroom on 10/1/15.
//  Copyright (c) 2015 Mushroom. All rights reserved.
//

#import "YFRegsiterVC.h"
#define viewCornerRadius 5.0
@interface YFRegsiterVC ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet UIView *view6;
@property (weak, nonatomic) IBOutlet UIButton *regsiterBtn;
- (IBAction)registerBtn:(id)sender;


@end

@implementation YFRegsiterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //隐藏导航栏
    self.navigationController.navigationBarHidden = NO;
    self.scrollView.frame = CGRectMake(11, 0, 320, 480);
    [self.scrollView setContentSize:CGSizeMake(320, 520)];
    //UI设置
    _view1.layer.cornerRadius =viewCornerRadius;
    _view2.layer.cornerRadius =viewCornerRadius;
    _view3.layer.cornerRadius =viewCornerRadius;
    _view4.layer.cornerRadius =viewCornerRadius;
    _view5.layer.cornerRadius =viewCornerRadius;
    _view6.layer.cornerRadius =viewCornerRadius;
    _regsiterBtn.layer.cornerRadius =viewCornerRadius;
   
    
    
// 0.设置返回按钮的背景图片
    // 0.1隐藏原有的返回按钮
    [self.navigationItem setHidesBackButton:YES];
    // 0.2新建一个按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(15, 5, 32, 20);
    [btn setBackgroundImage:[UIImage imageNamed:@"backicon"] forState:UIControlStateNormal];
    // 0.3增加selector的方法
    [btn addTarget: self action: @selector(goBackAction) forControlEvents: UIControlEventTouchUpInside];
    // 0.4设置导航栏的leftButton
    UIBarButtonItem *back=[[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=back;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  增加返回按钮的自定义动作
-(void)goBackAction{
     [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)registerBtn:(id)sender {
    
}
@end
