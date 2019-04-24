//
//  XZCollectionDecorationView.m
//  XZFloatHeaderTableListViewController
//
//  Created by 周际航 on 2019/4/24.
//  Copyright © 2019年 zjh. All rights reserved.
//

#import "XZCollectionDecorationView.h"

@implementation XZCollectionDecorationView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self setupView];
    [self setupFrame];
}

- (void)setupView {
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.25];
    
}

- (void)setupFrame {
    
}


@end
