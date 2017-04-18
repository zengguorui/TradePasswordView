//
//  ViewController.m
//  TradePasswordViewDemo
//
//  Created by 曾国锐 on 2017/4/14.
//  Copyright © 2017年 曾国锐. All rights reserved.
//

#import "ViewController.h"
#import "TradePasswordView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *switchOne;//手续费
@property (weak, nonatomic) IBOutlet UISwitch *switchTwo;
@property (weak, nonatomic) IBOutlet UISwitch *switchThree;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)buttonClick:(id)sender {
    
    TradePasswordView *tradePasswordView = [[TradePasswordView alloc] initWithTitle:@"标题" detailTitle:@"设置交易密码" buyMoney:@"100" isPoundage:self.switchOne.on poundage:@"2" passwordType:self.switchTwo.on?ENUM_PasswordTypeTrading:ENUM_PasswordTypeSetting];
    [tradePasswordView show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
