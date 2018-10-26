//
//  MenuViewController.m
//  FlexLayout
//
//  Created by 任 洪杰 on 2018/10/23.
//  Copyright © 2018年 任 洪杰. All rights reserved.
//

#import "MenuViewController.h"
#import "IntroViewController.h"
#import "NewsCardViewController.h"
#import "TableViewController.h"

typedef NS_ENUM(NSUInteger, ExampleType) {
    ETIntroController,
    ETNewsCard,
    ETTableView,
    ETCount,
};

@interface MenuViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *cellIdentifier;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"FlexLayout Examples";
    self.cellIdentifier = @"MenuCell";
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:self.cellIdentifier];
    
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark private methods

- (NSString *)p_exampleNameWithType:(ExampleType)exampleType {
    NSString *name = @"Example X";
    switch (exampleType) {
        case ETIntroController:
            name = @"Intro Controller";
            break;
        case ETNewsCard:
            name = @"News Card";
            break;
        case ETTableView:
            name = @"TableView";
            break;
        case ETCount:
            name = @"View Controller";
            break;
            
        default:
            break;
    }
    return name;
}

- (UIViewController *)p_exampleViewControllerWithType:(ExampleType)exampleType {
    UIViewController *controller = [IntroViewController new];
    switch (exampleType) {
        case ETIntroController:
            controller = [IntroViewController new];
            break;
        case ETNewsCard:
            controller = [NewsCardViewController new];
            break;
        case ETTableView:
            controller = [TableViewController new];
            break;
        case ETCount:
            controller = [IntroViewController new];
            break;
            
        default:
            break;
    }
    return controller;
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ETCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    cell.textLabel.text = [self p_exampleNameWithType:(ExampleType)indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:[self p_exampleViewControllerWithType:indexPath.row] animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
