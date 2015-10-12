//
//  YFChooseParameterVC.m
//  YF002
//
//  Created by Mushroom on 10/2/15.
//  Copyright (c) 2015 Mushroom. All rights reserved.
//

#import "YFChooseParameterVC.h"
#define width [UIScreen mainScreen].bounds.size.width
#define height [UIScreen mainScreen].bounds.size.height
@interface YFChooseParameterVC ()
@property (weak, nonatomic) IBOutlet UIView *mainView;

- (IBAction)byUser:(id)sender;
- (IBAction)byRecommend:(id)sender;
- (IBAction)byPrevious:(id)sender;


@end

@implementation YFChooseParameterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //隐藏导航栏
    self.navigationController.navigationBarHidden = YES ;
    _mainView.frame = CGRectMake((width-200)/2, (height-300)/2, 200, 300);
    _mainView.layer.cornerRadius = 10.0;
    _mainView.layer.masksToBounds = YES;
    _mainView.layer.shadowColor=[UIColor grayColor].CGColor;
    _mainView.layer.shadowOffset=CGSizeMake(10, 10);
    _mainView.layer.shadowOpacity=0.15;
    // Do any additional setup after loading the view.
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

- (IBAction)byUser:(id)sender {
         NSString *a = @"1";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeNameNotification" object:self userInfo:@{@"value":a}];
        [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)byRecommend:(id)sender {
    NSString *a = @"2";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeNameNotification" object:self userInfo:@{@"value":a}];
        [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)byPrevious:(id)sender {
    NSString *a = @"3";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeNameNotification" object:self userInfo:@{@"value":a}];
        [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
