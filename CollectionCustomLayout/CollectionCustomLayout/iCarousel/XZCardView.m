//
//  XZCardView.m
//  CollectionCustomLayout
//
//  Created by 周际航 on 2019/4/24.
//  Copyright © 2019年 zjh. All rights reserved.
//

#import "XZCardView.h"

@interface XZCardView ()

@property (nonatomic, strong, nullable) UILabel *label;

@end

@implementation XZCardView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self setupView];
}

- (void)setupView {
    self.backgroundColor = [UIColor colorWithRed:0.3+arc4random_uniform(70)/100.0 green:0.3+arc4random_uniform(70)/100.0 blue:0.3+arc4random_uniform(70)/100.0 alpha:1];
    
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    
    self.label = [[UILabel alloc] init];
    self.label.font = [UIFont boldSystemFontOfSize:120];
    self.label.textColor = [UIColor blackColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.label];
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    self.label.text = title;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.frame = self.bounds;
}

#pragma mark - 视图大小
- (CGSize)sizeThatFits:(CGSize)size {
    return [self intrinsicContentSize];
}
- (CGSize)intrinsicContentSize {
    return CGSizeMake(200, 300);
}

@end
