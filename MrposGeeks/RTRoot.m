//
//  RTRootViewController.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/8/18.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTRoot.h"
#import "AppDelegate.h"
#import "RTAlertView.h"
#import "RTLogin.h"
#import "RTMenu.h"
#import "RTNavigationController.h"
#import "RTMenuCollection.h"
#import "RTLoginUser.h"

//暫放
#import "RTDatabaseCore.h"

@interface RTRoot ()<RTMenuCollectionDelegate>
{
    AppDelegate *mainDelegate;
    RTLoginUser *loginUser;
}
@property (strong, nonatomic) UIViewController *container;
@property (strong, nonatomic) UIViewController *current;
@end

@implementation RTRoot

- (void)viewDidLoad {
    [super viewDidLoad];
    [self defInit];
    [self setMenuViewSize:CGSizeMake(360.0f, self.view.frame.size.height)];  //選單大小
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // NavigationController初始
    UIStoryboard *sbSetting = [UIStoryboard storyboardWithName:@"RTMenuIndex" bundle:nil];
    RTNavigationController *nav = [sbSetting instantiateViewControllerWithIdentifier:@"RTNavigationController"];
    self.container = nav.topViewController;
    self.contentViewController = nav;
    
    // 進入點ViewControll初始
    UIStoryboard *sbRootMenu = [UIStoryboard storyboardWithName:@"RTRootMenu" bundle:nil];
    //RTMenu *menuCtrl = [sbRootMenu instantiateViewControllerWithIdentifier:@"menuControllerTable"];
    RTMenuCollection *menuCtrl = [sbRootMenu instantiateViewControllerWithIdentifier:@"menuControllerCollection"];
    
    menuCtrl.delegate = self;
    self.menuViewController = menuCtrl;
    
    // 設定初始值標題與被點選項目
    nowChooseMenuItem = [menuCtrl.menuItemData objectAtIndex:0];
    self.container.navigationItem.title = NSLocalizedString([nowChooseMenuItem objectForKey:@"title"], nil);
}

-(void)defInit{
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    loginUser = [RTLoginUser RTGlobalUser];
}

- (void)menuDidSelected:(NSDictionary *)menu {
    // 判斷若點選後為同一選項，不換頁
    if ([nowChooseMenuItem objectForKey:@"id"] != [menu objectForKey:@"id"]) {
        nowChooseMenuItem = menu;
        [self chooseMenuItem:[nowChooseMenuItem objectForKey:@"id"]];
    }
    // 隱藏選單
    [self hideMenuViewController];
}

-(void)menuDidLogout{
    // 登出
    [loginUser userLogout];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"RTLogin" bundle:nil];
    RTLogin *mainview = [sb instantiateViewControllerWithIdentifier:@"RTLogin"];
    mainDelegate.window.rootViewController = mainview;
    [UIView transitionWithView:mainDelegate.window
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{ mainDelegate.window.rootViewController = mainview; }
                    completion:nil];
}

