




- 手机打开http://chls.pro/ssl
- 一定要在wifi下打开这个网址，并使用charles为代理
- [https://www.charlesproxy.com/documentation/using-charles/ssl-certificates/](https://www.charlesproxy.com/documentation/using-charles/ssl-certificates/)

> iOS devices
Set your iOS device to use Charles as its HTTP proxy in the Settings app > Wifi settings. 将手机的代理设置为电脑charles的地址，然后打开下面的网址
Open Safari and browse to https://chls.pro/ssl. Safari will prompt you to install the SSL certificate.
If you are on iOS 10.3 or later, open the Settings.app and navigate to General > About > Certificate Trust Settings, and find the Charles Proxy certificate, and switch it on to enable full trust for it (More information about this change in iOS 10). 到通用->关于->证书信任
Now you should be able to access SSL websites with Charles using SSL Proxying

## 注意：20190519
最后还要到手机设置-关于本机-设置信任证书

最后还要到手机设置-关于本机-设置信任证书