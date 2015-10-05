//
//  YFLoginVC.m
//  YF002
//
//  Created by Mushroom on 9/28/15.
//  Copyright (c) 2015 Mushroom. All rights reserved.
//

#import "YFLoginVC.h"
#import "MHTextField.h"
#import "SVProgressHUD.h"

@interface YFLoginVC (){
 
}


@property (weak, nonatomic) IBOutlet UIView *userBackground;
@property (weak, nonatomic) IBOutlet UIView *passWordBackground;
@property (weak, nonatomic) IBOutlet UITextField *userName;

@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *logoinBtn;
- (IBAction)logoinBtb:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *gotoHome;

- (IBAction)GotoHome:(id)sender;

@end

@implementation YFLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
   // [_userName setRequired:YES];
   // [_password setRequired:YES];
    _userBackground.layer.cornerRadius = 6.0;
    _passWordBackground.layer.cornerRadius = 6.0;
    _logoinBtn.layer.cornerRadius = 6.0;
    _gotoHome.layer.cornerRadius = 3.0;
    //self.navigationController.navigationBar.translucent = NO;
   // [self.navigationController.navigationBar ];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void) viewDidAppear:(BOOL)animated{
    
    //隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
//    self.scrollView.frame = CGRectMake(0, 0, 320, 480);
//    
//    [self.scrollView setContentSize:CGSizeMake(320, 1000)];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 解决虚拟键盘挡住UITextField的方法

- (void)keyboardWillShow:(NSNotification *)aNotification


{
    NSDictionary *userInfo = [aNotification userInfo];
    
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]
                           
                           CGRectValue];
    NSTimeInterval animationDuration = [[userInfo
                                         
                                         objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect newFrame = self.view.frame;
    newFrame.size.height -= keyboardRect.size.height;
    
    [UIView beginAnimations:@"ResizeTextView" context:nil];
    [UIView setAnimationDuration:0.3f];
    
    self.view.frame = newFrame;  
    
    [UIView commitAnimations];  
}
/*
- (void)keyboardWillShow:(NSNotification *)noti
{
    //键盘输入的界面调整
    //键盘的高度
    float height = 265.0;
    CGRect frame = self.view.frame;
    frame.size = CGSizeMake(frame.size.width, frame.size.height - height);
    [UIView beginAnimations:@"Curl"context:nil];//动画开始
    [UIView setAnimationDuration:0.30];
    [UIView setAnimationDelegate:self];
    [self.view setFrame:frame];
    [UIView commitAnimations];
}
*/
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 265.0);//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    if(offset > 0)
    {
        CGRect rect = CGRectMake(0.0f, -offset,width,height);
        self.view.frame = rect;
    }
    [UIView commitAnimations];
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
    
    [SVProgressHUD showSuccessWithStatus:@"准备登陆"];
    [self performSelector:@selector(GotoHome:) withObject:nil afterDelay:1.5f];
   
}
 #pragma mark 跳过注册
- (IBAction)GotoHome:(id)sender {
    UIStoryboard *home = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.view.window.rootViewController = home.instantiateInitialViewController;
}
@end
