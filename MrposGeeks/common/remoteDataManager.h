//
//  remoteDataManager.h
//  MrposGeeks
//
//  Created by Admin on 2016/12/12.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#ifndef remoteDataManager_h
#define remoteDataManager_h

#import "urlAPIHelper.h"
#import "boardDataMgr.h"


typedef void (^CompletionBlock)(NSData *data, NSURLResponse *response, NSError *error);

@interface remoteDataManager : NSObject<NSURLSessionDelegate> {
    
}

+ (id) instance;

// get info request
- (void) getBoardInfoRequest:(NSString*)lastTimeStamp;


// get info response handler
- (void) getBoardInfoResponseHandler:(NSDictionary*)jsonDict;

-(void) mgAPIRequest:(NSString*)urlStr apiMethod:(httpMethod)method postDataDic:(NSDictionary*)postData CompletionBlock:completionHandler;
@end
#endif /* remoteDataManager_h */
