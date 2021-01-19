```objectivec
- (NSSet *)createNotificationCategoryActions{
    //定义通知交互按钮(最好不要超过4个)
    UNNotificationAction *action1 = [UNNotificationAction actionWithIdentifier:@"action1" title:@"操作一" options:UNNotificationActionOptionDestructive|UNNotificationActionOptionForeground];
    UNNotificationAction *action2 = [UNNotificationAction actionWithIdentifier:@"action2" title:@"操作二" options:UNNotificationActionOptionDestructive|UNNotificationActionOptionForeground];
    UNNotificationAction *action3 = [UNNotificationAction actionWithIdentifier:@"action3" title:@"操作三" options:UNNotificationActionOptionDestructive|UNNotificationActionOptionForeground];

    //定义文本框的action
    UNTextInputNotificationAction *inputAction = [UNTextInputNotificationAction actionWithIdentifier:@"text" title:@"输入框" options:UNNotificationActionOptionAuthenticationRequired|UNNotificationActionOptionDestructive|UNNotificationActionOptionForeground];

    //将这些action带入category
    UNNotificationCategory *category1 = [UNNotificationCategory categoryWithIdentifier:@"category1" actions:@[action1,action2,action3] intentIdentifiers:@[@"action1",@"action2",@"action3"] options:UNNotificationCategoryOptionNone];

    UNNotificationCategory *category2 = [UNNotificationCategory categoryWithIdentifier:@"category2" actions:@[inputAction] intentIdentifiers:@[@"text"] options:UNNotificationCategoryOptionNone];

    return [NSSet setWithObjects:category1,category2,nil];
}

//用户与通知进行交互后的response，比如说用户直接点开通知打开App、用户点击通知的按钮或者进行输入文本框的文本
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    NSLog(@"与用户交互完成处理交互结果");
    /*
    UNNotificationRequest *request = response.notification.request; // 原始请求
    NSDictionary *userInfo = request.content.userInfo;// userInfo数据
    UNNotificationContent *content = request.content; // 原始内容
    NSString *title = content.title;  // 标题
    NSString *subtitle = content.subtitle;  // 副标题
    NSNumber *badge = content.badge;  // 角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;
     */
    //在此，可判断response的种类和request的触发器是什么，可根据远程通知和本地通知分别处理，再根据action进行后续回调
    //可根据actionIdentifier来做业务逻辑
    if ([response isKindOfClass:[UNTextInputNotificationResponse class]]) {
        //输入框action的处理
        UNTextInputNotificationResponse *textResponse = (UNTextInputNotificationResponse *)response;
        NSString *text = textResponse.userText;
        //do something
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"文本框输入" message:text preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    } else{
        if ([response.actionIdentifier isEqualToString:@"action1"]) {
            NSLog(@"操作一");
        }
        if ([response.actionIdentifier isEqualToString:@"action2"]) {
            NSLog(@"操作二");
        }
        if ([response.actionIdentifier isEqualToString:@"action3"]) {
            NSLog(@"操作三");
        }

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:response.actionIdentifier message:response.notification.request.content.body preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }
    completionHandler();
}

func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

    if response is UNTextInputNotificationResponse {
        //输入框action的处理
        let textResponse = response as? UNTextInputNotificationResponse
        let text = textResponse?.userText
        //do something
        let alert = UIAlertController(title: "文本框输入", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
        window.rootViewController?.present(alert, animated: true)
    } else {
        if response.actionIdentifier == "action1" {
            print("操作一")
        }
        if response.actionIdentifier == "action2" {
            print("操作二”)
        }

        let alert = UIAlertController(title: response.actionIdentifier, message: response.notification.request.content.body, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
    }
    completionHandler()
}
```