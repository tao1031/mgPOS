//
//  RTLoginUserCell.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/2.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTLoginUserCell.h"


@interface RTLoginUserCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgUserPhoto;
@property (weak, nonatomic) IBOutlet UILabel *labUserName;

@end

@implementation RTLoginUserCell


- (void)updateView:(NSDictionary *)itemData  {
    self.imgUserPhoto.image = [UIImage imageNamed:[itemData objectForKey:@"userimage"]];
    self.labUserName.text = [itemData objectForKey:@"name"];
}

- (void)updateViewByAccountData:(accountData *)itemData {
    self.labUserName.text = itemData.name;
    self.imgUserPhoto.image = [UIImage imageNamed:itemData.photoUrl];
}

@end
