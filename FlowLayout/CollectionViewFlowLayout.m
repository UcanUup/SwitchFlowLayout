//
//  CollectionViewFlowLayout.m
//  FlowLayout
//
//  Created by Young on 16/8/4.
//  Copyright © 2016年 Young. All rights reserved.
//

#import "CollectionViewFlowLayout.h"

@implementation CollectionViewFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
//    NSMutableArray *attributes = [NSMutableArray array];
//    for (NSInteger i = 0; i < self.collectionView.numberOfSections; i++) {
//        for (NSInteger j = 0; j < [self.collectionView numberOfItemsInSection:i]; j++) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
//            [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
//        }
//    }
    NSArray *attrs = [[NSArray alloc] initWithArray:attributes copyItems:YES];
    
    CGFloat collectViewWidth = CGRectGetWidth(self.collectionView.frame);
    CGFloat contentOffsetX = self.collectionView.contentOffset.x;
    
    for (UICollectionViewLayoutAttributes *attr in attrs) {
        if (attr.representedElementCategory != UICollectionElementCategoryCell) continue;
        
        CGFloat centerX = attr.center.x;
        CGFloat distance = fabs(centerX-contentOffsetX-collectViewWidth/2);
        
        CGFloat maxScaleDistance = self.itemSize.width + self.minimumInteritemSpacing;
        CGFloat maxMultiple = 0.5;
        CGFloat multiple;
        multiple = 1 + (maxMultiple - 1) * distance / maxScaleDistance;
        if (multiple < 0) multiple = 0;
        
        attr.alpha = multiple;
        attr.transform = CGAffineTransformMakeScale(multiple, multiple);
    }
    
    return attrs;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGRect rect;
    rect.origin = proposedContentOffset;
    rect.size = self.collectionView.frame.size;
    NSArray *attrs = [super layoutAttributesForElementsInRect:rect];
    
    CGFloat collectViewWidth = CGRectGetWidth(self.collectionView.frame);
    
    UICollectionViewLayoutAttributes *proposedAttr;
    CGFloat minDistance = CGFLOAT_MAX;
    for (UICollectionViewLayoutAttributes *attr in attrs) {
        if (attr.representedElementCategory != UICollectionElementCategoryCell) continue;
        
        CGFloat centerX = attr.center.x;
        CGFloat distance = fabs(centerX-proposedContentOffset.x-collectViewWidth/2);
        if (distance < minDistance) {
            proposedAttr = attr;
            minDistance = distance;
        }
    }
    
//    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
//        [self.collectionView.delegate collectionView:self.collectionView didSelectItemAtIndexPath:proposedAttr.indexPath];
//    }
    
    CGFloat targetContentOffsetX = proposedAttr.center.x - collectViewWidth / 2;
    if (targetContentOffsetX < 0) targetContentOffsetX = 0;
    return CGPointMake(targetContentOffsetX, 0);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

@end
