//
//  CarouselView.m
//  CarouselCell
//
//  Created by 曹鹏旭 on 16/9/6.
//  Copyright © 2016年 cpx. All rights reserved.
//

#import "CarouselView.h"

#define __ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface CarouselView () <UIScrollViewDelegate>
{
    int _pageCount;
    int _imageHeight;
}
@property (weak, nonatomic) IBOutlet UIScrollView *myScroll;
@property (weak, nonatomic) IBOutlet UIPageControl *myPageControl;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) NSString *imageName;
@end



@implementation CarouselView

#pragma mark === 添加图片
- (void)addImageSetCount:(int)count Height:(int)height
{
    _pageCount = count;
    _imageHeight = height;
    
    [self.myScroll setContentOffset:CGPointMake(__ScreenWidth, 0)];
    self.myPageControl.currentPage = 0;
    
    self.myScroll.contentSize = CGSizeMake((_pageCount + 2) * __ScreenWidth, 0);
    self.myPageControl.numberOfPages = _pageCount;
    
    for (int i = 0; i < (_pageCount + 2); i++)
    {
        if (i == 0)
        {
            _imageName = [NSString stringWithFormat:@"img_0%d", _pageCount - 1];
        }
        else if (i == (_pageCount + 1))
        {
            _imageName = @"img_00";
        }
        else
        {
            _imageName = [NSString stringWithFormat:@"img_0%d", i - 1];
        }
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(__ScreenWidth * i, 0, __ScreenWidth, _imageHeight)];
        
        [btn setBackgroundImage:[UIImage imageNamed:_imageName] forState:UIControlStateNormal];
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
    // 获得队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 创建一个定时器(dispatch_source_t本质还是个OC对象)
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 设置定时器的各种属性（几时开始任务，每隔多长时间执行一次）
    // GCD的时间参数，一般是纳秒（1秒 == 10的9次方纳秒）
    // 何时开始执行第一个任务
    // dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC) 比当前时间晚3秒
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(2.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    
    // 设置回调
    dispatch_source_set_event_handler(self.timer, ^{
        
        [self updateTimer];
    });
    
    // 启动定时器
    dispatch_resume(self.timer);
}
#pragma mark === 图片向后滑一页
- (void)updateTimer
{
    // (当前的页数 + 1) % 总页数，防止数值大于总页数
    int page = (self.myPageControl.currentPage + 1) % _pageCount;
    self.myPageControl.currentPage = page;
    
    if (page == 0)
    {
        CGFloat x = (_pageCount + 1) * __ScreenWidth;
        [self.myScroll setContentOffset:CGPointMake(x, 0) animated:YES];
        
        [self.myScroll setContentOffset:CGPointMake(0, 0)];
    }
    else
    {
        CGFloat x = (self.myPageControl.currentPage + 1) * __ScreenWidth;
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
        [self.myScroll setContentOffset:CGPointMake(__ScreenWidth * _pageCount, 0)];
        self.myPageControl.currentPage = _pageCount - 1;
    }
    else if (page == _pageCount + 1)
    {
        [self.myScroll setContentOffset:CGPointMake(__ScreenWidth, 0)];
        self.myPageControl.currentPage = 0;
    }
    else
    {
        self.myPageControl.currentPage = page - 1;
    }
}



@end


