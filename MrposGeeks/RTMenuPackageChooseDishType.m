//
//  RTMenuPackageChooseDishType.m
//  MrposGeeks
//
//  Created by Tseng To-Cheng on 2016/9/13.
//  Copyright © 2016年 任昌 陳. All rights reserved.
//

#import "RTMenuPackageChooseDishType.h"
#import "RTViewLayer.h"
#import "RTMenuPackageChooseDishCell.h"

@interface RTMenuPackageChooseDishType ()

@property (weak, nonatomic) IBOutlet UIView *viewShadow;

@end

@implementation RTMenuPackageChooseDishType

- (void)viewDidLoad {
    [super viewDidLoad];
    [self defInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)defInit{
    [RTViewLayer viewShadow:self.viewShadow setShadowColor:[UIColor colorWithRed:0.0f/255.0f green:59.0f/255.0f blue:84.0f/255.0f alpha:0.6f]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RTMenuPackageChooseDishCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RTMenuPackageChooseDishCell" forIndexPath:indexPath];
    cell.itemData = [self.itemArray objectAtIndex:indexPath.row];
    [cell updateView];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
