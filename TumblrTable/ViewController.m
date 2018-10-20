//
//  ViewController.m
//  TumblrTable
//
//  Created by 邓杰豪 on 2018/10/19.
//  Copyright © 2018年 邓杰豪. All rights reserved.
//

#import "ViewController.h"
#import <PooTools/Utils.h>
#import <PooTools/PMacros.h>
#import <MJRefresh/MJRefresh.h>
#import <Masonry/Masonry.h>

#define ShowAdCount 10
#define CellH 100
#define RowCount 100
#define ChangeAdImageCount 3
#define DelaySecond 1

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic,strong) UITableView *tbView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    __block NSInteger refreshTimes = 0;
    
    UIImage *bgImage = kImageNamed(@"DemoImage.png");

    self.tbView    = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tbView.layer.contents = (id)bgImage.CGImage;
    self.tbView.layer.backgroundColor = kClearColor.CGColor;
    self.tbView.dataSource                     = self;
    self.tbView.delegate                       = self;
    self.tbView.showsHorizontalScrollIndicator = NO;
    
    self.tbView.showsVerticalScrollIndicator   = NO;
    self.tbView.separatorStyle                 = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tbView];
    self.tbView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*DelaySecond), dispatch_get_main_queue(), ^{
            refreshTimes++;
            [self.tbView.mj_header endRefreshing];
            if (refreshTimes%ChangeAdImageCount == 0) {
                UIImage *bgImage = kImageNamed(@"octocat");
                self.tbView.layer.contents = (id)bgImage.CGImage;
                self.tbView.layer.backgroundColor = kClearColor.CGColor;
            }
        });
    }];
    [self.tbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTableAdView)];
    tap.cancelsTouchesInView = NO;
    tap.delegate = self;
    [self.tbView addGestureRecognizer:tap];
    
    UIButton *refreshAD = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [refreshAD addTarget:self action:@selector(refreshADAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refreshAD];
    [refreshAD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(44);
        make.top.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
    }];
}

#pragma mark ---------------> Action
-(void)tapTableAdView
{
    [Utils alertShowWithMessage:@"BG"];
}

-(void)refreshADAction:(UIButton *)sender
{
    UIImage *bgImage = kImageNamed(@"DemoImage.png");
    self.tbView.layer.contents = (id)bgImage.CGImage;
    self.tbView.layer.backgroundColor = kClearColor.CGColor;
}

#pragma mark ---------------> UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return RowCount;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

static NSString *cellIdentifier = @"CELL";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    kTableCellFullInit(cell, UITableViewCell, UITableViewCellStyleDefault, cellIdentifier);
    
    if (indexPath.row != 0) {
        if (indexPath.row%ShowAdCount == 0) {
            cell.hidden = YES;
        }
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    cell.backgroundColor = [UIColor blueColor];
    
    return cell;
}

#pragma mark ---------------> UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0) {
        if (indexPath.row%ShowAdCount == 0) {
            return self.view.frame.size.height;
        }
    }
    return CellH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [Utils alertShowWithMessage:[NSString stringWithFormat:@"CELL%ld",(long)indexPath.row]];
}

#pragma mark ------> UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UITableView class]]) {
        return YES;
    }
    return  NO;
}
@end
