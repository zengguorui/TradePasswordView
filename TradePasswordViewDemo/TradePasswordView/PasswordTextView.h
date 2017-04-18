//
//  PasswordTextView.h
//  EAGLE
//
//  Created by 曾国锐 on 2016/11/23.
//  Copyright © 2016年 axingg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordTextView : UIView

@property (nonatomic, copy) void(^passwordBlock)(NSString *password);
@property (nonatomic, assign) NSUInteger elementCount;
@property (nonatomic, strong) UIColor *elementColor;
@property (nonatomic, assign) NSUInteger elementMargin;
@property(nonatomic, weak) UITextField *textField;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign)BOOL secureTextEntry;

- (void)clearText;


@end
