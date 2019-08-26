//
//  Demo1ViewController.m
//  瀑布流
//
//  Created by cotton candy on 2019/8/23.
//  Copyright © 2019 Cotton candy. All rights reserved.
//

#import "Demo1ViewController.h"
#import "CandyFlowLayout.h"

#define ColorFromAndomRGB [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];

@interface Demo1ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, CandyFlowLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *heightArr;

@end

@implementation Demo1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSStringFromClass([self class]);
    self.view.backgroundColor = [UIColor whiteColor];
    self.heightArr = @[@(50), @(30), @(60), @(200), @(100), @(120), @(40), @(76), @(210), @(80), @(39), @(87), @(400), @(295), @(200), @(320)];
    [self createUI];
}

- (void)createUI {
    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.heightArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = ColorFromAndomRGB;
    return cell;
}

#pragma mark - CandyFlowLayoutDelegate

- (CGFloat)heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.heightArr[indexPath.item] floatValue];
}

#pragma mark - getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CandyFlowLayout *layout = [[CandyFlowLayout alloc] initSectionInsets:UIEdgeInsetsMake(10, 10, 10, 10) minItemSpacing:15 minLineSpacing:15];
        layout.style = CandyFlowLayoutStyleWaterfall;
        layout.delegate = self;
        layout.waterfallRowNumber = 3;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

@end
