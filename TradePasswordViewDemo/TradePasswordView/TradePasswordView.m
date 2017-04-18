//
//  TradePasswordView.m
//  TradePasswordDemo
//
//  Created by 曾国锐 on 2016/11/22.
//  Copyright © 2016年 曾国锐. All rights reserved.
//

#define iPhone6 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 667)

#define iPhone6Plus ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 736)

#define iPhone5sORiPhone5 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 568)

#define iPhone4 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 480)


#define VIEW_WIDTH 270
// 屏幕尺寸
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
// 颜色
#define ZGRColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#import "TradePasswordView.h"
#import "PopWindowBgView.h"
#import "UIView+Extension.h"
#import "NSString+Extension.h"

@interface TradePasswordView (){
    
    /** 暗黑色的view */
    UIView *_darkView;
    
    /** 弹框背景 */
    PopWindowBgView *_bgView;
    
    /** 键盘开启状态 */
    BOOL _keyboardIsVisible;
    
    CGFloat _keyboardF;
    
}

@property (nonatomic, strong) UIWindow *backWindow;

@end

@implementation TradePasswordView

- (instancetype)initWithTitle:(NSString *)title detailTitle:(NSString *)detailTitle buyMoney:(NSString *)buyMoney isPoundage:(BOOL)isPoundage poundage:(NSString *)poundage passwordType:(ENUM_PasswordType)passwordType{
    
    if (self = [super init]) {
        
        if (iPhone4) {
            _keyboardF = 263.0f;//216
        }
        
        if (iPhone5sORiPhone5) {
            _keyboardF = 352.0f;
        }
        
        if (iPhone6) {
            _keyboardF = 451.0f;
        }
        
        if (iPhone6Plus) {
            _keyboardF = 510.0f;
        }
        
        _keyboardIsVisible = YES;
        _isPoundage = isPoundage;
        _detailTitle = detailTitle;
        // 暗黑色的view
        UIView *darkView = [[UIView alloc] init];
        [darkView setAlpha:0];
        [darkView setUserInteractionEnabled:NO];
        [darkView setFrame:(CGRect){0, 0, SCREEN_SIZE}];
        [darkView setBackgroundColor:ZGRColor(0, 0, 0, 1)];
        [self addSubview:darkView];
        _darkView = darkView;
        
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"PopWindowBgView" owner:nil options:nil];
        PopWindowBgView *bgView = [nibContents lastObject];
        bgView.backgroundColor = [UIColor whiteColor];
        
        bgView.width = VIEW_WIDTH;
        bgView.layer.cornerRadius = 5;
        bgView.layer.masksToBounds = YES;
        bgView.alpha = 0;
        bgView.detailTitleLabel.text = detailTitle;
        bgView.titleLabel.text = title;
        bgView.buyMoneyLabel.text = [NSString stringWithFormat:@"%.2f元", [buyMoney floatValue]];
        
        if (isPoundage) {
            
            bgView.titleTwoNumberLabel.text = [NSString stringWithFormat:@"%.2f元", [poundage floatValue]];
            bgView.passwordViewTopLayoutConstraint.constant = 10;
            
            switch (passwordType) {
                case ENUM_PasswordTypeTrading:
                {
                    bgView.type = ENUM_PopWindowBgTypeTrading;
                    bgView.detailTitleLabel.text = nil;
                    _detailTitle = nil;
                    bgView.height = 242;
                    bgView.center = self.backWindow.center;
                }
                    break;
                case ENUM_PasswordTypeSetting:
                {
                    CGSize size = [detailTitle sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(VIEW_WIDTH-50, MAXFLOAT)];
                    bgView.type = ENUM_PopWindowBgTypeSetting;
                    bgView.height = 252 + size.height;
                    bgView.center = self.backWindow.center;
                }
                    break;
                    
                default:
                    break;
            }
        }else{
            
            bgView.passwordViewTopLayoutConstraint.constant = 5;
            switch (passwordType) {
                case ENUM_PasswordTypeTrading:
                {
                    bgView.type = ENUM_PopWindowBgTypeTrading;
                    bgView.detailTitleLabel.text = nil;
                    _detailTitle = nil;
                    bgView.height = 220;
                    bgView.center = self.backWindow.center;
                    bgView.titleTwoNumberLabel.text = nil;
                    bgView.titleTwoLabel.text = nil;
                }
                    break;
                case ENUM_PasswordTypeSetting:
                {
                    CGSize size = [detailTitle sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(VIEW_WIDTH-50, MAXFLOAT)];
                    bgView.type = ENUM_PopWindowBgTypeSetting;
                    bgView.height = 230 + size.height;
                    bgView.center = self.backWindow.center;
                    bgView.titleTwoNumberLabel.text = nil;
                    bgView.titleTwoLabel.text = nil;
                }
                    break;
                    
                default:
                    break;
            }
        }
        
        if ((_keyboardF - bgView.height-5 - bgView.y )< 0) {
            [UIView animateWithDuration:0.3 animations:^{
                bgView.y = _keyboardF - bgView.height-5;
            }];
        }
        
        bgView.determineButtonBlock = ^(NSString *password, NSString *errorStr){
            
            if (password.length) {
                if (_confirmButtonBlcok) {
                    _confirmButtonBlcok(password, self);
                }
            }else{
                self.errorStr = errorStr;
            }
        };
        
        [bgView.passwordTextView.textField becomeFirstResponder];
        
        __weak TradePasswordView * weakSelf = self;
        
        bgView.cencelButtonBlcok = ^(){
            [weakSelf didClickCancelBtn];
        };
        [self addSubview:bgView];
        _bgView = bgView;
        
        
        [self setFrame:(CGRect){0, 0, SCREEN_SIZE}];
        [self.backWindow addSubview:self];
        
        //注册键盘出现的通知
        
        [[NSNotificationCenter defaultCenter] addObserver:self
         
                                                 selector:@selector(keyboardWasShown:)
         
                                                     name:UIKeyboardWillShowNotification object:nil];
        
        //注册键盘消失的通知
        
        [[NSNotificationCenter defaultCenter] addObserver:self
         
                                                 selector:@selector(keyboardWillBeHidden:)
         
                                                     name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)keyboardWasShown:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        // 工具条的Y值 == 键盘的Y值 - 工具条的高度
        if (keyboardF.origin.y > self.height) { // 键盘的Y值已经远远超过了控制器view的高度
            _bgView.y = self.height - _bgView.height-5;//这里的self.toolbar就是我的输入框。
            
        } else {
            
            if ((keyboardF.origin.y - _bgView.height-5 - _bgView.y )< 0) {
                _bgView.y = keyboardF.origin.y - _bgView.height-5;
            }
        }
    }];
    
    _keyboardF = keyboardF.origin.y;
    _keyboardIsVisible = YES;
}

