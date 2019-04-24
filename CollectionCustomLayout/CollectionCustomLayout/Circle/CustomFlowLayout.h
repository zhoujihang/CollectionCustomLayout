//
//  CustomFlowLayout.h
//  CollectionScrollAnimation
//
//  Created by 周际航 on 16/6/21.
//  Copyright © 2016年 zjh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomFlowLayout : UICollectionViewLayout

// 大球宽度是小球的多少倍
@property (nonatomic, assign) NSInteger bigItemScaleSmallItem;

// 大球一边留多少个小球显示
@property (nonatomic, assign) NSInteger smallItemCountOneSide;

@end
