//
//  RTMenuCollection.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/9/20.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenuCollection.h"
#import "RTViewLayer.h"
#import "RTMenuItemCollectionCell.h"
#import "RTLoginUser.h"

@interface RTMenuCollection ()
{
    RTLoginUser *loginUser;
}
@property (weak, nonatomic) IBOutlet UILabel *labUsername;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserphoto;
@property (weak, nonatomic) IBOutlet UIButton *btnLogout;

@end

@implementation RTMenuCollection

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self defInit];
    [self initLoadMenuData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)defInit{
    [RTViewLayer viewCornerRadius:self.btnLogout];
    loginUser = [RTLoginUser RTGlobalUser];
    self.labUsername.text = [loginUser getUserName];
    self.imgUserphoto.image = [UIImage imageNamed:[loginUser getUserImage]];
}

-(void)initLoadMenuData{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Menu" ofType:@"plist"];
    self.menuItemData = [NSMutableArray array];
    NSArray *ls = [NSArray arrayWithContentsOfFile:plistPath];
    for (NSDictionary *dict in ls) {
        if ([dict[@"valid"] boolValue]) {
            [self.menuItemData addObject:dict];
        }
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.menuItemData.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RTMenuItemCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RTMenuItemCollectionCell" forIndexPath:indexPath];
    [cell updateView:[self.menuItemData objectAtIndex:indexPath.row]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(menuDidSelected:)]) {
        NSDictionary *menu = self.menuItemData[indexPath.row];
        [self.delegate menuDidSelected:menu];
    }
}
- (IBAction)actLogout:(id)sender {
    if ([self.delegate respondsToSelector:@selector(menuDidLogout)]) {
        [self.delegate menuDidLogout];
    }
}

@end
