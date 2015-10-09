//
//  YFMailVC.m
//  YF002
//
//  Created by Mushroom on 10/7/15.
//  Copyright (c) 2015 Mushroom. All rights reserved.
//

#import "YFMailVC.h"
#import <MessageUI/MessageUI.h> 
@interface YFMailVC () <MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>

@end

@implementation YFMailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 邮件服务器
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    // 设置邮件代理
    [mailCompose setMailComposeDelegate:self];
    NSDateFormatter *nowFormatter= [[NSDateFormatter alloc] init];
    [nowFormatter setDateFormat:@"yyyyMMdd"];
    NSString *date =  [nowFormatter stringFromDate:[NSDate date]];
    NSString *nameSubject = [NSString stringWithFormat:@"纪录备份(%@)",date ] ;
    // 设置邮件主题
    [mailCompose setSubject:nameSubject];
    
    // 设置收件人
    [mailCompose setToRecipients:@[@"邮箱号码"]];
    // 设置抄送人
    [mailCompose setCcRecipients:@[@"邮箱号码"]];
    // 设置密抄送
    [mailCompose setBccRecipients:@[@"邮箱号码"]];
    
    /**
     *  设置邮件的正文内容
     */
    NSString *emailContent = @"请填写邮箱地址，并点击发送以便保持你的备份。";
    // 是否为HTML格式
    [mailCompose setMessageBody:emailContent isHTML:NO];
    // 如使用HTML格式，则为以下代码
    //    [mailCompose setMessageBody:@"<html><body><p>Hello</p><p>World！</p></body></html>" isHTML:YES];
    
    /**
     *  添加附件
     */
    //读取治疗记录文件
    NSString *plistPath1;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    plistPath1 = [rootPath stringByAppendingPathComponent:@"treatHistory.plist"];
    //判断是否存在记录的文件，没有的话建文件
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath1] ) {
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm createFileAtPath:plistPath1 contents:nil attributes:nil];
    }
    NSData *pdf = [NSData dataWithContentsOfFile:plistPath1];
    
    
    //把附件添加到邮件附件中
    [mailCompose addAttachmentData:pdf mimeType:@"" fileName:nameSubject];
    
    // 弹出邮件发送视图
    [self presentViewController:mailCompose animated:YES completion:nil];
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
