//
//  ViewController.m
//  CollectionScrollAnimation
//
//  Created by 周际航 on 16/6/21.
//  Copyright © 2016年 zjh. All rights reserved.
//

#import "ViewController.h"
#import "CustomFlowLayout.h"
#import "CustomCollectionViewCell.h"
@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, strong) CustomFlowLayout *flowLayout;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpViews];
    [self setUpConstraints];
    
}

// 创建视图控件
- (void)setUpViews{
    self.flowLayout = [[CustomFlowLayout alloc] init];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    [self.collectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:[CustomCollectionViewCell cellIdentify]];
}
// 设置控件约束关系
- (void)setUpConstraints{
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:300];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    
    left.active = YES;
    right.active = YES;
    height.active = YES;
    centerY.active = YES;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 100;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CustomCollectionViewCell cellIdentify] forIndexPath:indexPath];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"123");
}


@end
