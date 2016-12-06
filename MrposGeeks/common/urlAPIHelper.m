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
NSString *getiOSSetting_URL     = SERVICE_URL@"/Settings/getiOSSetting";
NSString *login_URL             = SERVICE_URL@"/Users/appLogin";
NSString *logout_URL            = SERVICE_URL@"/Users/appLoginOut";
NSString *forgetPassword_URL    = SERVICE_URL@"/Users/forgotPassword";
NSString *createPlayer_URL      = SERVICE_URL@"/Users/createPlayer";
NSString *getPlayerInfo_URL     = SERVICE_URL@"/Users/getPlayerInfo";
NSString *getLeaderBoard_URL    = SERVICE_URL@"/Match/getLeaderBoard";
NSString *getStoreInfo_URL      = SERVICE_URL@"/Store/getStoreInfo";
NSString *getMatches_URL        = SERVICE_URL@"/Match/getMatches";
NSString *getThemes_URL         = SERVICE_URL@"/Theme/getThemes";
NSString *setTheme_URL          = SERVICE_URL@"/Users/setTheme";
NSString *getHistoryScore_URL   = SERVICE_URL@"/Match/getHistoryScores";
NSString *modifyPlayerInfo_URL  = SERVICE_URL@"/Users/modifyPlayer";
NSString *joinMatch_URL         = SERVICE_URL@"/Match/joinMatch";
NSString *joinNetworkGame_URL   = SERVICE_URL@"/Match/joinNetworkGame";
NSString *bindCard_URL          = SERVICE_URL@"/Users/bindRFIDCard";
NSString *unbindCard_URL        = SERVICE_URL@"/Users/unbindRFIDCard";
NSString *getCards_URL          = SERVICE_URL@"/Users/getRFIDCards";


NSString *GOOGLE_API_KEY        = @"AIzaSyCnRpdg-XPERsvstqMzy2rGCb1Ewf3RaPE";

NSString *AWS_ACCESS_KEY_ID     = @"AKIAICGXGFKXSWVPQD7A";
NSString *AWS_ACCESS_KEY_SECRET = @"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";
NSString *AWS_BUCKET_NAME       = @"fidodartsphoto";
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
