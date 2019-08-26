//
//  Demo2ViewController.m
//  瀑布流
//
//  Created by cotton candy on 2019/8/23.
//  Copyright © 2019 Cotton candy. All rights reserved.
//

#import "Demo2ViewController.h"
#import "CandyFlowLayout.h"
#import "CustomCell.h"

#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@interface Demo2ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, CandyFlowLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *contentsArr;

@end

@implementation Demo2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSStringFromClass([self class]);
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSInteger section = 0;
    do {
        NSMutableArray *array = [NSMutableArray array];
        for (NSInteger i = 1; i < 11; i++) {
            NSString *content = @"";
            for (NSInteger j = 0; j < i; j++) {
                content = [content stringByAppendingString:@"啦"];
            }
            [array addObject:content];
        }
        [self.contentsArr addObject:array];
        section ++;
    } while (section < 4);
    
    [self createUI];
}

- (void)createUI {
    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.contentsArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.contentsArr[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.contentLab.text = self.contentsArr[indexPath.section][indexPath.item];
    cell.contentLab.textColor = randomColor;
    return cell;
}

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    CGSize size = [self.contentsArr[indexPath.item] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    CGSize size = [self.contentsArr[indexPath.section][indexPath.item] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil].size;
    return CGSizeMake(size.width + 10, size.height + 10);
}

#pragma mark - getter

- (NSMutableArray *)contentsArr {
    if (!_contentsArr) {
        _contentsArr = [NSMutableArray array];
    }
    return _contentsArr;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CandyFlowLayout *layout = [[CandyFlowLayout alloc] initSectionInsets:UIEdgeInsetsMake(10, 10, 10, 10) minItemSpacing:15 minLineSpacing:15];
        layout.style = CandyFlowLayoutStyleSameHeight;
        layout.delegate = self;
//        layout.waterfallRowNumber = 2;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[CustomCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

@end

