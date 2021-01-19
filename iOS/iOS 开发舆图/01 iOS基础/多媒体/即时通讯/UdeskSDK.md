```objectivec
#import <UdeskSDK/Udesk.h>

--------配置
- (void)setupUdeskSdk:(lw_mode_LoginData *)mode {
    UdeskOrganization *organization = [[UdeskOrganization alloc] initWithDomain:@"51bangbang.udesk.cn" appKey:@"96c791bc728dc266628da8ea351d4e09" appId:@"ee28381694ccfdac"];
    UdeskCustomer *customer = [UdeskCustomer new];
    customer.sdkToken = mode.mobile;
    customer.nickName = [mode.nickname stringByAppendingString:mode.mobile];
    customer.cellphone = mode.mobile;
    [UdeskManager initWithOrganization:organization customer:customer];
}

-----------跳转
     UdeskSDKStyle *sdkStyle = [UdeskSDKStyle customStyle];
     sdkStyle.customerImageURL = [MXDataHelper shareInstance].userData.chat_link;
     UdeskSDKConfig *c = [[UdeskSDKConfig alloc] init];
     c.quitQueueType = UDQuitQueueTypeForce;
     UdeskSDKManager *chat = [[UdeskSDKManager alloc] initWithSDKStyle:sdkStyle sdkConfig:c];
     
     UdeskSDKStyle *deskStyle = [UdeskSDKStyle customStyle];
     deskStyle.navigationColor = NavigationBarColor;
     deskStyle.titleColor = [UIColor whiteColor];
     deskStyle.navBackButtonColor = [UIColor whiteColor];
     deskStyle.navBackButtonImage = [UIImage imageNamed:@"mx_nav_back_white"];
     [chat initWithSDKStyle:deskStyle];
     [chat pushUdeskInViewController:self.navigationController completion:nil];

- (void)applicationDidEnterBackground:(UIApplication *)application {
    //设置离线，客服发送离线消息
    [UdeskManager setupCustomerOffline];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    //上线操作，拉取离线消息
    //[self setupGeTui];
    [UdeskManager setupCustomerOnline];
}
```