//
//  CandyFlowLayout.h
//  瀑布流
//
//  Created by cotton candy on 2019/8/23.
//  Copyright © 2019 Cotton candy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CandyFlowLayoutStyle) {
    CandyFlowLayoutStyleWaterfall = 0, // 竖向瀑布流，等宽不等高
    CandyFlowLayoutStyleSameHeight,   // 等高不等宽排列展示
    CandyFlowLayoutStyleSpecial,          // 特殊样式 带有分类标题或者全部 
};

@protocol CandyFlowLayoutDelegate <NSObject>

@optional

/** 返回item size */
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

/** 返回item height 瀑布流时使用 */
- (CGFloat)heightForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface CandyFlowLayout : UICollectionViewFlowLayout

/** default 0 */
@property (nonatomic, assign) UIEdgeInsets sectionInsets;
/** default 0  左右*/
@property (nonatomic, assign) CGFloat minItemSpacing;
/** default 0  上下*/
@property (nonatomic, assign) CGFloat minLineSpacing;

@property (nonatomic, assign) CandyFlowLayoutStyle style;

@property (nonatomic, weak) id<CandyFlowLayoutDelegate> delegate;

/** 瀑布流每行item总数，宽度等分 */
@property (nonatomic, assign) NSInteger waterfallRowNumber;

- (instancetype)initSectionInsets:(UIEdgeInsets)sectionInsets minItemSpacing:(CGFloat)minItemSpacing minLineSpacing:(CGFloat)minLineSpacing;

@end

NS_ASSUME_NONNULL_END
