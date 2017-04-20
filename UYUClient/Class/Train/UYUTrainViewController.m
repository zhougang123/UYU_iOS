//
//  UYUTrainViewController.m
//  UYUClient
//
//  Created by mac on 17/4/7.
//  Copyright © 2017年 cyjjkz1. All rights reserved.
//

#import "UYUTrainViewController.h"
@interface UYUTrainViewController ()
//@property (nonatomic, strong)  *mySession;
@end

@implementation UYUTrainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(15, 40, 10, 10);
    [button addTarget:self action:@selector(connectMQTT:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
    
    
}


- (void)connectMQTT:(UIButton *)btn
{
//    MQTTCFSocketTransport *transport = [[MQTTCFSocketTransport alloc] init]; //初始化对象
//    
//    transport.host = @"localhost"; //设置MQTT服务器的地址
//    
//    transport.port = 1883; //设置MQTT服务器的端口（默认是1883，当然，你也可以和你的后台好基友协商~）
//    
//    self.mySession = [[MQTTSession alloc] init]; //初始化MQTTSession对象
//    
//    self.mySession.transport = transport; //给mySession对象设置基本信息
//    
//    self.mySession.delegate = self; //设置mySession的代理为APPDelegate，同时不要忘记遵守协议~
//    
//    [self.mySession connectAndWaitTimeout:30];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
