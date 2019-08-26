//
//  CustomCell.m
//  瀑布流
//
//  Created by chenyun on 2019/8/26.
//  Copyright © 2019 Cotton candy. All rights reserved.
//

#import "CustomCell.h"

@interface CustomCell ()

@end

@implementation CustomCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.contentLab];
        self.layer.cornerRadius = 5;
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentLab.frame = self.bounds;
}

- (UILabel *)contentLab {
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] init];
        _contentLab.font = [UIFont systemFontOfSize:17];
        _contentLab.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLab;
}

@end