-(void)chooseMenuItem:(NSString *)menuId{
    // 切換選單，項目增加需人工處理
    if ([menuId isEqualToString:@"menuIndex"]) {
        // 首頁
        UIStoryboard *sbSetting = [UIStoryboard storyboardWithName:@"RTMenuIndex" bundle:nil];
        RTNavigationController *nav = [sbSetting instantiateViewControllerWithIdentifier:@"RTNavigationController"];
        self.container = nav.topViewController;
        self.contentViewController = nav;
        self.current = [sbSetting instantiateViewControllerWithIdentifier:@"RTMenuIndex"];
    }else if ([menuId isEqualToString:@"menuOrder"]) {
        // 點餐
        UIStoryboard *sbSetting = [UIStoryboard storyboardWithName:@"RTMenuOrder" bundle:nil];
        RTNavigationController *nav = [sbSetting instantiateViewControllerWithIdentifier:@"RTNavigationController"];
        self.container = nav.topViewController;
        self.contentViewController = nav;
        self.current = [sbSetting instantiateViewControllerWithIdentifier:@"RTMenuOrder"];
    }else if ([menuId isEqualToString:@"menuPackage"]) {
        // 套餐設定
        UIStoryboard *sbSetting = [UIStoryboard storyboardWithName:@"RTMenuPackage" bundle:nil];
        RTNavigationController *nav = [sbSetting instantiateViewControllerWithIdentifier:@"RTNavigationController"];
        self.container = nav.topViewController;
        self.contentViewController = nav;
        self.current = [sbSetting instantiateViewControllerWithIdentifier:@"RTMenuPackage"];
    }else if ([menuId isEqualToString:@"menuDish"]) {
        // 餐點設定
        UIStoryboard *sbSetting = [UIStoryboard storyboardWithName:@"RTMenuDish" bundle:nil];
        RTNavigationController *nav = [sbSetting instantiateViewControllerWithIdentifier:@"RTNavigationController"];
        self.container = nav.topViewController;
        self.contentViewController = nav;
        self.current = [sbSetting instantiateViewControllerWithIdentifier:@"RTMenuDish"];
    
    }
    else if ([menuId isEqualToString:@"menuDishOption"]) {
        // 餐點選項設定
        UIStoryboard *sbSetting = [UIStoryboard storyboardWithName:@"RTMenuDishOption" bundle:nil];
        RTNavigationController *nav = [sbSetting instantiateViewControllerWithIdentifier:@"RTNavigationController"];
        self.container = nav.topViewController;
        self.contentViewController = nav;
        self.current = [sbSetting instantiateViewControllerWithIdentifier:@"RTMenuDishOption"];
    }
    else if ([menuId isEqualToString:@"menuDesktop"]) {
        // 桌次設定
        UIStoryboard *sbSetting = [UIStoryboard storyboardWithName:@"RTMenuDesktop" bundle:nil];
        RTNavigationController *nav = [sbSetting instantiateViewControllerWithIdentifier:@"RTNavigationController"];
        self.container = nav.topViewController;
        self.contentViewController = nav;
        self.current = [sbSetting instantiateViewControllerWithIdentifier:@"RTMenuDesktop"];
    }
    else if ([menuId isEqualToString:@"menuSystem"]) {
        // 系統設定
        UIStoryboard *sbSetting = [UIStoryboard storyboardWithName:@"RTMenuSystem" bundle:nil];
        RTNavigationController *nav = [sbSetting instantiateViewControllerWithIdentifier:@"RTNavigationController"];
        self.container = nav.topViewController;
        self.contentViewController = nav;
        self.current = [sbSetting instantiateViewControllerWithIdentifier:@"RTMenuSystem"];
    }else if ([menuId isEqualToString:@"menuLogout"]) {
        // 登出
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"RTLogin" bundle:nil];
        RTLogin *mainview = [sb instantiateViewControllerWithIdentifier:@"RTLogin"];
        mainDelegate.window.rootViewController = mainview;
        [UIView transitionWithView:mainDelegate.window
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{ mainDelegate.window.rootViewController = mainview; }
                        completion:nil];
    }else if ([menuId isEqualToString:@"menuClearDB"]) {
        // 資料庫初始化
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:@""
                                    message:NSLocalizedString(@"resetForSure", @"確定重置嗎?")
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"buttonSure", @"確定") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            RTDatabaseCore *rtDb = [[RTDatabaseCore alloc] init];
            [rtDb deleteDB];
            [rtDb initialized];
            
            [RTAlertView
             showAlert:NSLocalizedString(@"", @"")
             message:NSLocalizedString(@"resetIsSuccess", @"重置成功")
             button:NSLocalizedString(@"buttonSure", @"確定")
             ];
        }];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"buttonCancle", @"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
        }];
        [alert addAction:cancleAction];
        [alert addAction:sureAction];
        UIViewController *selfViewControll = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        [selfViewControll presentViewController:alert animated:YES completion:nil];
    }
    self.container.navigationItem.title = NSLocalizedString([nowChooseMenuItem objectForKey:@"title"], nil);
}


// 舊版本處理ViewControll層級問題，先暫時預留，待觀察記憶體並沒問題可移除
//- (void)setCurrent:(UIViewController *)current
//{
//    if (_current) {
//        [_current.view removeFromSuperview];
//        [_current removeFromParentViewController];
//    }
//    _current = current;
//    if (_current) {
//        [self.container addChildViewController:_current];
//        _current.view.frame = self.container.view.bounds;
//        [self.container.view insertSubview:_current.view atIndex:999];
//        [_current didMoveToParentViewController:self.container];
//    }
//}

@end
