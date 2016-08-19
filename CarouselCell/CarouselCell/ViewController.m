//
//  ViewController.m
//  scroll
//
//  Created by 曹鹏旭 on 16/1/4.
//  Copyright © 2016年 cdbsj. All rights reserved.
//

#import "ViewController.h"
#import "CarouselCell.h"

@interface ViewController ()
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
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CarouselCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    // 防止上下滚动Cell时图片有时候会卡在中间位置的问题
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CarouselCell" owner:nil options:nil];
    CarouselCell *cell = [array lastObject];
    
//    while (cell.contentView.subviews) {
//        <#statements#>
//    }
    
    [cell addImageSetCount:5 Height:150];
    cell.completion = ^(NSInteger page){
        
        // 跳转到下一个控制器
        NSLog(@"%ld", (long)page);
    };
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}



@end


