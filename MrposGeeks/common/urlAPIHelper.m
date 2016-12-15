//
//  urlAPIHelper.m
//  testProtoType
//
//  Created by Admin on 2016/7/26.
//  Copyright © 2016年 Admin. All rights reserved.
//

#import "urlAPIHelper.h"
#import <CommonCrypto/CommonDigest.h>

NSString *host_URL              = SERVICE_URL;
NSString *accountInfo_URL       = SERVICE_URL@"/account/info/last_modified:{1}";
NSString *login_URL             = SERVICE_URL@"/account/login";
NSString *boardInfo_URL         = SERVICE_URL@"/board/info/last_modified:{last_modified}";
NSString *createArea_URL        = SERVICE_URL@"/board/area";
NSString *modifyArea_URL        = SERVICE_URL@"/board/area/id:{id}";
NSString *deleteArea_URL        = SERVICE_URL@"/board/area/id:{id}";
NSString *createBoard_URL       = SERVICE_URL@"/board/board";
NSString *modifyBoard_URL       = SERVICE_URL@"/board/board/";
NSString *deleteBoard_URL       = SERVICE_URL@"/board/board/";


@implementation urlAPIHelper

+ (NSString*)md5:(NSString*)src{
    const char *cStr = [src UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), result );
    return [NSString
            stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1],
            result[2], result[3],
            result[4], result[5],
            result[6], result[7],
            result[8], result[9],
            result[10], result[11],
            result[12], result[13],
            result[14], result[15]
            ];
}


+ (NSString*)stringForHttpMethod:(httpMethod)method {
    if( http_GET == method) return @"GET";
    else if( http_POST == method) return @"POST";
    else
        return @"GET";
}


+(float) getFloatValue:(NSNumber*)number {
    if( nil == number || [number isEqual:[NSNull null]] ) { return 0.0f; }
    return number.floatValue;
}

+(int) getIntValue:(NSNumber*)number {
    if( nil == number || [number isEqual:[NSNull null]] ) { return 0; }
    return number.intValue;
}

+(NSString *) getAPIErrorString:(NSString*)errorCode {
    NSString *key = [NSString stringWithFormat:@"%@@api_error", errorCode];
    return NSLocalizedString(key, nil);
}

@end
