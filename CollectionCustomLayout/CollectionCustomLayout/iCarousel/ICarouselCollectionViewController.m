//
//  ICarouselCollectionViewController.m
//  CollectionCustomLayout
//
//  Created by 周际航 on 2019/4/24.
//  Copyright © 2019年 zjh. All rights reserved.
//

#import "ICarouselCollectionViewController.h"
#import <iCarousel/iCarousel.h>
#import "XZCardView.h"

@interface ICarouselCollectionViewController () <iCarouselDelegate, iCarouselDataSource>

@property (nonatomic, strong, nullable) iCarousel *carousel;

@end

@implementation ICarouselCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    [self setupView];
    [self setupFrame];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.carousel = [[iCarousel alloc] init];
    self.carousel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.05];
    self.carousel.delegate = self;
    self.carousel.dataSource = self;
    self.carousel.type = iCarouselTypeCustom;
    self.carousel.decelerationRate = 0.5;
    
    [self.view addSubview:self.carousel];
}

- (void)setupFrame {
    self.carousel.frame = CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 300);
}

#pragma mark - iCarousel 代理
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    if (option == iCarouselOptionWrap) {
        return 1;
    } else if (option == iCarouselOptionVisibleItems) {
        return 5;
    }
    return value;
}
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return 100;
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    if (view) {
        ((XZCardView *)view).title = [NSString stringWithFormat:@"%ld", index];
        return view;
    }
    XZCardView *cardView = [[XZCardView alloc] init];
    [cardView sizeToFit];
    cardView.title = [NSString stringWithFormat:@"%ld", index];
    return cardView;
}
- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    NSLog(@"zjh currentIndex:%ld", self.carousel.currentItemIndex);
}

- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform {
    CGFloat itemWidth = self.carousel.itemWidth;
    CGFloat transOffsetX = MIN(2.5, MAX(-2, offset));
    CGFloat scaleOffsetX = MIN(2.5, MAX(-2, offset));
    CGFloat scaleOffsetY = MIN(2.5, MAX(-2, offset));
    scaleOffsetX = 1 - ABS(scaleOffsetX) * 0.2; // [-2.5 ~ 0 ~ 2.5] -> [0.5 ~ 1 ~ 0.5]
    scaleOffsetY = 1 - ABS(scaleOffsetY) * 0.2; // [-2.5 ~ 0 ~ 2.5] -> [0.5 ~ 1 ~ 0.5]
    if (transOffsetX >= -2 && transOffsetX <= -1) {
        // [-2 ~ -1] -> [-1 ~ （波谷 -1.2） ~-1] 先快后慢整波谷曲线
        transOffsetX = -1 - 0.2 * sin((ABS(transOffsetX)-1) * M_PI);
    } else if (transOffsetX >= 2 && transOffsetX <= 2.5) {
        // [2 ~ 2.5] -> [2 ~ 1.8] 先慢后快左波谷曲线
        transOffsetX = 2 - 0.2 * (1 - ABS(sin((transOffsetX-2) * M_PI + M_PI_2)));
    }
    transform = CATransform3DTranslate(transform, transOffsetX * (itemWidth * 0.3), 1, -ABS(offset));
    transform = CATransform3DScale(transform, scaleOffsetX, scaleOffsetY, 1);
    [self changeAlphaWithOffset:offset];
    return transform;
}

- (void)changeAlphaWithOffset:(CGFloat)offset {
    // offset -0.5 ~ 0.5  ->  currentIndex
    // offset -1.5 ~ -0.5  ->  leftIndex
    // offset -2.5 ~ -1.5  ->  left2Index
    // offset 0.5 ~ 1.5  ->  rightIndex
    // offset 1.5 ~ 2.5  ->  right2Index
    NSInteger index = ((self.carousel.currentItemIndex + (NSInteger)((floor)(offset+0.5))) + self.carousel.numberOfItems)% self.carousel.numberOfItems;
    XZCardView *view =  (XZCardView *)[self.carousel itemViewAtIndex:index];
    //    view.alpha = 1 - ABS(offset/3.0);
}

@end
