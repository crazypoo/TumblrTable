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

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic,strong) UITableView *tbView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImage *bgImage = kImageNamed(@"DemoImage.png");

    self.tbView    = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.tbView.layer.contents = (id)bgImage.CGImage;
    self.tbView.layer.backgroundColor = kClearColor.CGColor;
    self.tbView.dataSource                     = self;
    self.tbView.delegate                       = self;
    self.tbView.showsHorizontalScrollIndicator = NO;
    self.tbView.showsVerticalScrollIndicator   = NO;
    self.tbView.separatorStyle                 = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tbView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAlertView:)];
    tap.cancelsTouchesInView = NO;
    tap.delegate = self;
    [self.tbView addGestureRecognizer:tap];
}

-(void)tapAlertView:(UIGestureRecognizer *)ges
{
    [Utils alertShowWithMessage:@"BG"];
}

#pragma mark ---------------> UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

static NSString *cellIdentifier = @"CELL";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    else
    {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    if (indexPath.row != 0) {
        if (indexPath.row%10 == 0) {
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
        if (indexPath.row%10 == 0) {
            return self.view.frame.size.height;
        }
    }
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [Utils alertShowWithMessage:@"CELL"];
}

#pragma mark ------> UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UITableView class]]) {
        return YES;
    }
    return  NO;
}
@end
