//
//  accountDataMgr.h
//  MrposGeeks
//
//  Created by Admin on 2016/12/8.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#ifndef accountDataMgr_h
#define accountDataMgr_h


@interface accountDataMgr : NSObject {
    NSMutableArray* accountAry;
}

@property (nonatomic, retain) NSMutableArray *accountAry;

+ (id)instance;
@end


@interface accountData : NSObject {
    NSString* accountId;
    NSString* name;
    NSString* photoUrl;
    
}

@property (nonatomic, retain) NSString* accountId;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* photoUrl;
@end

#endif /* accountDataMgr_h */
