//
//  ViewController.m
//  SVPullToRefreshDemo
//
//  Created by luckyCoderCai on 2017/8/16.
//  Copyright © 2017年 luckyCoderCai. All rights reserved.
//

#import "ViewController.h"
#import "SVPullToRefresh.h"
#import "MBProgressHUD.h"
#import "Masonry.h"
#import "CardTableView.h"
#import "SecondController.h"
#import "CardModel.h"

static NSInteger kPageSize = 10;//每页条数

@interface ViewController ()<CardTableViewDelegate>

@property (nonatomic, strong) CardTableView *tableView;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) UIView *myErrorView;
@property (nonatomic, strong) UILabel *myErrorLabel;
@property (nonatomic, strong) UILabel *myErrorBotLabel;
@property (nonatomic, strong) UIImageView *myErrorImgView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) BOOL isFirstLoad;//首次加载显示loading 此后不再显示

@property (nonatomic, assign) NSInteger loadMoreIndex;//记录上拉次数 -为了模拟-实际可能不需要

@end

@implementation ViewController

#pragma mark -lazy load
- (CardTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[CardTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.clickCellDelegate = self;
        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 0, 0);
    }
    return _tableView;
}

- (UIView *)myErrorView
{
    if (!_myErrorView) {
        _myErrorView = [[UIView alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firstLoadData)];
        [_myErrorView addGestureRecognizer:tap];
        _myErrorView.hidden = YES;
    }
    return _myErrorView;
}

- (UILabel *)myErrorLabel
{
    if (!_myErrorLabel) {
        _myErrorLabel = [[UILabel alloc] init];
        _myErrorLabel.text = @"页面加载失败";
        _myErrorLabel.textAlignment = NSTextAlignmentCenter;
        _myErrorLabel.font = [UIFont systemFontOfSize:15];
        _myErrorLabel.textColor = [UIColor orangeColor];
    }
    return _myErrorLabel;
}

- (UILabel *)myErrorBotLabel
{
    if (!_myErrorBotLabel) {
        _myErrorBotLabel = [[UILabel alloc] init];
        _myErrorBotLabel.text = @"点击刷新";
        _myErrorBotLabel.textAlignment = NSTextAlignmentCenter;
        _myErrorBotLabel.font = [UIFont systemFontOfSize:15];
        _myErrorBotLabel.textColor = [UIColor blueColor];
        _myErrorBotLabel.hidden = YES;
    }
    return _myErrorBotLabel;
}

- (UIImageView *)myErrorImgView
{
    if (!_myErrorImgView) {
        _myErrorImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_jiazaishibai"]];
    }
    return _myErrorImgView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"帖子";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.loadMoreIndex = 0;
    self.isFirstLoad = YES;
    
    [self setupUI];
    [self setupErrorUI];
    
    [self contentRefresh];
    [self contentLoadMore];
    
    [self firstLoadData];
    
}

#pragma mark -首次加载数据
- (void)firstLoadData
{
    self.currentIndex = 1;
    [self requestMyCardListData];
}

#pragma mark -下拉刷新
- (void)contentRefresh
{
    __weak typeof(self) weakSelf = self;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        __strong typeof(weakSelf) sself = weakSelf;
        
        sself.loadMoreIndex = 0;
        sself.currentIndex = 1;
        [sself requestMyCardListData];
    }];
    
}

#pragma mark -上拉加载
- (void)contentLoadMore
{
    __weak typeof(self) weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        
        __strong typeof(weakSelf) sself = weakSelf;
        
        sself.loadMoreIndex ++;
        [sself requestMyCardListData];
    }];
}

#pragma mark -数据
- (void)requestMyCardListData
{
    //模拟网路请求
    MBProgressHUD *hud;
    if (self.isFirstLoad) {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        __strong typeof(weakSelf) sself = weakSelf;
        
        if (sself.isFirstLoad) {
            [hud hideAnimated:YES];
        }
        
        BOOL isSuccess = YES;
        if (isSuccess) {//请求成功
            
            sself.isFirstLoad = NO;
            
            if (sself.currentIndex == 1) {//下拉
                [sself.dataArray removeAllObjects];
                sself.tableView.showsInfiniteScrolling = YES;
            }
            
            sself.currentIndex += 1;
            
            NSInteger dataNum = 10;
            if (sself.loadMoreIndex == 3) {
                dataNum = 3;
            }
            
            NSMutableArray *array = [NSMutableArray array];
            for (int i = 0; i < dataNum; i ++) {
                CardModel *model = [[CardModel alloc] init];
                model.cardContent = [NSString stringWithFormat:@"内容%d", i];
                model.color = i;
                model.day = i + 2;
                model.month = i + 1;
                [array addObject:model];
            }
            
            [sself.dataArray addObjectsFromArray:array];
            
            sself.tableView.dataArray = sself.dataArray;
            [sself.tableView reloadData];
            
            if (sself.dataArray.count == 0) {
                sself.myErrorView.hidden = NO;
                sself.tableView.hidden = YES;
                sself.myErrorView.userInteractionEnabled = NO;
                
                sself.myErrorLabel.text = @"还没有发帖哦!";
                sself.myErrorBotLabel.hidden = YES;
            }else {
                sself.myErrorView.hidden = YES;
                sself.tableView.hidden = NO;
            }
            
            if (array.count < kPageSize) {//数据不足一页时 不显示上拉控件
                sself.tableView.showsInfiniteScrolling = NO;
            }
            
        }else {//error
            
            if (sself.dataArray.count > 0) {//如果已经有数据 错误提示
                sself.myErrorView.hidden = YES;
                sself.tableView.hidden = NO;
                
                //提示
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:sself.view animated:YES];
                [hud hideAnimated:YES afterDelay:2];
            }else {//没数据 错误页面 -点击重试
                sself.myErrorView.hidden = NO;
                sself.tableView.hidden = YES;
                sself.myErrorView.userInteractionEnabled = YES;
                sself.myErrorLabel.text = @"页面加载失败";
                sself.myErrorBotLabel.hidden = NO;
            }
        }
        
        [sself.tableView.pullToRefreshView stopAnimating];
        [sself.tableView.infiniteScrollingView stopAnimating];
        
    });
}

#pragma mark -errorUI
- (void)setupErrorUI
{
    [self.view addSubview:self.myErrorView];
    [_myErrorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).mas_offset(-12);
        make.size.mas_equalTo(CGSizeMake(200, 150));
    }];
    
    [self.myErrorView addSubview:self.myErrorImgView];
    [self.myErrorView addSubview:self.myErrorLabel];
    [self.myErrorView addSubview:self.myErrorBotLabel];
    
    [_myErrorImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_myErrorView);
        make.centerX.equalTo(_myErrorView);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [_myErrorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_myErrorView);
        make.top.equalTo(_myErrorImgView.mas_bottom).with.offset(20);
        make.height.mas_equalTo(20);
    }];
    
    [_myErrorBotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_myErrorView);
        make.top.equalTo(_myErrorLabel.mas_bottom).mas_offset(15);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
}

#pragma mark -UI
- (void)setupUI
{
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.and.trailing.equalTo(@0);
        make.top.equalTo(self.mas_topLayoutGuideTop);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
}

#pragma mark -点击cell进入帖子详情
- (void)clickMyCardTableViewCellWith:(CardModel *)model
{
    SecondController *vc = [[SecondController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
