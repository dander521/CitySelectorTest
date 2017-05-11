//
//  HandChooseAirportTableViewController.h
//  EnjoySkyLine
//
//  Created by 程荣刚 on 15/5/26.
//  Copyright (c) 2015年 西安融科通信技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectAirportDelegate <NSObject>

- (void)didSelectedAirportID:(NSString *)airportID;

@end

@interface SelectAirportTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (assign, nonatomic) id <SelectAirportDelegate> delegate; // 代理指针

@end