- (void)keyboardWillBeHidden:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        // 工具条的Y值 == 键盘的Y值 - 工具条的高度
        if (keyboardF.origin.y > self.height) { // 键盘的Y值已经远远超过了控制器view的高度
            _bgView.y = self.height - _bgView.height-5;//这里的self.toolbar就是我的输入框。
            
        } else {
            _bgView.center = self.backWindow.center;
        }
    }];
    
    _keyboardF = 0;
    _keyboardIsVisible = NO;
}


- (void)shareFeedbackButtonClick{
    
    _backWindow.hidden = YES;
    
    [self removeFromSuperview];
    
}

- (UIWindow *)backWindow {
    
    if (_backWindow == nil) {
        
        _backWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backWindow.windowLevel       = UIWindowLevelStatusBar;
        _backWindow.backgroundColor   = [UIColor clearColor];
        _backWindow.hidden = NO;
    }
    
    return _backWindow;
}

- (void)didClickCancelBtn {
    
    [UIView animateWithDuration:0.3f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         [_darkView setAlpha:0];
                         [_darkView setUserInteractionEnabled:NO];
                         _bgView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         
                         _backWindow.hidden = YES;
                         
                         [self removeFromSuperview];
                         
                     }];
}

- (void)show {
    
    _backWindow.hidden = NO;
    
    [UIView animateWithDuration:0.3f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         _bgView.alpha = 1;
                         [_darkView setAlpha:0.3f];
                         [_darkView setUserInteractionEnabled:YES];
                         
                     }
                     completion:nil];
}

