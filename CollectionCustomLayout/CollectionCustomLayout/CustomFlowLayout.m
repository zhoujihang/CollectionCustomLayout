//
//  CustomFlowLayout.m
//  CollectionScrollAnimation
//
//  Created by 周际航 on 16/6/21.
//  Copyright © 2016年 zjh. All rights reserved.
//

#import "CustomFlowLayout.h"

@interface CustomFlowLayout()

@property (nonatomic, assign) CGFloat collectionViewWidth;

@property (nonatomic, assign) CGFloat collectionViewHeight;

// 正在显示的页面中每个cell平均宽度
@property (nonatomic, assign) CGFloat averageItemWidth;
// 普通cell的宽度（未变大时）
@property (nonatomic, assign) CGFloat normalItemWidth;

@property (nonatomic, strong) NSArray *layoutAttributes;

@end

@implementation CustomFlowLayout

- (void)prepareLayout{
    
    self.collectionViewWidth = self.collectionView.bounds.size.width;
    self.collectionViewHeight = self.collectionView.bounds.size.height;
    self.averageItemWidth = self.collectionViewWidth/5;
    self.normalItemWidth = self.collectionViewWidth/6;
    
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    CGFloat horizontalPadding = self.collectionViewWidth/3;
    self.sectionInset = UIEdgeInsetsMake(0, horizontalPadding, 0, horizontalPadding);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    [self setUpLayoutAttributes];
}
- (void)setUpLayoutAttributes{
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    CGFloat minCenterX = self.sectionInset.left + self.normalItemWidth;
    CGFloat maxCenterX = self.sectionInset.left + self.normalItemWidth * count;
    CGFloat contentOffsetX = self.collectionView.contentOffset.x;
    CGFloat centerX = self.collectionViewWidth/2 + contentOffsetX;
    centerX = centerX>=minCenterX ? centerX : minCenterX;
    centerX = centerX<=maxCenterX ? centerX : maxCenterX;
    
    NSInteger divisor = (centerX-self.sectionInset.left) / self.normalItemWidth;
    CGFloat mod = centerX-self.sectionInset.left - divisor * self.normalItemWidth;
    
    NSMutableArray *marr = [NSMutableArray arrayWithCapacity:count];
    
    NSInteger bigOne = divisor-1;
    CGFloat offset = mod;
    CGFloat maxX = self.sectionInset.left;
    for (int i=0; i<count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *layoutAttr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        CGFloat width = 0;
        CGFloat itemX = maxX;
        if (i < bigOne) {
            width = self.normalItemWidth;
        }else if(i == bigOne){
            width = self.normalItemWidth + self.normalItemWidth - offset;
        }else if(i == bigOne+1){
            width = self.normalItemWidth + offset;
        }else {
            width = self.normalItemWidth;
        }
        layoutAttr.frame = CGRectMake(itemX, 0, width, self.collectionViewHeight);
        [marr addObject:layoutAttr];
        maxX += width;
    }
    self.layoutAttributes = [marr copy];
}
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{

    return self.layoutAttributes;
}
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    CGFloat minCenterX = self.sectionInset.left + self.normalItemWidth;
    CGFloat maxCenterX = self.sectionInset.left + self.normalItemWidth * count;
    CGFloat contentOffsetX = proposedContentOffset.x;
    CGFloat centerX = self.collectionViewWidth/2 + contentOffsetX;
    centerX = centerX>=minCenterX ? centerX : minCenterX;
    centerX = centerX<=maxCenterX ? centerX : maxCenterX;
    
    NSInteger divisor = (centerX-self.sectionInset.left) / self.normalItemWidth;
    CGFloat mod = centerX-self.sectionInset.left - divisor * self.normalItemWidth;
    
    CGFloat targetX = 0;
    if (mod < self.normalItemWidth/2) {
        // 左边大
        targetX = self.sectionInset.left + self.normalItemWidth * (divisor);
    }else {
        // 右边大
        targetX = self.sectionInset.left + self.normalItemWidth * (divisor+1);
    }
    targetX -= self.collectionViewWidth/2;
    CGPoint targetPoint = CGPointMake(targetX, proposedContentOffset.y);
    NSLog(@"proposedContentOffset:%@ targetPoint:%@ ",NSStringFromCGPoint(proposedContentOffset),NSStringFromCGPoint(targetPoint));
    
    
    return targetPoint;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return  YES;
}
- (CGSize)collectionViewContentSize{
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    CGFloat contentWidth = self.sectionInset.left + self.sectionInset.right + self.normalItemWidth * count + self.normalItemWidth;
    CGSize contentSize = CGSizeMake(contentWidth, self.collectionView.bounds.size.height);
    
    return contentSize;
}
@end
