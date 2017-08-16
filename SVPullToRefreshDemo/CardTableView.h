//
//  CardTableView.h
//  SVPullToRefreshDemo
//
//  Created by luckyCoderCai on 2017/8/16.
//  Copyright © 2017年 luckyCoderCai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CardModel;
@protocol CardTableViewDelegate <NSObject>

- (void)clickMyCardTableViewCellWith:(CardModel *)model;

@end

@interface CardTableView : UITableView

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, weak) id<CardTableViewDelegate> clickCellDelegate;

@end
