//
//  CandyFlowLayout.m
//  瀑布流
//
//  Created by cotton candy on 2019/8/23.
//  Copyright © 2019 Cotton candy. All rights reserved.
//

#import "CandyFlowLayout.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface CandyFlowLayout ()

/** 存放每个item得frame数组 */
@property (nonatomic, strong) NSMutableArray *itemAttributes;

@property (nonatomic, assign) NSInteger numberOfSection;

/** 记录瀑布流一行中最大y */
@property (nonatomic, strong) NSMutableArray *itemHeights;
/** contentSize height */
@property (nonatomic, assign) CGFloat contentMaxHeight;

@end

@implementation CandyFlowLayout

- (instancetype)initSectionInsets:(UIEdgeInsets)sectionInsets minItemSpacing:(CGFloat)minItemSpacing minLineSpacing:(CGFloat)minLineSpacing {
    self = [super init];
    if (self) {
        _sectionInsets = sectionInsets;
        _minItemSpacing = minItemSpacing;
        _minLineSpacing = minLineSpacing;
    }
    return self;
}

- (void)prepareLayout {
    // 一定要重写此方法
    [super prepareLayout];
    
    // 清空
    [self.itemAttributes removeAllObjects];
    // 有多少sections
    self.numberOfSection = [self.collectionView numberOfSections];
    switch (self.style) {
        case CandyFlowLayoutStyleWaterfall:
            [self createWaterfallItemAttributes];
            break;
        case CandyFlowLayoutStyleSameHeight:
            [self createSameHeightItemAttributes];
            break;
        case CandyFlowLayoutStyleSpecial:
            [self createSpecialItemAttributes];
            break;
    }
}

#pragma mark - 竖向瀑布流，等宽不等高

- (void)createWaterfallItemAttributes {
    self.contentMaxHeight = 0;
    [self.itemHeights removeAllObjects];
    for (NSInteger i = 0; i < self.waterfallRowNumber; i ++) {
        // 默认都是top
        [self.itemHeights addObject:@(self.sectionInsets.top)];
    }
    
    // 计算item width
    CGFloat width = (ScreenWidth - self.sectionInsets.left - self.sectionInsets.right - (self.waterfallRowNumber - 1) * self.minItemSpacing) / self.waterfallRowNumber * 1.0;
    
    for (NSInteger i = 0; i < self.numberOfSection; i ++) {
        NSInteger numberOfItem = [self.collectionView numberOfItemsInSection:i];
        for (NSInteger j = 0; j < numberOfItem; j ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            //找出每行最短的一列
            NSInteger minIndex = 0;
            CGFloat minY = [self.itemHeights[0] floatValue];
            for (NSInteger n = 1; n < self.waterfallRowNumber; n ++) {
                // 依次取出高度
                CGFloat itemY = [self.itemHeights[n] floatValue];
                if (minY > itemY) {
                    minY = itemY;
                    minIndex = n;
                }
            }
            
            CGFloat xOffset = self.sectionInsets.left + minIndex * (width + self.minItemSpacing);
            CGFloat height = 0;
            if (self.delegate && [self.delegate respondsToSelector:@selector(heightForItemAtIndexPath:)]) {
                height = [self.delegate heightForItemAtIndexPath:indexPath];
            }
            CGFloat yOffset = minY;
            if (yOffset != self.sectionInsets.top) {
                // 不是第一行，要加间隔
                yOffset += self.minLineSpacing;
            }
            
            // 更新高度
            self.itemHeights[minIndex] = @(height + yOffset);
            // 更新contentSize height
            CGFloat maxHeight = [self.itemHeights[minIndex] floatValue];
            if (self.contentMaxHeight < maxHeight) {
                // 最短的一列 + 高度 > 之前的最高高度
                self.contentMaxHeight = maxHeight + self.sectionInsets.bottom;
            }
            attribute.frame = CGRectMake(xOffset, yOffset, width, height);
            [self.itemAttributes addObject:attribute];
        }
    }
}

#pragma mark - 等高不等宽排列

