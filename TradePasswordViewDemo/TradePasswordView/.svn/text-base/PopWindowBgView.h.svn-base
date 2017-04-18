//
//  PopWindowBgView.h
//  TradePasswordDemo
//
//  Created by 曾国锐 on 2016/11/22.
//  Copyright © 2016年 曾国锐. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PasswordTextView.h"

typedef void (^popCencelButtonBlcok) (void);
typedef void (^popDetermineButtonBlcok) (NSString *password, NSString *errorStr);

typedef enum {
    ENUM_PopWindowBgTypeTrading = 0,//交易密码-密码遮掩
    ENUM_PopWindowBgTypeSetting//设置交易密码
    
} ENUM_PopWindowBgType;

@interface PopWindowBgView : UIView

@property(nonatomic, copy)popCencelButtonBlcok cencelButtonBlcok;
@property (weak, nonatomic) IBOutlet UILabel *detailTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buyMoneyTitleTopLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buyMoneyNumberTopLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineViewTopLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordViewTopLayoutConstraint;

@property (nonatomic, assign)ENUM_PopWindowBgType type;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyMoneyLabel;
/**
 错误信息
 */
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;

/**
 第一行标签
 */
@property (weak, nonatomic) IBOutlet UILabel *titleOneLabel;

/**
 第二行标签
 */
@property (weak, nonatomic) IBOutlet UILabel *titleTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleTwoNumberLabel;

@property (weak, nonatomic)IBOutlet PasswordTextView *passwordTextView;

@property(nonatomic, copy)popDetermineButtonBlcok determineButtonBlock;

- (void)clearText;

@end
