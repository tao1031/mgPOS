//
//  RTLoginUser.h
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/29.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTLoginUser : NSObject

@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, assign) NSString *userName;
@property (nonatomic, assign) NSString *userImage;


+ (instancetype)RTGlobalUser;
- (void)setLoginUser:(NSDictionary *)userData;
- (void)userLogout;
- (BOOL)userIsLogin;
- (NSString *)getUserName;
- (NSString *)getUserImage;

@end
