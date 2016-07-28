//
//  ViewController.m
//  scroll
//
//  Created by 曹鹏旭 on 16/1/4.
//  Copyright © 2016年 cdbsj. All rights reserved.
//

#import "ViewController.h"
#import "CarouselCell.h"

@interface ViewController () <CarouselCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CarouselCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
}



#pragma mark === <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarouselCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.delegate = self;
    [cell.timer invalidate];
    [cell addImage];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}



#pragma mark ==== <CarouselCellDelegate>
- (NSInteger)carouselCellSetPageCount
{
    return 5;
}
- (NSInteger)carouselCellSetImageHeight
{
    return 150;
}
- (void)carouselCellClickBtn:(UIButton *)btn pageNum:(NSInteger)page
{
    // 跳转到下一个控制器
}



@end


