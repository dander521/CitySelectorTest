//
//  TXCityTableViewCell.m
//  CityDemo
//
//  Created by 倩倩 on 17/5/11.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "TXCityTableViewCell.h"
#import "TXCityCollectionViewCell.h"
#import "CityAirport.h"

@interface TXCityTableViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation TXCityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUpCollectionView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置collectionView的滚动方向，需要注意的是如果使用了collectionview的headerview或者footerview的话， 如果设置了水平滚动方向的话，那么就只有宽度起作用了了
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
     layout.minimumInteritemSpacing = 10;// 垂直方向的间距
     layout.minimumLineSpacing = 10; // 水平方向的间距
    _sectionCollectionView.collectionViewLayout = layout;
    _sectionCollectionView.scrollEnabled = false;
    _sectionCollectionView.backgroundColor = [UIColor whiteColor];
    _sectionCollectionView.dataSource = self;
    _sectionCollectionView.delegate = self;
    [_sectionCollectionView registerClass:[TXCityCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    UINib *nib = [UINib nibWithNibName:@"TXCityCollectionViewCell"
                                bundle: [NSBundle mainBundle]];
    [_sectionCollectionView registerNib:nib forCellWithReuseIdentifier:@"cell"];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CityAirport *cityAirport = [_cityArray objectAtIndex:indexPath.item];
    if ([self.delegate respondsToSelector:@selector(didSelectedCityName:)]) {
        [self.delegate didSelectedCityName:cityAirport.cityName];
    }
}

#pragma mark - UICollectionViewDataSource

/** 每组cell的个数*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _cityArray.count;
}

/** cell的内容*/
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TXCityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    CityAirport *cityAirport = [_cityArray objectAtIndex:indexPath.item];
    cell.buttonTitle = cityAirport.cityName;
    return cell;
}

/** 总共多少组*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark -- UICollectionViewDelegateFlowLayout
/** 每个cell的尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width - 50)/3, 44.0);
}
/** section的margin*/
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}


@end
