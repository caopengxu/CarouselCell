//
//  ScrollCell.h
//  scroll
//
//  Created by 曹鹏旭 on 16/1/4.
//  Copyright © 2016年 cdbsj. All rights reserved.
//

#import <UIKit/UIKit.h>

// 声明协议
@protocol CarouselCellDelegate <NSObject>
@required
- (NSInteger)carouselCellSetPageCount;
- (NSInteger)carouselCellSetImageHeight;
@optional
- (void)carouselCellClickBtn:(UIButton *)btn pageNum:(NSInteger)page;
@end



@interface CarouselCell : UITableViewCell
@property (nonatomic, weak) id<CarouselCellDelegate> delegate;
@property (nonatomic, strong) NSTimer *timer;
- (void)addImage;
@end
