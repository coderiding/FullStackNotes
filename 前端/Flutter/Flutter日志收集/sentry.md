```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

target 'YourApp' do
  pod 'Sentry', :git => 'https://github.com/getsentry/sentry-cocoa.git', :tag => '4.5.0'
end






import Sentry

func application(_ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    // Create a Sentry client and start crash handler
    do {
        Client.shared = try Client(dsn: "https://examplePublicKey@o0.ingest.sentry.io/0")
        try Client.shared?.startCrashHandler()
    } catch let error {
        print("\(error)")
    }

    return true
}





@import Sentry;

NSError *error = nil;
SentryClient *client = [[SentryClient alloc] initWithDsn:@"https://examplePublicKey@o0.ingest.sentry.io/0" didFailWithError:&error];
SentryClient.sharedClient = client;
[SentryClient.sharedClient startCrashHandlerWithError:&error];
if (nil != error) {
    NSLog(@"%@", error);
}



Client.shared?.crash()

```

https://docs.sentry.io/clients/cocoa/