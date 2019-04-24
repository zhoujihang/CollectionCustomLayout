//
//  XZCollectionViewLayout.m
//  XZFloatHeaderTableListViewController
//
//  Created by 周际航 on 2019/4/23.
//  Copyright © 2019年 zjh. All rights reserved.
//

#import "XZCollectionViewLayout.h"
#import "XZCollectionDecorationView.h"

@interface XZCollectionViewLayout ()

@property (nonatomic, strong, nullable) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *cellAttrsDic;
@property (nonatomic, strong, nullable) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *decorationAttrsDic;
@property (nonatomic, strong, nullable) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *supplyHeaderAttrsDic;
@property (nonatomic, strong, nullable) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *supplyFooterAttrsDic;

/// 垂直布局时，一行放几个item
@property (nonatomic, assign) NSInteger columnCount;

@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) CGSize headerSize;
@property (nonatomic, assign) CGSize footerSize;

/// 水平线上cell间距
@property (nonatomic, assign) CGFloat itemPadding;
/// 垂直线上cell间距
@property (nonatomic, assign) CGFloat linePadding;
/// section 上下左右间距
@property (nonatomic, assign) UIEdgeInsets sectionInsets;

@property (nonatomic, assign) CGSize contentSize;

@end

@implementation XZCollectionViewLayout
#pragma mark - layout 自带方法
- (void)prepareLayout {
    [super prepareLayout];
    [self registerClass:[XZCollectionDecorationView class] forDecorationViewOfKind:@"decoration"];
    [self prepareData];
    [self prepareAttrs];
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *list = [@[] mutableCopy];
    [list addObjectsFromArray:self.cellAttrsDic.allValues];
    [list addObjectsFromArray:self.supplyHeaderAttrsDic.allValues];
    [list addObjectsFromArray:self.supplyFooterAttrsDic.allValues];
    [list addObjectsFromArray:self.decorationAttrsDic.allValues];
    return [list copy];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellAttrsDic[indexPath];
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        return self.supplyHeaderAttrsDic[indexPath];
    } else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
        return self.supplyFooterAttrsDic[indexPath];
    }
    return nil;
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    return self.decorationAttrsDic[indexPath];
}
- (CGSize)collectionViewContentSize {
    return self.contentSize;
}
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    return proposedContentOffset;
}

#pragma mark - 逻辑方法
- (void)prepareData {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.columnCount = 4;
    self.itemPadding = 10;
    self.linePadding = 10;
    self.sectionInsets = UIEdgeInsetsMake(15, 15, 15, 15);
    
    CGFloat itemWidth = ((screenWidth - self.sectionInsets.left - self.sectionInsets.right) - (self.columnCount-1)*self.itemPadding) / self.columnCount;
    CGFloat itemHeight = itemWidth;
    
    self.itemSize = CGSizeMake(itemWidth, itemHeight);
    self.headerSize = CGSizeMake(screenWidth - self.sectionInsets.left - self.sectionInsets.right, 44);
    self.footerSize = CGSizeMake(screenWidth - self.sectionInsets.left - self.sectionInsets.right, 44);
}
- (void)prepareAttrs {
    self.cellAttrsDic = [@{} mutableCopy];
    self.supplyHeaderAttrsDic = [@{} mutableCopy];
    self.supplyFooterAttrsDic = [@{} mutableCopy];
    self.decorationAttrsDic = [@{} mutableCopy];
    
    CGFloat itemX = 0;
    CGFloat sectionBeginY = 0;
    
    NSInteger section = [self.collectionView numberOfSections];
    for (NSInteger i = 0; i < section; i++) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:i];
        NSInteger totalRow = itemCount / self.columnCount;
        CGFloat sectionHeight = self.sectionInsets.top;
        sectionHeight += self.headerSize.height;
        if (totalRow == 0) {
            sectionHeight += itemCount==0 ? 0 : self.itemSize.height;
        } else {
            sectionHeight += totalRow * (self.itemSize.height + self.linePadding) - self.linePadding;
        }
        sectionHeight += self.footerSize.height;
        sectionHeight += self.sectionInsets.bottom;
        
        for (NSInteger j = 0; j < itemCount; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            NSInteger row = j / self.columnCount;
            NSInteger column = j % self.columnCount;
            CGFloat cellX = floor(self.sectionInsets.left + itemX + (self.itemSize.width + self.itemPadding) * column);
            CGFloat cellY = floor(self.sectionInsets.top + sectionBeginY + self.headerSize.height + (self.itemSize.height + self.linePadding) * row);
            UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attrs.frame = CGRectMake(cellX, cellY, self.itemSize.width, self.itemSize.height);
            [self.cellAttrsDic setObject:attrs forKey:indexPath];
        }
        
        CGRect headerFrame = CGRectMake(self.sectionInsets.left + itemX, sectionBeginY + self.sectionInsets.top , self.headerSize.width, self.headerSize.height);
        CGRect footerFrame = CGRectMake(self.sectionInsets.left +itemX, sectionBeginY+sectionHeight-self.footerSize.height - self.sectionInsets.bottom, self.footerSize.width, self.footerSize.height);
        CGRect decorationFrame = CGRectMake(self.sectionInsets.left +itemX, sectionBeginY + self.sectionInsets.top, self.headerSize.width, sectionHeight-self.sectionInsets.top - self.sectionInsets.bottom);
        
        // 一个section只需要一个 header、footer、decoration
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:i];
        UICollectionViewLayoutAttributes *headerAttrs = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
        headerAttrs.frame = headerFrame;
        UICollectionViewLayoutAttributes *footerAttrs = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:indexPath];
        footerAttrs.frame = footerFrame;
        UICollectionViewLayoutAttributes *decorationAttrs = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:@"decoration" withIndexPath:indexPath];
        decorationAttrs.frame = decorationFrame;
        decorationAttrs.zIndex = -1;
        
        [self.supplyHeaderAttrsDic setObject:headerAttrs forKey:indexPath];
        [self.supplyFooterAttrsDic setObject:footerAttrs forKey:indexPath];
        [self.decorationAttrsDic setObject:decorationAttrs forKey:indexPath];
        sectionBeginY += sectionHeight;
    }
    self.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, sectionBeginY);
}


@end
