//
//  ScrollCell.h
//  scroll
//
//  Created by 曹鹏旭 on 16/1/4.
//  Copyright © 2016年 cdbsj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarouselCell : UITableViewCell
- (void)addImageSetCount:(int)count Height:(int)height;
@property (nonatomic, copy) void (^completion) (NSInteger age);
@end
