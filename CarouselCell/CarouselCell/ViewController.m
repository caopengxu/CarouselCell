//
//  ViewController.m
//  scroll
//
//  Created by 曹鹏旭 on 16/1/4.
//  Copyright © 2016年 cdbsj. All rights reserved.
//

#import "ViewController.h"
#import "CarouselView.h"
#import <QuartzCore/QuartzCore.h>
#import "MyLayer.h"

#define Angle2Radian(angle) ((angle) / 180.0 * M_PI)

@interface ViewController () <CAAnimationDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIView *myView;
@property (nonatomic, weak) IBOutlet UIView *keyView;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) CALayer *layer;
@property (nonatomic, assign) int index;
@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    _myView.layer.borderWidth = 10;
//    _myView.layer.borderColor = [UIColor greenColor].CGColor;
//    _myView.layer.cornerRadius = 10;
//    _myView.layer.shadowColor = [UIColor blueColor].CGColor;
//    _myView.layer.shadowOffset = CGSizeMake(10, 10);
//    _myView.layer.shadowOpacity = 0.5;
//    _myView.layer.masksToBounds = NO;
    
//    _myView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0);
//    _myView.layer.transform = CATransform3DMakeRotation(M_PI_4, 0, 0, 1);
    
//    NSValue *value = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_4, 0, 0, 1)];
//    [_myView.layer setValue:value forKey:@"transform"];
    
    
    _layer = [CALayer layer];
    _layer.backgroundColor = [UIColor blackColor].CGColor;
    _layer.bounds = CGRectMake(0, 0, 50, 50);
    _layer.position = CGPointMake(0, 0);
    _layer.anchorPoint = CGPointMake(0, 0);

    [_myView.layer addSublayer:_layer];
    
    
    MyLayer *myLayer = [MyLayer layer];
    myLayer.bounds = CGRectMake(0, 0, 100, 100);
    myLayer.backgroundColor = [UIColor orangeColor].CGColor;
    myLayer.position = CGPointMake(100, 0);
    myLayer.anchorPoint = CGPointZero;
    [myLayer setNeedsDisplay];
    
    [_myView.layer addSublayer:myLayer];
    
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    view.backgroundColor = [UIColor grayColor];
    _tableView.tableHeaderView = view;
}


#pragma mark === touchesBegan
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [CATransaction begin];
//    [CATransaction setDisableActions:YES];
//
//    _layer.backgroundColor = [UIColor blueColor].CGColor;
//
//    [CATransaction commit];

    
//    [UIView beginAnimations:nil context:nil];
//    _myView.center = CGPointMake(100, 100);
//    [UIView commitAnimations];
//
//    [UIView animateWithDuration:1.0 animations:^{
//    }];
//    [UIView animateWithDuration:1.0 animations:^{
//    } completion:^(BOOL finished) {
//    }];
    
    
    NSString *filename = [NSString stringWithFormat:@"img_0%d", self.index];
    _imageView.image = [UIImage imageNamed:filename];
    
    self.index++;
    if (self.index == 3)
    {
        self.index = 0;
    }
    [UIView transitionWithView:_imageView duration:1.0 options:UIViewAnimationOptionTransitionCurlUp animations:nil completion:nil];
}


#pragma mark === CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim
{}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{}


#pragma mark === CAAnimationGroup初体验
- (void)testCAAnimationGroup
{
    CAAnimationGroup  *group = [CAAnimationGroup animation];
    
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.keyPath = @"transform.rotation";
    anim.toValue = @(Angle2Radian(180));
    
    CABasicAnimation *animOne = [CABasicAnimation animation];
    animOne.keyPath = @"transform.scale";
    animOne.toValue = @(0.0);
    
    
    group.animations = @[anim, animOne];
    group.duration = 2.0;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    
    [_myView.layer addAnimation:group forKey:nil];
}


#pragma mark === CAKeyframeAnimation初体验
- (void)testCAKeyframeAnimation
{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"position";
    
    NSValue *v1 = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    NSValue *v2 = [NSValue valueWithCGPoint:CGPointMake(100, 0)];
    NSValue *v3 = [NSValue valueWithCGPoint:CGPointMake(0, 100)];
    NSValue *v4 = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    anim.values = @[v1, v2, v3, v4];
    anim.keyTimes = @[@(0.2), @(0.2), @(0.2), @(0.4)];
    
    anim.duration = 1.0;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    
    [_keyView.layer addAnimation:anim forKey:nil];
}
- (void)testTest
{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"position";
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddEllipseInRect(path, NULL, CGRectMake(100, 100, 200, 200));
    anim.path = path;
    CGPathRelease(path);
    
    anim.repeatCount = 2;
    
    // 设置动画的执行节奏
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    anim.delegate = self;
    
    
    anim.duration = 1.0;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    
    [_keyView.layer addAnimation:anim forKey:nil];
}
- (void)testTestTest
{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    
    anim.values = @[@(Angle2Radian(-5)), @(Angle2Radian(5)), @(Angle2Radian(-5))];
    anim.repeatCount = 10;
    
    anim.duration = 0.25;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    
    [_myView.layer addAnimation:anim forKey:@"shake"];
}


#pragma mark === CABasicAnimation初体验
- (void)testCABasicAnimation
{
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.keyPath = @"position";
    
    anim.fromValue = [NSValue valueWithCGPoint:CGPointZero];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(100, 100)];
    
    anim.duration = 1.0;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    
    [_layer addAnimation:anim forKey:nil];
}
- (void)testTwo
{
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.keyPath = @"transform";
//    anim.keyPath = @"transform.rotation";
//    anim.keyPath = @"transform.scale";
//    anim.keyPath = @"transform.scale.x";
//    anim.keyPath = @"transform.translation";
//    anim.keyPath = @"transform.translation.x";
    
    anim.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_4, 1, 1, 0)];
//    anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_4, 1, 1, 0)];
    anim.byValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_4, 1, 1, 0)];
    
    anim.duration = 1.0;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    
    [_layer addAnimation:anim forKey:nil];
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
    [view addImageSetCount:3 Height:150];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_myView.layer removeAnimationForKey:@"shake"];
 
    NSString *filename = [NSString stringWithFormat:@"img_0%d", self.index];
    _imageView.image = [UIImage imageNamed:filename];
    
    self.index++;
    if (self.index == 3)
    {
        self.index = 0;
    }
    
    // 转场动画
    CATransition *anim = [CATransition animation];
//    anim.type = @"cube";
//    anim.type = @"push";
//    anim.type = @"rippleEffect";
    anim.type = @"pageCurl";
//    anim.type = @"pageUnCurl";
//    anim.subtype = kCATransitionFromRight;
    anim.subtype = kCATransitionFromLeft;
    
    anim.startProgress = 0.2;
    anim.endProgress = 0.8;
    
    anim.duration = 0.5;
    
    [_imageView.layer addAnimation:anim forKey:nil];
    
//    if (indexPath.section == 0)
//    {
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TestController" bundle:nil];
//        UIViewController *jump = [storyboard instantiateInitialViewController];
//
//        [self.navigationController pushViewController:jump animated:YES];
//    }
//    else if (indexPath.section == 1)
//    {
//
//    }
//    else
//    {
//
//    }
}



@end


