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

@property (nonatomic, assign) CGFloat minCenterX;
@property (nonatomic, assign) CGFloat maxCenterX;

// 正在显示的页面中每个cell平均宽度
@property (nonatomic, assign) CGFloat averageItemWidth;
// 普通cell的宽度（未变大时）
@property (nonatomic, assign) CGFloat normalItemWidth;
@property (nonatomic, assign) CGFloat horizontalEdgePadding;


@property (nonatomic, strong) NSArray *layoutAttributes;

@end

@implementation CustomFlowLayout

- (instancetype)init{
    if (self = [super init]) {
        self.bigItemScaleSmallItem = 2;
        self.smallItemCountOneSide = 2;
    }
    return self;
}

- (void)prepareLayout{
    NSInteger itemCountOnFrame = self.smallItemCountOneSide*2 + 1;
    NSInteger similarSmallItemCount = self.smallItemCountOneSide*2 + self.bigItemScaleSmallItem;
    
    self.collectionViewWidth = self.collectionView.bounds.size.width;
    self.collectionViewHeight = self.collectionView.bounds.size.height;
    self.averageItemWidth = self.collectionViewWidth/itemCountOnFrame;
    self.normalItemWidth = self.collectionViewWidth/similarSmallItemCount;
    
    self.horizontalEdgePadding = self.collectionViewWidth * self.smallItemCountOneSide / similarSmallItemCount;
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    self.minCenterX = self.horizontalEdgePadding + self.normalItemWidth*self.bigItemScaleSmallItem/2;
    self.maxCenterX = self.horizontalEdgePadding + self.normalItemWidth*(count-1) + self.normalItemWidth*self.bigItemScaleSmallItem;
    
    
    [self setUpLayoutAttributes];
}
- (void)setUpLayoutAttributes{
   
    CGFloat contentOffsetX = self.collectionView.contentOffset.x;
    CGFloat centerX = self.collectionViewWidth/2 + contentOffsetX;
    centerX = centerX>=self.minCenterX ? centerX : self.minCenterX;
    centerX = centerX<=self.maxCenterX ? centerX : self.maxCenterX;
    
    NSInteger divisor = (centerX-self.horizontalEdgePadding) / self.normalItemWidth;
    CGFloat mod = centerX-self.horizontalEdgePadding - divisor * self.normalItemWidth;
    
     NSInteger count = [self.collectionView numberOfItemsInSection:0];
    NSMutableArray *marr = [NSMutableArray arrayWithCapacity:count];
    
    // 第一个变大的item
    NSInteger bigOne = divisor-self.bigItemScaleSmallItem/2;
    // 第一个变大的item失去的宽度
    CGFloat offset = (self.bigItemScaleSmallItem-1)*self.normalItemWidth * mod/self.normalItemWidth;
    CGFloat maxX = self.horizontalEdgePadding;
    for (int i=0; i<count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *layoutAttr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        CGFloat width = 0;
        CGFloat itemX = maxX;
        if (i < bigOne) {
            width = self.normalItemWidth;
        }else if(i == bigOne){
            width = self.normalItemWidth*self.bigItemScaleSmallItem - offset;
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
    
    CGFloat contentOffsetX = proposedContentOffset.x;
    CGFloat centerX = self.collectionViewWidth/2 + contentOffsetX;
    centerX = centerX>=self.minCenterX ? centerX : self.minCenterX;
    centerX = centerX<=self.maxCenterX ? centerX : self.maxCenterX;
    
    NSInteger divisor = (centerX-self.horizontalEdgePadding) / self.normalItemWidth;
    CGFloat mod = centerX-self.horizontalEdgePadding - divisor * self.normalItemWidth;
    
    // 第一个变大的item
    NSInteger bigOne = divisor-self.bigItemScaleSmallItem/2;
    
    CGFloat targetX = 0;
    if (mod < self.normalItemWidth/2) {
        // 左边大
        targetX = self.horizontalEdgePadding + self.normalItemWidth*bigOne + self.normalItemWidth*(self.bigItemScaleSmallItem/2);
    }else {
        // 右边大
        targetX = self.horizontalEdgePadding + self.normalItemWidth*bigOne + self.normalItemWidth*(self.bigItemScaleSmallItem/2+1);
    }
    targetX -= self.collectionViewWidth/2;
    CGPoint targetPoint = CGPointMake(targetX, proposedContentOffset.y);
    NSLog(@"bigOne:%ld proposed:%@ target:%@ ",bigOne,NSStringFromCGPoint(proposedContentOffset),NSStringFromCGPoint(targetPoint));
    
    return targetPoint;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return  YES;
}
- (CGSize)collectionViewContentSize{
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    CGFloat contentWidth = self.horizontalEdgePadding * 2 + self.normalItemWidth * (count-1) + self.normalItemWidth*self.bigItemScaleSmallItem;
    CGSize contentSize = CGSizeMake(contentWidth, self.collectionView.bounds.size.height);
    
    return contentSize;
}
@end
