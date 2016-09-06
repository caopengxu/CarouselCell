//
//  CarouselView.h
//  CarouselCell
//
//  Created by 曹鹏旭 on 16/9/6.
//  Copyright © 2016年 cpx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarouselView : UIView
- (void)addImageSetCount:(int)count Height:(int)height;
@property (nonatomic, copy) void (^completion) (NSInteger age);
@end
