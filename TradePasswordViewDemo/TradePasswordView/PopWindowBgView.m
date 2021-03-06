//
//  PopWindowBgView.m
//  TradePasswordDemo
//
//  Created by 曾国锐 on 2016/11/22.
//  Copyright © 2016年 曾国锐. All rights reserved.
//

#import "PopWindowBgView.h"
#import "UIView+Extension.h"
#import <AudioToolbox/AudioToolbox.h>

@interface PopWindowBgView (){
    
    __block NSString *_password;
    
}
@end

@implementation PopWindowBgView

- (void)drawRect:(CGRect)rect {
    // Drawing code
    _passwordTextView.passwordBlock = ^(NSString *password){
        _password = password;
    };
}

- (void)setType:(ENUM_PopWindowBgType)type{
    _type = type;

    switch (type) {
        case ENUM_PopWindowBgTypeTrading:
        {
            _buyMoneyTitleTopLayoutConstraint.constant = 0;
            _buyMoneyNumberTopLayoutConstraint.constant = 0;
            _passwordTextView.secureTextEntry = YES;
        }
            break;
        case ENUM_PopWindowBgTypeSetting:
        {
            _buyMoneyTitleTopLayoutConstraint.constant = 10;
            _buyMoneyNumberTopLayoutConstraint.constant = 10;
        }
            break;
            
        default:
            break;
    }
    
    self.height = self.buyButton.y+self.buyButton.height+10;
}

- (void)setDetailTitleLabel:(UILabel *)detailTitleLabel{
    _detailTitleLabel = detailTitleLabel;
    if (detailTitleLabel.text.length) {
        
    }
}

- (IBAction)cencelButtonClick:(UIButton *)sender {
    if (_cencelButtonBlcok) {
        _cencelButtonBlcok();
    }
}

- (IBAction)buyButtonClick:(UIButton *)sender {
    
    if (_password.length == 0) {
        if (_determineButtonBlock) {
            _determineButtonBlock(nil, @"请输入交易密码");
        }
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        return;
    }
    
    if (_password.length < 6) {
        if (_determineButtonBlock) {
            _determineButtonBlock(nil, @"请输入6位交易密码");
        }
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        return;
    }
    
    if (_password.length == 6) {
        if (_determineButtonBlock) {
            _determineButtonBlock(_password, nil);
        }
    }
}

- (void)clearText{

    [_passwordTextView clearText];
}

@end
