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
} httpMethod;

extern const NSString *host_URL;
extern const NSString *accountInfo_URL;
extern const NSString *login_URL;
/*extern const NSString *getiOSSetting_URL;
extern const NSString *login_URL;
extern const NSString *logout_URL;
extern const NSString *forgetPassword_URL;
extern const NSString *createPlayer_URL;
extern const NSString *getPlayerInfo_URL;
extern const NSString *getLeaderBoard_URL;
extern const NSString *getStoreInfo_URL;
extern const NSString *getMatches_URL;
extern const NSString *getThemes_URL;
extern const NSString *setTheme_URL;
extern const NSString *getHistoryScore_URL;
extern const NSString *modifyPlayerInfo_URL;
extern const NSString *joinMatch_URL;
extern const NSString *joinNetworkGame_URL;
extern const NSString *bindCard_URL;
extern const NSString *unbindCard_URL;
extern const NSString *getCards_URL;

extern const NSString *GOOGLE_API_KEY;

extern const NSString *AWS_ACCESS_KEY_ID;
extern const NSString *AWS_ACCESS_KEY_SECRET;
extern const NSString *AWS_BUCKET_NAME;*/

@interface urlAPIHelper : NSObject

+ (NSString*)stringForHttpMethod:(httpMethod)method;
+ (NSString*)md5:(NSString*)src;
+(float) getFloatValue:(NSNumber*)number;
+(int) getIntValue:(NSNumber*)number;
+(NSString *) getAPIErrorString:(NSString*)errorCode;
@end

#endif /* urlAPIHelper_h */
