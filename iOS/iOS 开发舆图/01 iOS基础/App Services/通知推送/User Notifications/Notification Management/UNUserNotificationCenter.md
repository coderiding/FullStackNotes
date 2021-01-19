```objectivec
func scheduleNotification(notificationType: String) {
    let notificationCenter = UNUserNotificationCenter.current()

    let content = UNMutableNotificationContent() // Содержимое уведомления
    let userActions = "User Actions"

    content.title = "蓝牙打印机已断开"
    content.body = ""
    content.sound = UNNotificationSound.default
    content.badge = 1
    content.categoryIdentifier = userActions

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
    let identifier = "bleDisconnect"
    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

    notificationCenter.add(request) { (error) in
        if let error = error {
            print("Error \(error.localizedDescription)")
        }
    }

    let snoozeAction = UNNotificationAction(identifier: "reConnect", title: "重新连接", options: [])
    let deleteAction = UNNotificationAction(identifier: "Delete", title: "Delete", options: [.destructive])
    let category = UNNotificationCategory(identifier: userActions, actions: [snoozeAction, deleteAction], intentIdentifiers: [], options: [])

    notificationCenter.setNotificationCategories([category])
}

#pragma mark - 创建一条本地通知
- (void)createOneLocalNotification{
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"标题";
    content.subtitle = @"副标题";
    content.body = @"这里是通知内容";
    content.badge = @0;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"image1" ofType:@"png"];
    NSError *error = nil;
    UNNotificationAttachment *img_attachment = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
    content.attachments = @[img_attachment];
    //设置为@""以后，进入app将没有启动页
    content.launchImageName = @"";
    //收到通知时候的声音文件名(音频文件必须在bundle中或者在Library/Sounds目录下)
    UNNotificationSound *sound = [UNNotificationSound soundNamed:@"sound.wav"];
    content.sound = sound;
    //一秒后收到通知，并且不重复
    UNTimeIntervalNotificationTrigger *time_trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    NSString *requestIdentifer = @"requestIdentifer";
    content.categoryIdentifier = @"category1";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:time_trigger];

    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"%@",error);
    }];
}
```