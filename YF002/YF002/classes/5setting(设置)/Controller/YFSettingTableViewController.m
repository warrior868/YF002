//
//  YFSettingTableViewController.m
//  YF002
//
//  Created by Mushroom on 5/31/15.
//  Copyright (c) 2015 Mushroom. All rights reserved.
//

#import "YFSettingTableViewController.h"
#import <MessageUI/MessageUI.h>

@interface YFSettingTableViewController () <MFMailComposeViewControllerDelegate >

@end

@implementation YFSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //tableview分割线不显示
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10.0;
    } else {
        return 0;
    }
}

#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 2) {
        [self sendEmailAction];
        NSLog(@"选中了 %ld", (long)indexPath.row);
    }
    
}
#pragma mark - Mail 方法
- (void)sendEmailAction
{
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
    //[mailCompose setToRecipients:@[@"邮箱号码"]];
    // 设置抄送人
    //[mailCompose setCcRecipients:@[@"邮箱号码"]];
    // 设置密抄送
    //[mailCompose setBccRecipients:@[@"邮箱号码"]];
    
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


- (void) sendProblem{
    // 邮件服务器
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    // 设置邮件代理
    [mailCompose setMailComposeDelegate:self];
    NSDateFormatter *nowFormatter= [[NSDateFormatter alloc] init];
    [nowFormatter setDateFormat:@"yyyyMMdd"];
    NSString *date =  [nowFormatter stringFromDate:[NSDate date]];
    NSString *nameSubject = [NSString stringWithFormat:@"问题反馈(%@)",date ] ;
    // 设置邮件主题
    [mailCompose setSubject:nameSubject];
    
    // 设置收件人
    [mailCompose setToRecipients:@[@"yonggang_xu@126.com"]];
    // 设置抄送人
    [mailCompose setCcRecipients:@[@"邮箱号码"]];
    // 设置密抄送
    [mailCompose setBccRecipients:@[@"邮箱号码"]];
    
    /**
     *  设置邮件的正文内容
     */
    NSString *emailContent = @"建议和意见时 请表述问题且提出大概想法 ";
    // 是否为HTML格式
    [mailCompose setMessageBody:emailContent isHTML:NO];
    // 如使用HTML格式，则为以下代码
    //    [mailCompose setMessageBody:@"<html><body><p>Hello</p><p>World！</p></body></html>" isHTML:YES];
    
    /**
     *  添加附件
     */

    
    // 弹出邮件发送视图
    [self presentViewController:mailCompose animated:YES completion:nil];
}
#pragma mark - Mail 操作反馈（是否取消或保存）
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled: // 用户取消编辑
            NSLog(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved: // 用户保存邮件
            NSLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent: // 用户点击发送
            NSLog(@"Mail sent...");
            break;
        case MFMailComposeResultFailed: // 用户尝试保存或发送邮件失败
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
    }
    
    // 关闭邮件发送视图
    [self dismissViewControllerAnimated:YES completion:nil];


    }

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
