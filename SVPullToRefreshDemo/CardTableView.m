//
//  CardTableView.m
//  SVPullToRefreshDemo
//
//  Created by luckyCoderCai on 2017/8/16.
//  Copyright © 2017年 luckyCoderCai. All rights reserved.
//

#import "CardTableView.h"
#import "CardModel.h"
#import "CardCell.h"

static NSString *const CardCellID = @"CardCell";

@interface CardTableView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation CardTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = [UIColor whiteColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.estimatedRowHeight = 100;
        self.rowHeight = UITableViewAutomaticDimension;
    }
    return self;
}

#pragma mark -tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CardCell *cell = [tableView dequeueReusableCellWithIdentifier:CardCellID];
    if (!cell) {
        cell = [[CardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CardCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"-click --%ld--%ld", indexPath.section, indexPath.row);
    if ([self.clickCellDelegate respondsToSelector:@selector(clickMyCardTableViewCellWith:)]) {
        
        CardModel *model = self.dataArray[indexPath.row];
        [self.clickCellDelegate clickMyCardTableViewCellWith:model];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
