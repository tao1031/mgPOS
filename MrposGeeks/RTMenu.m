//
//  RTMenuTableViewController.m
//  MrposGeeks
//
//  Created by 任昌 陳 on 2016/8/18.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenu.h"
#import "RTMenuItemCell.h"

@interface RTMenu ()
    
@end

@implementation RTMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLoadMenuData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(menuDidSelected:)]) {
        NSDictionary *menu = self.menuItemData[indexPath.row];
        [self.delegate menuDidSelected:menu];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuItemData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RTMenuItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RTMenuItemCell" forIndexPath:indexPath];
    [cell updateView:self.menuItemData[indexPath.row]];
    return cell;
}
@end
