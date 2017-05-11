//
//  TXCityCollectionViewCell.m
//  CityDemo
//
//  Created by 倩倩 on 17/5/11.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "TXCityCollectionViewCell.h"

@interface TXCityCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *itemButton;

@end

@implementation TXCityCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.itemButton.layer.borderWidth = 0.5;
    self.itemButton.layer.borderColor = [UIColor redColor].CGColor;
}

- (void)setButtonTitle:(NSString *)buttonTitle {
    _buttonTitle = buttonTitle;
    [self.itemButton setTitle:buttonTitle forState:UIControlStateNormal];
}

@end
