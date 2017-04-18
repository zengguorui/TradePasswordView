//
//  TradePasswordView.h
//  TradePasswordDemo
//
//  Created by 曾国锐 on 2016/11/22.
//  Copyright © 2016年 曾国锐. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TradePasswordView;
typedef void (^cencelButtonBlcok) (void);
typedef void (^confirmButtonBlcok) (NSString *password, TradePasswordView *tradePasswordView);
typedef enum {
    ENUM_PasswordTypeTrading = 0,//交易密码
    ENUM_PasswordTypeSetting//设置交易密码
} ENUM_PasswordType;

@interface TradePasswordView : UIView

@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)NSString *errorStr;
@property (nonatomic, strong)NSString *detailTitle;
@property (nonatomic, strong)NSString *buyButtonTitleStr;
@property (nonatomic, strong)NSString *titleOneStr;
/**
 开启手续费
 */
@property (nonatomic, assign)BOOL isPoundage;
@property(nonatomic, copy)confirmButtonBlcok confirmButtonBlcok;


- (instancetype)initWithTitle:(NSString *)title detailTitle:(NSString *)detailTitle buyMoney:(NSString *)buyMoney isPoundage:(BOOL)isPoundage poundage:(NSString *)poundage passwordType:(ENUM_PasswordType)passwordType;
- (void)show;
- (void)dismiss;

- (void)clearText;

@end
