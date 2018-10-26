//
//  TableViewController.m
//  FlexLayout
//
//  Created by 任 洪杰 on 2018/10/26.
//  Copyright © 2018年 任 洪杰. All rights reserved.
//

#import "TableViewController.h"
#import "MethodCell.h"

@interface TableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataSource = [NSMutableArray array];
    [_dataSource addObjectsFromArray:[self getMethods]];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 10;
    [_tableView registerClass:[MethodCell class] forCellReuseIdentifier:NSStringFromClass([MethodCell class])];
    
    [self.view addSubview:_tableView];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MethodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MethodCell"];
    cell.item = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark - mock data

- (NSArray *)getMethods {
    NSArray *methodArray = @[[MethodItem itemWithName:@"direction(_: Direction)"
                                          description:@"The direction property establishes the main-axis, thus defining the direction flex items are placed in the flex container container container."],
                             [MethodItem itemWithName:@"wrap(_: Wrap)"
                                          description:@"The `wrap` property controls whether the flex container is single-lined or multi-lined, and the direction of the cross-axis, which determines the direction in which the new lines are stacked in.\n\nBy default, the flex container fits all flex items into one line. Using this property we can change that. We can tell the container to lay out its items in single or multiple lines, and the direction the new lines are stacked in."],
                             [MethodItem itemWithName:@"justifyContent(_: JustifyContent)"
                                          description:@"The `justifyContent` property defines the alignment along the main-axis of the current line of the flex container. It helps distribute extra free space leftover when either all the flex items on a line have reached their maximum size. "],
                             [MethodItem itemWithName:@"alignItems(_: AlignItems)"
                                          description:@"The `alignItems` property defines how flex items are laid out along the cross axis on the current line. Similar to `justifyContent` but for the cross-axis (perpendicular to the main-axis)."],
                             [MethodItem itemWithName:@"alignSelf(_: AlignSelf)"
                                          description:@"The `alignSelf` property controls how a child aligns in the cross direction, overriding the `alignItems` of the parent. For example, if children are flowing vertically, `alignSelf` will control how the flex item will align horizontally.\n\n The \"auto\" value means use the flex container `alignItems` property. See `alignItems` for documentation of the other values."],
                             [MethodItem itemWithName:@"alignContent(_: AlignContent)"
                                          description:@"The align-content property aligns a flex container’s lines within the flex container when there is extra space in the cross-axis, similar to how justifyContent aligns individual items within the main-axis.\n\nNote, alignContent has no effect when the flexbox has only a single line."],
                             [MethodItem itemWithName:@"layoutDirection(_: LayoutDirection)"
                                          description:@"The layoutDirection property controls the flex container layout direction.\n\nValues:\n-`.inherit`\n  Direction defaults to Inherit on all nodes except the root which defaults to LTR. It is up to you to detect the user’s preferred direction (most platforms have a standard way of doing this) and setting this direction on the root of your layout tree.\n-.ltr: Layout views from left to right. (Default)\n-.rtl: Layout views from right to left."]
                             ];
    
    return methodArray;
}

@end
