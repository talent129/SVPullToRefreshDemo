//
//  CardModel.h
//  SVPullToRefreshDemo
//
//  Created by luckyCoderCai on 2017/8/16.
//  Copyright © 2017年 luckyCoderCai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardModel : NSObject

@property (nonatomic, copy) NSString *cardContent;
@property (nonatomic, assign) NSInteger color;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;

@end
