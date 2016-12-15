//
//  urlAPIHelper.h
//  testProtoType
//
//  Created by Admin on 2016/7/26.
//  Copyright © 2016年 Admin. All rights reserved.
//

#ifndef urlAPIHelper_h
#define urlAPIHelper_h

#import <Foundation/Foundation.h>

#define REMOTE_DATA

#define SERVICE_URL @"http://192.168.1.141:80"

typedef enum httpMethods{
    http_GET,
    http_POST,
    http_PUT,
    http_DELETE,
    http_PATCH,
} httpMethod;

extern const NSString *host_URL;
extern const NSString *accountInfo_URL;
extern const NSString *login_URL;
extern const NSString *boardInfo_URL;
extern const NSString *createArea_URL;
extern const NSString *modifyArea_URL;
extern const NSString *deleteArea_URL;
extern const NSString *createBoard_URL;
extern const NSString *modifyBoard_URL;
extern const NSString *deleteBoard_URL;

@interface urlAPIHelper : NSObject

+ (NSString*)stringForHttpMethod:(httpMethod)method;
+ (NSString*)md5:(NSString*)src;
+(float) getFloatValue:(NSNumber*)number;
+(int) getIntValue:(NSNumber*)number;
+(NSString *) getAPIErrorString:(NSString*)errorCode;
@end

#endif /* urlAPIHelper_h */
