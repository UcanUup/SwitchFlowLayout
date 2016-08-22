//
//  CollectionViewCell.m
//  FlowLayout
//
//  Created by Young on 16/8/4.
//  Copyright © 2016年 Young. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"CollectionViewCell" owner:self options:nil];
        if (![views count]) return nil;
        if (![[views objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) return nil;
        self = [views objectAtIndex:0];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

@end
