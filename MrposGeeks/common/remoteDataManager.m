//
//  remoteDataManager.m
//  MrposGeeks
//
//  Created by Admin on 2016/12/12.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "remoteDataManager.h"

/*
 @interface remoteDataManager : NSObject {
 
 }
 
 + (id) instance;
 
 // get info request
 - (void) getBoardInfoRequest:(NSString*)lastTimeStamp;
 
 
 // get info response handler
 - (void) getBoardInfoResponseHandler:(NSDictionary*)jsonDict;
 
 @end
 */

@implementation remoteDataManager

+ (id)instance {
    static remoteDataManager *sharedHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHelper = [[self alloc] init];
    });
    return sharedHelper;
}

- (void) getBoardInfoRequest:(NSString*)lastTimeStamp {
    [self mgAPIRequest:(NSString*)boardInfo_URL apiMethod:http_GET postDataDic:nil CompletionBlock:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error == nil)
        {
            NSDictionary* jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@", jsonObj);
            [self getBoardInfoResponseHandler:jsonObj];
        }
        else {
            NSLog(@"%@", error);
        }
    }];
}

- (void) getBoardInfoResponseHandler:(NSDictionary*)jsonDict {
    NSString* statusCode = [jsonDict objectForKey:@"status"];
    
    if( YES == [statusCode isEqualToString:@"200"] ) {
        NSDictionary* dataDic = [jsonDict objectForKey:@"data"];
        NSString* lastMod = [dataDic objectForKey:@"last_modified"];
        NSArray* areaAry = [dataDic objectForKey:@"areas"];
        boardDataMgr* bdMgr = [boardDataMgr instance];
        [bdMgr.areaAry removeAllObjects];
        
        for(int i=0; i< areaAry.count; i++) {
            NSDictionary* aData = areaAry[i];
            areaData* newData = [[areaData alloc] init];
            newData.areaId = [aData objectForKey:@"id"];
            newData.areaName = [aData objectForKey:@"name"];
            newData.areaNotice = [aData objectForKey:@"notice"];
            NSString* enableString = [aData objectForKey:@"enabled"];
            newData.enable = [enableString isEqualToString:@"Y"];
            NSArray* tableAry = [aData objectForKey:@"boards"];
            for(int j=0; j< tableAry.count; j++) {
                NSDictionary* tData = tableAry[j];
                tableData* newTable = [[tableData alloc] init];
                newTable.areaId = [tData objectForKey:@"a_id"];
                newTable.tabldId = [tData objectForKey:@"id"];
                newTable.tableName = [tData objectForKey:@"name"];
                NSString* tableEnable = [tData objectForKey:@"enabled"];
                newTable.enable = [tableEnable isEqualToString:@"Y"];
                newTable.capacity = [urlAPIHelper getIntValue:[tData objectForKey:@"seat_qty"]];
                NSLog(@"%d", newTable.capacity);
                [newData.tableAry addObject:newTable];
            }
            [bdMgr.areaAry addObject:newData];
        }
        //NSLog(@"%@", lastMod);
        //NSLog(@"%@", areaDic);
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

-(void) mgAPIRequest:(NSString*)urlStr apiMethod:(httpMethod)method postDataDic:(NSDictionary*)postData CompletionBlock:completionHandler {
    
    NSString* webStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL* url = [NSURL URLWithString:webStr];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    defaultConfigObject.timeoutIntervalForRequest = 10.0;
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    if( http_POST == method ) {
        NSString* postStr = @"";
        if(nil != postData) {
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postData
                                                               options:NSJSONWritingPrettyPrinted
                                                                 error:&error];
            
            if (! jsonData) {
                NSLog(@"Got an error: %@", error);
            } else {
                postStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            }
        }
        
        NSData *pData = [postStr dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%tu",[pData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:[urlAPIHelper stringForHttpMethod:method]];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:pData];
        
        NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            CompletionBlock _block;
            _block = [completionHandler copy];
            if(_block) {
                _block(data, response, error);
            }
        }];
        [dataTask resume];
    }
    else if (http_GET == method) {
        NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            CompletionBlock _block;
            _block = [completionHandler copy];
            if(_block) {
                _block(data, response, error);
            }
        }];
        [dataTask resume];
    }
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end
