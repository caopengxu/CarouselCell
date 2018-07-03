//
//  MyLayer.m
//  CarouselCell
//
//  Created by caopengxu on 2018/7/2.
//  Copyright © 2018年 cpx. All rights reserved.
//

#import "MyLayer.h"

@implementation MyLayer

- (void)drawInContext:(CGContextRef)ctx
{
    CGContextSetRGBFillColor(ctx, 1, 0, 0, 1);
    CGContextAddEllipseInRect(ctx, CGRectMake(0, 0, 50, 50));
    CGContextFillPath(ctx);
}


@end


