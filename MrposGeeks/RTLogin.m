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
#ifdef REMOTE_DATA
    NSInteger selectedRow;
#endif
}
@property (weak, nonatomic) IBOutlet UIImageView *imgChooseUser;
@property (weak, nonatomic) IBOutlet UILabel *labUserName;
@property (weak, nonatomic) IBOutlet UITextField *textPassword;
@property (weak, nonatomic) IBOutlet UICollectionView *accCollectionView;
#ifdef REMOTE_DATA
-(void)getAccountRequest;
-(void)getAccountResponseHandler:(NSDictionary *)jsonDict;
-(void)loginRequest:(NSString*)accId password:(NSString*)pw;
-(void)loginResponseHandler:(NSDictionary *)jsonDict;
#endif
@end

@implementation RTLogin

- (void)viewDidLoad {
    [super viewDidLoad];
    [self defInit];
#ifdef REMOTE_DATA
    self.labUserName.text = @"";
    self.textPassword.text = @"";
    [self getAccountRequest];
    
#else
    [self defDataLoad];
#endif
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

#ifdef REMOTE_DATA
-(void)getAccountRequest {
    [self mgAPIRequest:(NSString*)accountInfo_URL apiMethod:http_GET postDataDic:nil busyString:@"" CompletionBlock:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error == nil)
        {
            NSDictionary* jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@", jsonObj);
            [self getAccountResponseHandler:jsonObj];
        }
        else {
            NSLog(@"%@", error);
        }
    }];
}

-(void)getAccountResponseHandler:(NSDictionary *)jsonDict {
    NSString* statusCode = [jsonDict objectForKey:@"status"];
    
    if( YES == [statusCode isEqualToString:@"200"] ) {
        NSDictionary* dataDic = [jsonDict objectForKey:@"data"];
        NSArray* accAry = [dataDic objectForKey:@"accounts"];
        accountDataMgr* accMgr = [accountDataMgr instance];
        [accMgr.accountAry removeAllObjects];
        
        for(int i=0; i< accAry.count; i++) {
            NSDictionary* dataDic = accAry[i];
            accountData *newData = [[accountData alloc]init];
            newData.accountId = [dataDic objectForKey:@"id"];
            newData.name = [dataDic objectForKey:@"id"];
            newData.photoUrl = @"01_defaultphoto";
            //newData.photoUrl = [dataDic objectForKey:@"photo"];
            
            [accMgr.accountAry addObject:newData];
        }
        [self.accCollectionView reloadData];
        
    }
    else if( YES == [statusCode isEqualToString:@"304"] ) {
        
    }
    else if( YES == [statusCode isEqualToString:@"400"] ) {
        
    }
    else if( YES == [statusCode isEqualToString:@"403"] ) {
        
    }
    else if( YES == [statusCode isEqualToString:@"500"] ) {
        
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    accountDataMgr* accMgr = [accountDataMgr instance];
    return accMgr.accountAry.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    accountDataMgr* accMgr = [accountDataMgr instance];
    RTLoginUserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RTLoginUserCell" forIndexPath:indexPath];
    accountData* accData = accMgr.accountAry[indexPath.row];
    [cell updateViewByAccountData:accData];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    accountDataMgr* accMgr = [accountDataMgr instance];
    accountData* accData = accMgr.accountAry[indexPath.row];
    
    self.labUserName.text = accData.name;
    self.imgChooseUser.image = [UIImage imageNamed:accData.photoUrl];
    selectedRow = indexPath.row;
}

- (IBAction)actLogin:(id)sender {
    NSString *passwd = self.textPassword.text;
    accountDataMgr* accMgr = [accountDataMgr instance];
    accountData* accData = accMgr.accountAry[selectedRow];
    [self loginRequest:accData.accountId password:passwd];
}

-(void)loginRequest:(NSString*)accId password:(NSString*)pw {
    NSString *busyMsg = @"";
    
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setValue:accId forKey:@"id"];
    [postDic setValue:pw forKey:@"password"];
    
    [self mgAPIRequest:(NSString*)login_URL apiMethod:http_POST postDataDic:postDic busyString:busyMsg CompletionBlock:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error == nil)
        {
            NSDictionary* jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            [self loginResponseHandler:jsonObj];
        }
        else {
            NSLog(@"%@", error);
        }
    }];
}

-(void)loginResponseHandler:(NSDictionary *)jsonDict{
    NSLog(@"%@", jsonDict );
    NSString* statusCode = [jsonDict objectForKey:@"status"];
    
    if( YES == [statusCode isEqualToString:@"200"] ) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"RTRootMenu" bundle:nil];
        RTRoot *mainview = [sb instantiateViewControllerWithIdentifier:@"rootController"];
        
        mainDelegate.window.rootViewController = mainview;
        [UIView transitionWithView:mainDelegate.window
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{ mainDelegate.window.rootViewController = mainview; }
                        completion:nil];
        
        [[remoteDataManager instance] getBoardInfoRequest:@"1"];
    }
    else if( YES == [statusCode isEqualToString:@"304"] ) {
        
    }
    else if( YES == [statusCode isEqualToString:@"400"] ) {
        
    }
    else if( YES == [statusCode isEqualToString:@"403"] ) {
        
    }
    else if( YES == [statusCode isEqualToString:@"500"] ) {
        
    }
}


#else

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


#endif



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
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


@end
