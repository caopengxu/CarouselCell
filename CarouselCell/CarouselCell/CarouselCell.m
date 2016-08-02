//
//  ScrollCell.m
//  scroll
//
//  Created by 曹鹏旭 on 16/1/4.
//  Copyright © 2016年 cdbsj. All rights reserved.
//

#import "CarouselCell.h"
#define __screenWidth [UIScreen mainScreen].bounds.size.width

@interface CarouselCell () <UIScrollViewDelegate>
{
    int _pageCount;
    int _imageHeight;
}
@property (weak, nonatomic) IBOutlet UIScrollView *myScroll;
@property (weak, nonatomic) IBOutlet UIPageControl *myPageControl;
@end



@implementation CarouselCell

#pragma mark === 添加图片
- (void)addImageSetCount:(int)count Height:(int)height
{
    _pageCount = count;
    _imageHeight = height;
    
    self.myPageControl.currentPage = 0;
    [self.myScroll setContentOffset:CGPointMake(__screenWidth, 0)];
    
    self.myPageControl.numberOfPages = _pageCount;
    self.myScroll.contentSize = CGSizeMake((_pageCount + 2) * __screenWidth, 0);
    
    NSString *imageName = [[NSString alloc] init];
    for (int i = 0; i < (_pageCount + 2); i++)
    {
        if (i == 0)
        {
            imageName = [NSString stringWithFormat:@"img_%d", _pageCount - 1];
        }
        else if (i == (_pageCount + 1))
        {
            imageName = @"img_0";
        }
        else
        {
            imageName = [NSString stringWithFormat:@"img_%d", i - 1];
        }
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(__screenWidth * i, 0, __screenWidth, _imageHeight)];
        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        
        [self.myScroll addSubview:btn];
    }
    
    [self startTimer];
}
#pragma mark === 图片的点击
- (void)imageClick:(UIButton *)btn
{
    if (self.completion)
    {
        self.completion(btn.tag);
    }
}



#pragma mark === 开启时钟
- (void)startTimer
{
    self.timer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    // 添加到运行循环
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
#pragma mark === 图片向后滑一页
- (void)updateTimer
{
    // (当前的页数 + 1) % 总页数，防止数值大于总页数
    int page = (self.myPageControl.currentPage + 1) % _pageCount;
    self.myPageControl.currentPage = page;
    
    if (page == 0)
    {
        CGFloat x = (_pageCount + 1) * __screenWidth;
        [self.myScroll setContentOffset:CGPointMake(x, 0) animated:YES];
        
        [self.myScroll setContentOffset:CGPointMake(0, 0)];
    }
    else
    {
        CGFloat x = (self.myPageControl.currentPage + 1) * __screenWidth;
        [self.myScroll setContentOffset:CGPointMake(x, 0) animated:YES];
    }
}



#pragma mark === <UIScrollViewDelegate>
// 当滚动视图停顿时调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 计算页数
    int page = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    if (page == 0)
    {
        [self.myScroll setContentOffset:CGPointMake(__screenWidth * _pageCount, 0)];
        self.myPageControl.currentPage = _pageCount - 1;
    }
    else if (page == _pageCount + 1)
    {
        [self.myScroll setContentOffset:CGPointMake(__screenWidth, 0)];
        self.myPageControl.currentPage = 0;
    }
    else
    {
        self.myPageControl.currentPage = page - 1;
    }
}
#pragma mark === 拽住和松开的时候调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
    
    int page = scrollView.contentOffset.x / scrollView.bounds.size.width;
    if (page == 0)
    {
        self.myPageControl.currentPage = _pageCount - 1;
    }
    else if (page == _pageCount + 1)
    {
        self.myPageControl.currentPage = 0;
    }
    else
    {
        self.myPageControl.currentPage = page - 1;
    }
}



@end


