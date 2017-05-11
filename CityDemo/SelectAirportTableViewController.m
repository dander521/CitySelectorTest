//
//  HandChooseAirportTableViewController.m
//  EnjoySkyLine
//
//  Created by 程荣刚 on 15/5/26.
//  Copyright (c) 2015年 西安融科通信技术有限公司. All rights reserved.
//

#import "SelectAirportTableViewController.h"
#import "PinYinForObjc.h"
#import "CityAirport.h"
#import "TXCityTableViewCell.h"

@interface SelectAirportTableViewController ()<UIAlertViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate, TXCityTableViewCellProtocol>
@property (weak, nonatomic) IBOutlet UITableView *selectAirportTableView; // 机场列表

@property (nonatomic) NSMutableArray *hotAirportIataArray; // 热门机场三字码
@property (strong, nonatomic) NSMutableArray *allValuesDataArray; // 所有机场数据
@property (nonatomic) NSMutableArray *filterDataArray; // 进行search时 筛选出的数据数组
@property (nonatomic, strong) UISearchDisplayController *strongSearchDisplayController; // UISearchDisplayController 对象
@property (strong, nonatomic) UISearchBar *searchBar; // 搜索框
@property (strong, nonatomic) UILocalizedIndexedCollation *collation;
@property (strong, nonatomic) NSMutableArray *allCityAirportArray; // 包含所有对象的数据
@property (strong, nonatomic) NSMutableArray *indexTitleArray; // 索引array

@property (strong, nonatomic) NSArray *allCityArray;

@end

@implementation SelectAirportTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择城市";
    self.hotAirportIataArray = [[NSMutableArray alloc] init];
    self.indexTitleArray = [[NSMutableArray alloc] init];
    self.allCityArray = @[@"北京", @"西安", @"成都", @"上海", @"天津", @"广州", @"北方", @"日船", @"鄂州", @"东北", @"阿拉川", @"南京", @"银川"];
    
    NSArray *arrayHotAirport = @[@"西安", @"成都", @"上海", @"天津"];
    
    for (int i = 0; i < [arrayHotAirport count]; i++)
    {
        CityAirport *cityAirport = [[CityAirport alloc] init];
        cityAirport.cityName = [arrayHotAirport objectAtIndex:i];
        [self.hotAirportIataArray addObject:cityAirport];
    }
    
    [self setSearchDisplayControllerAppearanceMode];
    [self getTableViewIndexArrayBySystemMethod];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.selectAirportTableView)
    {
        return [self.allCityAirportArray count];
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.selectAirportTableView)
    {
        return 1;
    }else{
        return [self.filterDataArray count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellInde = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellInde];

    if (self.selectAirportTableView == tableView) {
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TXCityTableViewCell class]) owner:self options:nil] lastObject];
        }
        NSArray *arraySection = [self.allCityAirportArray objectAtIndex:[indexPath section]];
        ((TXCityTableViewCell*)cell).delegate = self;
        ((TXCityTableViewCell*)cell).cityArray = arraySection;
    } else {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellInde];
        }
        CityAirport *cityAirport = [self.filterDataArray objectAtIndex:indexPath.row];
        cell.textLabel.text = cityAirport.cityName;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.selectAirportTableView) {
        NSArray *arraySection = [self.allCityAirportArray objectAtIndex:[indexPath section]];
        return [self calculatorRowHeightWithNumber:arraySection.count];
    } else {
        return 44.0;
    }
}

- (CGFloat)calculatorRowHeightWithNumber:(NSInteger)number {
    if (number % 3 == 0) {
        return number/3 * 55;
    } else {
        return (number/3 + 1) * 55;
    }
}

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *selectAirportName = cell.textLabel.text;
    NSLog(@"selectAirportName = %@", selectAirportName);
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.selectAirportTableView)
    {
        return 30.0;
    }else{
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.selectAirportTableView)
    {
        NSMutableArray *arrayTitleForSection = [NSMutableArray arrayWithArray:self.indexTitleArray];

        [arrayTitleForSection insertObject:@"热门城市" atIndex:0];

        NSArray *arraySection = [self.allCityAirportArray objectAtIndex:section];
        
        if ([arraySection count] == 0)
        {
            return nil;
        }

        return arrayTitleForSection[section];
    }else{
        return nil;
    }
}

// 右侧索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.selectAirportTableView)
    {
        NSMutableArray *arrayTitleForSection = [NSMutableArray arrayWithArray:self.indexTitleArray];

            [arrayTitleForSection insertObject:@"热" atIndex:0];

        [arrayTitleForSection insertObject:UITableViewIndexSearch atIndex:0];
        
        return arrayTitleForSection;
    }else{
        return nil;
    }
}

// section title
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (tableView == self.selectAirportTableView)
    {
        if (index != 0)
        {
            
        }else{
            [tableView setContentOffset:CGPointMake(0, -64) animated:NO];
        }

        return [self.collation sectionForSectionIndexTitleAtIndex:index] - 1;
    }else{
        return 0;
    }
}

#pragma UISearchDisplayDelegate

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}


#pragma mark - Custom Method

