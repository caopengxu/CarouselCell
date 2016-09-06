//
//  ViewController.m
//  scroll
//
//  Created by 曹鹏旭 on 16/1/4.
//  Copyright © 2016年 cdbsj. All rights reserved.
//

#import "ViewController.h"
#import "CarouselView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    view.backgroundColor = [UIColor grayColor];
    _tableView.tableHeaderView = view;
    
}



#pragma mark === <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 150;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"Carousel" owner:nil options:nil];
    CarouselView *view = [array lastObject];
    [view addImageSetCount:5 Height:150];
    view.completion = ^(NSInteger page){
        
        // 跳转到下一个控制器
        NSLog(@"%ld", (long)page);
    };
    
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.textLabel.text = @"测试专用";
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}



@end


