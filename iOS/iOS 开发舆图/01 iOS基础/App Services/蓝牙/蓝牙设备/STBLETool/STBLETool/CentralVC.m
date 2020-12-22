//
//  CentralVC.m
//  STBLETool
//
//  Created by TangJR on 3/16/16.
//  Copyright © 2016 tangjr. All rights reserved.
//

#import "CentralVC.h"
#import "STCentralTool.h"

@interface CentralVC () <STCentralToolDelegate, STCentralToolOTADelegate>

@property (strong, nonatomic) STCentralTool *tool;

@end

@implementation CentralVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tool = [STCentralTool shareInstence];
    self.tool.delegate = self;
}

#pragma mark - Button Tapped

- (IBAction)startScanButtonTapped:(UIButton *)sender {
    [self.tool startScan];
}

- (IBAction)sendDataButtonTapped:(UIButton *)sender {
    NSData *data = [NSData new];
    [self.tool otaUpdateData:data toCharacteristic:self.tool.writeCharacteristic];
}

#pragma mark - STCentralToolDelegate

- (void)centralTool:(STCentralTool *)centralTool findPeripherals:(NSArray *)peripherals {
    NSLog(@"%@", peripherals);
    [self.tool selectPeripheral:[peripherals firstObject]];
}

- (void)centralTool:(STCentralTool *)centralTool connectFailure:(NSError *)error {
    NSLog(@"连接错误 ---- %@", error);
}

- (void)centralTool:(STCentralTool *)centralTool connectSuccess:(CBPeripheral *)peripheral {
    NSLog(@"连接成功 ---- %@", peripheral);
}

- (void)centralTool:(STCentralTool *)centralTool disconnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"准备断开连接");
}

- (void)centralTool:(STCentralTool *)centralTool recievedData:(NSData *)data {
    NSLog(@"收到数据 ---- %@", data);
}

#pragma mark - STCentralToolOTADelegate

- (void)centralTool:(STCentralTool *)centralTool otaWriteFinishWithError:(NSError *)error {
    NSLog(@"传输完成，有错吗  ----- %@", error);
}

- (void)centralTool:(STCentralTool *)centralTool otaWriteLength:(NSInteger)length {
    NSLog(@"已经传了这么长了啊 ------  %ld", length);
}

@end