// 设置 UISearchDisplayController
- (void)setSearchDisplayControllerAppearanceMode
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    self.searchBar.placeholder = @"搜索";
    self.searchBar.delegate = self;
    
    // 添加 searchbar 到 headerview
    self.selectAirportTableView.tableHeaderView = self.searchBar;
    
    // 用 searchbar 初始化 SearchDisplayController 并把 searchDisplayController 和当前 controller 关联起来
    self.strongSearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    
    self.strongSearchDisplayController.searchResultsDataSource = self;
    self.strongSearchDisplayController.searchResultsDelegate = self;
    self.strongSearchDisplayController.delegate = self;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.filterDataArray = [[NSMutableArray alloc]init];
    for (int j = 0; j < [self.allCityAirportArray count]; j++)
    {
        NSArray *arraySection = [self.allCityAirportArray objectAtIndex:j];
        // 搜索为拼音
        if ([self.searchBar.text length] > 0 && ![SelectAirportTableViewController isIncludeChineseInString:self.searchBar.text])
        {
            for (int i=0; i < [arraySection count]; i++)
            {
                CityAirport *cityAirport = [arraySection objectAtIndex:i];
                
                // 数据源包含汉字
                if ([SelectAirportTableViewController isIncludeChineseInString:cityAirport.cityName])
                {
                    // 汉字首字母
                    NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:cityAirport.cityName];
                    NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                    
                    // 汉字全拼
                    NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:cityAirport.cityName];
                    NSRange titleResult=[tempPinYinStr rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                    
                    if (titleHeadResult.length > 0)
                    {
                        [self.filterDataArray addObject:cityAirport];
                    }else if (titleResult.length > 0 && [tempPinYinStr hasPrefix:self.searchBar.text])
                    {
                        [self.filterDataArray addObject:cityAirport];
                    }
                }
                // 数据源不包含汉字
                else{
                    NSRange titleResult=[cityAirport.cityName rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                    if (titleResult.length > 0)
                    {
                        // 输入三字码 进行筛选
                        [self.filterDataArray addObject:cityAirport];
                    }
                }
            }
        } else if ([self.searchBar.text length] > 0 && [SelectAirportTableViewController isIncludeChineseInString:self.searchBar.text])
        {
            for (int i = 0; i < [arraySection count]; i++)
            {
                CityAirport *cityAirport = [arraySection objectAtIndex:i];
                
                NSRange titleResult = [cityAirport.cityName rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length > 0)
                {
                    [self.filterDataArray addObject:cityAirport];
                }
            }
        }
    }
    
    // 对于相同搜索结果的数据进行过滤
    for (int i = 0; i < [self.filterDataArray count]; i++)
    {
        CityAirport *filterAirport1 = [self.filterDataArray objectAtIndex:i];
        
        for (int j = 0; j < i; j++)
        {
            CityAirport *filterAirport2 = [self.filterDataArray objectAtIndex:j];
            
            if ([filterAirport1.cityName isEqualToString:filterAirport2.cityName])
            {
                [self.filterDataArray removeObjectAtIndex:i];
            }
        }
    }
}


// 通过系统自带方法获取索引
- (void)getTableViewIndexArrayBySystemMethod
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        self.collation = [UILocalizedIndexedCollation currentCollation];
        
        //得出collation索引的数量，这里是27个（26个字母和1个#）
        NSInteger sectionTitlesCount = [[self.collation sectionTitles] count];
        
        NSMutableArray *titleArray = [NSMutableArray arrayWithArray:[self.collation sectionTitles]];
        
        NSMutableArray *tempAllCityAirportArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
        
        //初始化27个空数组加入newSectionsArray
        for (NSInteger index = 0; index < sectionTitlesCount; index++)
        {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [tempAllCityAirportArray addObject:array];
        }
        
        self.allValuesDataArray = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [self.allCityArray count]; i++)
        {
            CityAirport *cityAirport = [[CityAirport alloc] init];
            cityAirport.cityName = [self.allCityArray objectAtIndex:i];
            [self.allValuesDataArray addObject:cityAirport];
            }
        
        //将每个airport分到某个section下
        for (CityAirport *ObjectCityName in self.allValuesDataArray)
        {
            // 获取位置
            NSInteger sectionNumber = [self.collation sectionForObject:ObjectCityName collationStringSelector:@selector(cityName)];
            
            //放入指定的数组
            NSMutableArray *sectionNames = tempAllCityAirportArray[sectionNumber];
            [sectionNames addObject:ObjectCityName];
        }
        
        //对每个section中的数组按照cityName属性排序
        for (NSInteger index = 0; index < sectionTitlesCount; index++)
        {
            NSMutableArray *personArrayForSection = tempAllCityAirportArray[index];
            NSArray *sortedPersonArrayForSection = [self.collation sortedArrayFromArray:personArrayForSection collationStringSelector:@selector(cityName)];
            
            tempAllCityAirportArray[index] = sortedPersonArrayForSection;
        }
        
        self.allCityAirportArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < tempAllCityAirportArray.count; i++) {
            NSArray *arraySection = tempAllCityAirportArray[i];
            if ([arraySection count] != 0) {
                [self.indexTitleArray addObject:titleArray[i]];
            }
        }
        [tempAllCityAirportArray insertObject:self.hotAirportIataArray atIndex:0];
        
        // 去除空数组
        for (NSArray *sectionArray in tempAllCityAirportArray)
        {
            if ([sectionArray count] != 0)
            {
                [self.allCityAirportArray addObject:sectionArray];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.selectAirportTableView reloadData];
        });
    });
}

/**
 * @method 检查字符串是否含有汉字
 *
 * @param inputString 传入的字符串
 */
+ (BOOL)isIncludeChineseInString:(NSString *)inputString
{
    for (int i = 0; i < [inputString length]; i++) {
        unichar ch = [inputString characterAtIndex:i];
        if (0x4e00 < ch  && ch < 0x9fff) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - TXCityTableViewCellProtocol

- (void)didSelectedCityName:(NSString *)cityName {
    NSLog(@"cityName = %@", cityName);
}

@end
