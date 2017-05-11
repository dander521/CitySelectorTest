//
//  TXCityTableViewCell.h
//  CityDemo
//
//  Created by 倩倩 on 17/5/11.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TXCityTableViewCellProtocol <NSObject>

- (void)didSelectedCityName:(NSString *)cityName;

@end

@interface TXCityTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UICollectionView *sectionCollectionView;
@property (nonatomic, strong) NSArray *cityArray;
@property (nonatomic, assign) id <TXCityTableViewCellProtocol> delegate;

@end
