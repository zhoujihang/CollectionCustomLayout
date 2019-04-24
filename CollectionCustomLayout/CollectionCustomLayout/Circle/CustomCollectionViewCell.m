//
//  customCollectionViewCell.m
//  CollectionScrollAnimation
//
//  Created by 周际航 on 16/6/22.
//  Copyright © 2016年 zjh. All rights reserved.
//

#import "CustomCollectionViewCell.h"

@interface CustomCollectionViewCell()

@property (nonatomic, weak) UIView *backDropView;



@end


@implementation CustomCollectionViewCell

+ (NSString *)cellIdentify{
    return NSStringFromClass([self class]);
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpViews];
        [self setUpConstraints];
    }
    return self;
}

// 创建视图控件
- (void)setUpViews{
    self.backgroundView = [[UIView alloc] init];
    self.backgroundView.backgroundColor = [UIColor cyanColor];
    
    UIView *backDropView = [[UIView alloc] init];
    backDropView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:backDropView];
    self.backDropView = backDropView;
    
}
// 设置控件约束关系
- (void)setUpConstraints{
    self.backDropView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *leftCons = [NSLayoutConstraint constraintWithItem:self.backDropView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:2];
    NSLayoutConstraint *rightCons = [NSLayoutConstraint constraintWithItem:self.backDropView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:-2];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.backDropView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *ratioWH = [NSLayoutConstraint constraintWithItem:self.backDropView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.backDropView attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    leftCons.active = YES;
    rightCons.active = YES;
    centerY.active = YES;
    ratioWH.active = YES;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    self.backDropView.layer.cornerRadius = (width-4)/2;
    self.backDropView.layer.masksToBounds = YES;
}


@end
