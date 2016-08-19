//
//  ScrollCell.m
//  scroll
//
//  Created by 曹鹏旭 on 16/1/4.
//  Copyright © 2016年 cdbsj. All rights reserved.
//

#import "CarouselCell.h"

#define __screenWidth [UIScreen mainScreen].bounds.size.width

@interface CarouselCell ()
{
    int _pageCount;
    int _imageHeight;
}
@property (weak, nonatomic) IBOutlet UIScrollView *myScroll;
@property (weak, nonatomic) IBOutlet UIPageControl *myPageControl;
@property (nonatomic, strong) dispatch_source_t timer;
@end



@implementation CarouselCell

#pragma mark === 添加图片
- (void)addImageSetCount:(int)count Height:(int)height
{
    _pageCount = count;
    _imageHeight = height;
    
    [self.myScroll setContentOffset:CGPointMake(__screenWidth, 0)];
    self.myPageControl.currentPage = 0;
    
    self.myScroll.contentSize = CGSizeMake((_pageCount + 2) * __screenWidth, 0);
    self.myPageControl.numberOfPages = _pageCount;
    
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
//    self.timer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
//    // 添加到运行循环
//    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    // 执行一次的操作
    /*
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        
        [self updateTimer];
    });
     */
    
    
    
    
    // 获得队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 创建一个定时器(dispatch_source_t本质还是个OC对象)
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 设置定时器的各种属性（几时开始任务，每隔多长时间执行一次）
    // GCD的时间参数，一般是纳秒（1秒 == 10的9次方纳秒）
    // 何时开始执行第一个任务
    // dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC) 比当前时间晚3秒
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    
    // 设置回调
    dispatch_source_set_event_handler(self.timer, ^{
        
        [self updateTimer];
    });
    
    // 启动定时器
    dispatch_resume(self.timer);
    
    
    
//    NSTimeInterval period = 1.0; //设置时间间隔
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行5
//    dispatch_source_set_event_handler(_timer, ^{
//        
//    });
//    dispatch_resume(_timer);
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



#pragma mark === <UIScrollViewDelegate>拽住、松开、停顿的时候调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    dispatch_cancel(self.timer);
    self.timer = nil;
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



@end


