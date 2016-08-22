//
//  ViewController.m
//  FlowLayout
//
//  Created by Young on 16/8/4.
//  Copyright © 2016年 Young. All rights reserved.
//

#import "ViewController.h"

#import "CollectionViewCell.h"


@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (assign, nonatomic) CGSize itemSize;
@property (assign, nonatomic) NSInteger itemNum;
@property (assign, nonatomic) NSInteger currentIndex;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _itemSize = CGSizeMake(80, 80);
    _itemNum = 10;
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.alwaysBounceHorizontal = YES;
    _collectionView.decelerationRate = 0.5f;
    
    [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    
    _flowLayout.minimumInteritemSpacing = 10;
    _flowLayout.itemSize = _itemSize;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGFloat collectionViewWidth = CGRectGetWidth(_containerView.bounds);
    _flowLayout.headerReferenceSize = CGSizeMake((collectionViewWidth - _itemSize.width) / 2, _itemSize.height);
    _flowLayout.footerReferenceSize = CGSizeMake((collectionViewWidth - _itemSize.width) / 2, _itemSize.height);
}


#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _itemNum;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
//    CGFloat containerWidth = CGRectGetWidth(_containerView.frame);
//    self.itemSize = (containerWidth-_flowLayout.minimumInteritemSpacing*2)/3;
//    _flowLayout.itemSize = CGSizeMake(_itemSize, _itemSize);
//    return CGSizeMake(_itemSize, _itemSize);
    return _itemSize;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@", @(indexPath.row+1));
    [self.collectionView setUserInteractionEnabled:NO];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    self.currentIndex = indexPath.row;
    [self performSelector:@selector(collectionViewSetUserInteractionEnabled:) withObject:@(indexPath.row) afterDelay:0.25f];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    
    cell.imageView.backgroundColor = [UIColor colorWithRed:(arc4random()%256)/255.0 green:(arc4random()%256)/255.0 blue:(arc4random()%256)/255.0 alpha:1];
    cell.imageView.layer.cornerRadius = _itemSize.width / 2;
    cell.imageView.layer.masksToBounds = YES;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        return view;
    } else if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
        return view;
    }
    return nil;
}

- (void)collectionViewSetUserInteractionEnabled:(NSNumber *)row
{
    [self.collectionView setUserInteractionEnabled:YES];
    [self.collectionView reloadData];
}


#pragma mark - View

- (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated
{
    if (index < 0 || index >= _itemNum) return;
    if (index < _itemNum) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
        self.currentIndex = index;
    }
}

@end
