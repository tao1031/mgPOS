//
//  RTLoginUser.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/29.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTLoginUser.h"

@implementation RTLoginUser

static RTLoginUser *loginUser = nil;

- (id)init {
    return self;
}

+ (instancetype)RTGlobalUser
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loginUser = [RTLoginUser new];
        loginUser.isLogin = NO;
        loginUser.userName = @"";
        loginUser.userImage = @"";
    });
    return loginUser;
}

- (void)setLoginUser:(NSDictionary *)userData{
    self.isLogin = YES;
    self.userName = [userData objectForKey:@"name"];
    self.userImage = [userData objectForKey:@"userimage"];
}

- (void)userLogout{
    loginUser.isLogin = NO;
    loginUser.userName = @"";
    loginUser.userImage = @"";
}

- (BOOL)userIsLogin{
    return self.isLogin;
}

- (NSString *)getUserName{
    return self.userName;
}

- (NSString *)getUserImage{
    return self.userImage;
}

@end
