//
//  YFLoginVC.m
//  YF002
//
//  Created by Mushroom on 9/28/15.
//  Copyright (c) 2015 Mushroom. All rights reserved.
//

#import "YFLoginVC.h"
#import "MHTextField.h"

#import "TextFieldValidator.h"
#import "SVProgressHUD.h"




#define REGEX_USER_NAME  @"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
#define REGEX_PASSWORD_LIMIT @"^.{6,20}$"
#define REGEX_PASSWORD @"[A-Za-z0-9]{6,20}"


#define sreenWidth [UIScreen mainScreen].bounds.size.width
#define srennHeight [UIScreen mainScreen].bounds.size.height

@interface YFLoginVC (){
 
IBOutlet TextFieldValidator *userName;
    
IBOutlet TextFieldValidator *password;
}


@property (weak, nonatomic) IBOutlet UIView *userBackground;
@property (weak, nonatomic) IBOutlet UIView *passWordBackground;

@property (weak, nonatomic) IBOutlet UIButton *logoinBtn;
- (IBAction)logoinBtb:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *gotoHome;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)GotoHome:(id)sender;

@end

@implementation YFLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //界面上的UI设置
    
    _scrollView.frame = CGRectMake(0, 0, sreenWidth, 500);
    //[_scrollView setContentSize:CGSizeMake(width, 600)];
    _userBackground.layer.cornerRadius = 6.0;
    _passWordBackground.layer.cornerRadius = 6.0;
    _logoinBtn.layer.cornerRadius = 6.0;
    _gotoHome.layer.cornerRadius = 3.0;
   //验证要求
    [self setupAlerts];
}

-(void) viewDidAppear:(BOOL)animated{
    
//隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
    //判断是否是新版本，出现相应地新特性
     NSString *key = @"CFBundleVersion";
    
    // 取出沙盒中存储的上次使用软件的版本号
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults stringForKey:key];
    
    // 获得当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
    if ([currentVersion isEqualToString:lastVersion]) {
        
    }
    else { // 新版本
        
        // 存储新版本
        [defaults setObject:currentVersion forKey:key];
        [defaults synchronize];
        // 跳转到新特性控制器
        //Create Panel From Nib
        MYIntroductionPanel *panel1 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) nibNamed:@"NewFeatureView1"];
        MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) nibNamed:@"NewFeatureView2"];
        MYIntroductionPanel *panel3 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) nibNamed:@"NewFeatureView3"];
        //Add panels to an array
        NSArray *panels = @[panel1, panel2, panel3];
        
        //Create the introduction view and set its delegate
        MYBlurIntroductionView *introductionView = [[MYBlurIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        introductionView.delegate = self;
        introductionView.BackgroundImageView.image = [UIImage imageNamed:@"guide3"];
        [introductionView setBackgroundColor:[UIColor colorWithRed:90.0f/255.0f green:175.0f/255.0f blue:113.0f/255.0f alpha:0.65]];
        
        //Build the introduction with desired panels
        [introductionView buildIntroductionWithPanels:panels];
        
        //Add the introduction to your view
        [self.view addSubview:introductionView];

    }

   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 登陆输入验证
-(void)setupAlerts{
   
    
    [userName addRegx:REGEX_USER_NAME withMsg:@"输入注册邮箱地址"];
    
    [password addRegx:REGEX_PASSWORD_LIMIT withMsg:@"输入6~10位之间的注册密码"];
     [password addRegx:REGEX_PASSWORD withMsg:@"输入6~10位之间的注册密码"];
    
}
#pragma mark - MYIntroduction Delegate

-(void)introduction:(MYBlurIntroductionView *)introductionView didChangeToPanel:(MYIntroductionPanel *)panel withIndex:(NSInteger)panelIndex{
    NSLog(@"Introduction did change to panel %ld", (long)panelIndex);
    
    //You can edit introduction view properties right from the delegate method!
    //If it is the first panel, change the color to green!
    if (panelIndex == 0) {
        [introductionView setBackgroundColor:[UIColor colorWithRed:90.0f/255.0f green:175.0f/255.0f blue:113.0f/255.0f alpha:0.65]];
    }
    //If it is the second panel, change the color to blue!
    else if (panelIndex == 1){
        [introductionView setBackgroundColor:[UIColor colorWithRed:50.0f/255.0f green:79.0f/255.0f blue:133.0f/255.0f alpha:0.65]];
    }
}

-(void)introduction:(MYBlurIntroductionView *)introductionView didFinishWithType:(MYFinishType)finishType {
    NSLog(@"Introduction did finish");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
 #pragma mark -- 按钮
 #pragma mark 登陆
- (IBAction)logoinBtb:(id)sender {
    
    if([userName validate] & [password validate] ){
        [SVProgressHUD showSuccessWithStatus:@"准备登陆"];
        [self performSelector:@selector(GotoHome:) withObject:nil afterDelay:1.5f];
    }
    
   
}
 #pragma mark 跳过注册
- (IBAction)GotoHome:(id)sender {
    UIStoryboard *home = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.view.window.rootViewController = home.instantiateInitialViewController;
}
@end
