//
//  YFRegsiterVC.m
//  YF002
//
//  Created by Mushroom on 10/1/15.
//  Copyright (c) 2015 Mushroom. All rights reserved.
//

#import "YFRegsiterVC.h"
#import "TextFieldValidator.h"
#import "SVProgressHUD.h"

#define sreenWidth [UIScreen mainScreen].bounds.size.width
#define sreenHeight [UIScreen mainScreen].bounds.size.height


#define REGEX_USER_NAME_LIMIT @"^.{3,10}$"
#define REGEX_USER_HEIGH @"[0-9]"
#define REGEX_USER_WEIGHT @"[0-9]"
#define REGEX_EMAIL @"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
#define REGEX_PASSWORD_LIMIT @"^.{6,20}$"
#define REGEX_PASSWORD @"[A-Za-z0-9]{6,20}"
#define REGEX_PHONE_DEFAULT @"[0-9]{3}\\-[0-9]{3}\\-[0-9]{4}"

#define viewCornerRadius 5.0
@interface YFRegsiterVC (){
    IBOutlet TextFieldValidator *userName;
    IBOutlet TextFieldValidator *userHeigh;
    IBOutlet TextFieldValidator *userWeight;
    IBOutlet TextFieldValidator *userPassword;
    IBOutlet TextFieldValidator *userComfirmPassword;
    
}


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

//界面上的UI设置
    //隐藏导航栏
    self.navigationController.navigationBarHidden = NO;
    _scrollView.frame = CGRectMake(0, 0, sreenWidth, 600);
    //[_scrollView setContentSize:CGSizeMake(width, 600)];
    [_scrollView setContentSize:CGSizeMake(sreenWidth, 570)];
    _scrollView.center = CGPointMake(sreenWidth/2, _scrollView.frame.size.height/2);
    
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
//验证要求
    [self setupAlerts];
    
}

#pragma mark - 登陆输入验证

-(void)setupAlerts{
    
    
    [userName addRegx:REGEX_EMAIL withMsg:@"请输入有效地电子邮箱"];
    
    [userPassword addRegx:REGEX_PASSWORD withMsg:@"请输入6~10位长度的密码"];
    [userComfirmPassword addConfirmValidationTo:userPassword withMsg:@"请与上次输入的密码保持一致"];
    [userHeigh addRegx:REGEX_USER_HEIGH withMsg:@"请输入2~3位数字"];
    [userWeight addRegx:REGEX_USER_WEIGHT withMsg:@"请输入2~3位数字"];
    
 
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
    if([userName validate] & [userWeight validate] & [userHeigh validate]& [userComfirmPassword validate]& [userPassword validate]){
        [SVProgressHUD showSuccessWithStatus:@"注册成功，请返回登陆界面"];
        
    }
    
}


@end
