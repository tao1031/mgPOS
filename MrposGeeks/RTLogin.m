//
//  RTLogin.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/8/31.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTLogin.h"
#import "AppDelegate.h"
#import "RTDatabaseCore.h"
#import "RTStringCheck.h"
#import "AESCrypt.h"
#import "RTAlertView.h"
#import "RTViewLayer.h"
#import "RTRoot.h"
#import "RTLoginUserCell.h"
#import "RTLoginUser.h"

@interface RTLogin ()<UICollectionViewDataSource, UICollectionViewDelegate>
{
    AppDelegate *mainDelegate;
    RTDatabaseCore *rtDatabase;
    RTStringCheck *rtStringCheck;
    NSArray *userArray;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgChooseUser;
@property (weak, nonatomic) IBOutlet UILabel *labUserName;
@property (weak, nonatomic) IBOutlet UITextField *textPassword;
@end

@implementation RTLogin

- (void)viewDidLoad {
    [super viewDidLoad];
    [self defInit];
    [self defDataLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)defInit{
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    rtDatabase = [[RTDatabaseCore alloc] init];
    rtStringCheck = [[RTStringCheck alloc] init];
    
    //處理圓角框線
    [RTViewLayer viewCornerRadius:self.textPassword];
    [RTViewLayer viewCornerBorderWidth:self.textPassword setBorderWidth:1];
    [RTViewLayer viewCornerBorderColor:self.textPassword setBorderColor:[UIColor colorWithRed:0.0f/255.0f green:59.0f/255.0f blue:84.0f/255.0f alpha:0.2f]];
    
}

-(void)defDataLoad{
    self.labUserName.text = @"";
    self.textPassword.text = @"";
    
    //測試開發
    self.imgChooseUser.image = [UIImage imageNamed:@"01_defaultphoto"];
    self.labUserName.text = @"admin";
    self.textPassword.text = @"123456";
    
    NSString *sqlstr = @"";
    // 讀取使用者列表
    sqlstr = @"select * from `users` where `status`=1 order by `sort`, `uid`";
    userArray = [rtDatabase selectSub:sqlstr];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return userArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RTLoginUserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RTLoginUserCell" forIndexPath:indexPath];
    [cell updateView:[userArray objectAtIndex:indexPath.row]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.labUserName.text = [[userArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    self.imgChooseUser.image = [UIImage imageNamed:[[userArray objectAtIndex:indexPath.row] objectForKey:@"userimage"]];
}

- (IBAction)actNumber0:(id)sender {
    self.textPassword.text = [NSString stringWithFormat:@"%@0",self.textPassword.text];
}
- (IBAction)actNumber1:(id)sender {
    self.textPassword.text = [NSString stringWithFormat:@"%@1",self.textPassword.text];
}
- (IBAction)actNumber2:(id)sender {
    self.textPassword.text = [NSString stringWithFormat:@"%@2",self.textPassword.text];
}
- (IBAction)actNumber3:(id)sender {
    self.textPassword.text = [NSString stringWithFormat:@"%@3",self.textPassword.text];
}
- (IBAction)actNumber4:(id)sender {
    self.textPassword.text = [NSString stringWithFormat:@"%@4",self.textPassword.text];
}
- (IBAction)actNumber5:(id)sender {
    self.textPassword.text = [NSString stringWithFormat:@"%@5",self.textPassword.text];
}
- (IBAction)actNumber6:(id)sender {
    self.textPassword.text = [NSString stringWithFormat:@"%@6",self.textPassword.text];
}
- (IBAction)actNumber7:(id)sender {
    self.textPassword.text = [NSString stringWithFormat:@"%@7",self.textPassword.text];
}
- (IBAction)actNumber8:(id)sender {
    self.textPassword.text = [NSString stringWithFormat:@"%@8",self.textPassword.text];
}
- (IBAction)actNumber9:(id)sender {
    self.textPassword.text = [NSString stringWithFormat:@"%@9",self.textPassword.text];
}
- (IBAction)actNumberClear:(id)sender {
    self.textPassword.text = @"";
}

- (IBAction)actLogin:(id)sender {
    NSString *account = self.labUserName.text;
    NSString *passwd = self.textPassword.text;
    
    if ([rtStringCheck checkAlphaNumber:account] && [rtStringCheck checkNumber:passwd]) {
        passwd = [AESCrypt MD5:passwd];
        NSString *sqlstr = [NSString stringWithFormat:@"select * from `users` where `status`=1 and `name` like '%@' and `pwd` like '%@'",account,passwd];
        NSDictionary *loadUser = [rtDatabase selectSubForFirst:sqlstr];
        if ([rtStringCheck checkNumber:[loadUser objectForKey:@"uid"]]) {
            RTLoginUser *loginUser = [RTLoginUser RTGlobalUser];
            [loginUser setLoginUser:loadUser];
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"RTRootMenu" bundle:nil];
            RTRoot *mainview = [sb instantiateViewControllerWithIdentifier:@"rootController"];

            
            mainDelegate.window.rootViewController = mainview;
            [UIView transitionWithView:mainDelegate.window
                              duration:0.5
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{ mainDelegate.window.rootViewController = mainview; }
                            completion:nil];
        }else{
            [RTAlertView
                showAlert:NSLocalizedString(@"", @"")
                message:NSLocalizedString(@"loginIsError", @"帳號密碼錯誤")
                button:NSLocalizedString(@"buttonSure", @"確定")
             ];
        }
    }else{
        [RTAlertView
            showAlert:NSLocalizedString(@"", @"")
            message:NSLocalizedString(@"loginIsNull", @"請輸入帳號密碼")
            button:NSLocalizedString(@"buttonSure", @"確定")
         ];
    }
}

@end
