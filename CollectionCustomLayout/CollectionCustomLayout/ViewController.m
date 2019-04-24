//
//  ViewController.m
//  CollectionScrollAnimation
//
//  Created by 周际航 on 16/6/21.
//  Copyright © 2016年 zjh. All rights reserved.
//

#import "ViewController.h"
#import "FlowCollectionViewController.h"
#import "CircleCollectionViewController.h"
#import "ICarouselCollectionViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong, nullable) UITableView *tableView;

@end

@implementation ViewController

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
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.alwaysBounceVertical = YES;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.tableView];
}

- (void)setupFrame {
    self.tableView.frame = self.view.bounds;
}

#pragma mark - UITableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSString *text = [[NSString alloc] initWithFormat:@"%ld - %ld", indexPath.section, indexPath.row];
    if (indexPath.row == 0) {
        text = @"自定义流式布局";
    } else if (indexPath.row == 1) {
        text = @"自定义滚动的小球布局";
    } else if (indexPath.row == 2) {
        text = @"iCarousel卡片轮播层叠式布局";
    }
    cell.textLabel.text = text;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self func0];
    } else if (indexPath.row == 1) {
        [self func1];
    } else if (indexPath.row == 2) {
        [self func2];
    }
}

- (void)func0 {
    FlowCollectionViewController *vc = [[FlowCollectionViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)func1 {
    CircleCollectionViewController *vc = [[CircleCollectionViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)func2 {
    ICarouselCollectionViewController *vc = [[ICarouselCollectionViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