- (void)dismiss{
    [self didClickCancelBtn];
}

- (void)setErrorStr:(NSString *)errorStr{
    
    _errorStr = errorStr;
    [self upDataHeight];
}

- (void)upDataHeight{

    if (_keyboardIsVisible) {

        if (_isPoundage) {
            if (_errorStr.length) {
                
                CGSize size1 = [_errorStr sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(VIEW_WIDTH-50, MAXFLOAT)];
                CGSize size2 = [_detailTitle sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(VIEW_WIDTH-50, MAXFLOAT)];
                
                _bgView.errorLabel.text = _errorStr;
                if (_detailTitle.length) {
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        _bgView.height = 252 + size1.height +size2.height;
                        _bgView.y = _keyboardF - _bgView.height-5;
                    }];
                }else{
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        _bgView.height = 242 + size1.height;
                        _bgView.y = _keyboardF - _bgView.height-5;
                    }];
                }
            }
        }else{
            if (_errorStr.length) {
                
                CGSize size1 = [_errorStr sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(VIEW_WIDTH-50, MAXFLOAT)];
                CGSize size2 = [_detailTitle sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(VIEW_WIDTH-50, MAXFLOAT)];
                
                _bgView.errorLabel.text = _errorStr;
                if (_detailTitle.length) {
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        _bgView.height = 225 + size1.height +size2.height;
                        _bgView.y = _keyboardF - _bgView.height-5;
                    }];
                }else{
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        _bgView.height = 220 + size1.height;
                        _bgView.y = _keyboardF - _bgView.height-5;
                    }];
                }
            }
        }
    }else{
        if (_isPoundage) {
            if (_errorStr.length) {
                
                CGSize size1 = [_errorStr sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(VIEW_WIDTH-50, MAXFLOAT)];
                CGSize size2 = [_detailTitle sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(VIEW_WIDTH-50, MAXFLOAT)];
                
                _bgView.errorLabel.text = _errorStr;
                if (_detailTitle.length) {
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        _bgView.height = 252 + size1.height +size2.height;
                        _bgView.center = self.backWindow.center;
                    }];
                }else{
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        _bgView.height = 242 + size1.height;
                        _bgView.center = self.backWindow.center;
                    }];
                }
            }
        }else{
            if (_errorStr.length) {
                
                CGSize size1 = [_errorStr sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(VIEW_WIDTH-50, MAXFLOAT)];
                CGSize size2 = [_detailTitle sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(VIEW_WIDTH-50, MAXFLOAT)];
                
                _bgView.errorLabel.text = _errorStr;
                if (_detailTitle.length) {
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        _bgView.height = 230 + size1.height +size2.height;
                        _bgView.center = self.backWindow.center;
                    }];
                }else{
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        _bgView.height = 220 + size1.height;
                        _bgView.center = self.backWindow.center;
                    }];
                }
            }
        }
    }
}

- (void)setBuyButtonTitleStr:(NSString *)buyButtonTitleStr{

    _buyButtonTitleStr = buyButtonTitleStr;
    [_bgView.buyButton setTitle:buyButtonTitleStr forState:UIControlStateNormal];
}

- (void)setTitleOneStr:(NSString *)titleOneStr{

    _titleOneStr = titleOneStr;
    _bgView.titleOneLabel.text = [NSString stringWithFormat:@"%@：", titleOneStr];
}

- (void)clearText{

    [_bgView clearText];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