- (void)createSameHeightItemAttributes {
    self.contentMaxHeight = 0;
    // 每行实际的宽度
    CGFloat realWidth = ScreenWidth - self.sectionInsets.left - self.sectionInsets.right;
    CGFloat xOffset = 0;
    CGFloat yOffset = 0;
    for (NSInteger i = 0; i < self.numberOfSection; i ++) {
        NSInteger numberOfItem = [self.collectionView numberOfItemsInSection:i];
        xOffset = self.sectionInsets.left;
        yOffset = self.sectionInsets.top + self.contentMaxHeight;
        for (NSInteger j = 0; j < numberOfItem; j ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            CGSize size = CGSizeZero;
            if (self.delegate && [self.delegate respondsToSelector:@selector(sizeForItemAtIndexPath:)]) {
                size = [self.delegate sizeForItemAtIndexPath:indexPath];
            }
            CGFloat width = size.width;
            CGFloat height = size.height;
            
            if (xOffset + width > realWidth) {
                // 换行
                xOffset = self.sectionInsets.left;
                yOffset = yOffset + self.minLineSpacing + height;
                attribute.frame = CGRectMake(xOffset, yOffset, width, height);
                xOffset = xOffset + width + self.minItemSpacing;
                // 更新contentSize height
                self.contentMaxHeight = yOffset + height + self.sectionInsets.bottom;
            } else {
                attribute.frame = CGRectMake(xOffset, yOffset, width, height);
                xOffset = xOffset + width + self.minItemSpacing;
                // 更新contentSize height
                self.contentMaxHeight = yOffset + height + self.sectionInsets.bottom;
            }
            
            [self.itemAttributes addObject:attribute];
        }
    }
}

#pragma mark - 特殊样式排列

- (void)createSpecialItemAttributes {
    self.contentMaxHeight = 0;
    CGFloat realWidth = ScreenWidth - self.sectionInsets.left - self.sectionInsets.right;
    CGFloat xOffset = 0;
    CGFloat yOffset = 0;
    for (NSInteger i = 0; i < self.numberOfSection; i ++) {
        NSInteger numberOfItem = [self.collectionView numberOfItemsInSection:i];
        xOffset = self.sectionInsets.left;
        yOffset = self.sectionInsets.top + self.contentMaxHeight;
        for (NSInteger j = 0; j < numberOfItem; j ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            CGSize size = CGSizeZero;
            if (self.delegate && [self.delegate respondsToSelector:@selector(sizeForItemAtIndexPath:)]) {
                size = [self.delegate sizeForItemAtIndexPath:indexPath];
            }
            
            if (xOffset + size.width > realWidth) {
                // 换行，超过一行
                // 取出每个secction的第一个
                UICollectionViewLayoutAttributes *firstAttribute = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
                CGRect frame = firstAttribute.frame;
                // x偏移，空出第一个width
                xOffset = CGRectGetMaxX(frame) + self.minItemSpacing;
                yOffset = yOffset + size.height + self.minLineSpacing;
                attribute.frame = CGRectMake(xOffset, yOffset, size.width, size.height);
                xOffset = xOffset + size.width + self.minItemSpacing;
                self.contentMaxHeight = CGRectGetMaxY(attribute.frame) + self.sectionInsets.bottom;
            } else {
                attribute.frame = CGRectMake(xOffset, yOffset, size.width, size.height);
                xOffset = xOffset + size.width + self.minItemSpacing;
                self.contentMaxHeight = CGRectGetMaxY(attribute.frame) + self.sectionInsets.bottom;
            }
        
            [self.itemAttributes addObject:attribute];
        }
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    // 返回所有item frame
    return self.itemAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 返回单个item frame
    return self.itemAttributes[indexPath.item];
}

- (CGSize)collectionViewContentSize {
    // 重写此方法，可以设置正确的contentSize
    return CGSizeMake(0, self.contentMaxHeight);
}

#pragma mark - getter

- (NSMutableArray *)itemAttributes {
    if (!_itemAttributes) {
        _itemAttributes = [NSMutableArray array];
    }
    return _itemAttributes;
}

- (NSMutableArray *)itemHeights {
    if (!_itemHeights) {
        _itemHeights = [NSMutableArray array];
    }
    return _itemHeights;
}

@end
