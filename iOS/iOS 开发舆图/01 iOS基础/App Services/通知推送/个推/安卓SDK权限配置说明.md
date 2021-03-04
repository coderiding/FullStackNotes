https://docs.getui.com/getui/question/sdk/


1. 网络连接（必选）
用于网络连接

    <uses-permission android:name="android.permission.INTERNET”/>
复制
2. 读取手机状态和身份（必选）
获取手机状态参数，并作为生成个推唯一标识的必要参数

   <uses-permission android:name="android.permission.READ_PHONE_STATE”/>
复制
3. 获取网络状态（必选）
查看网络状态，sdk重连机制等需要使用

    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE”/>
复制
4.查看wifi连接状态（必选）
用于在 sdk 与服务器通讯的时候检查网络状态

    <uses-permission android:name="android.permission.ACCESS_WIFI_STATE”/>
复制
5.开机自启动（必选）
开机自启动权限，提升sdk活跃，保障触达

    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED”/>
复制
6.写sd卡权限（必选）
日志相关功能

    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE”/>
复制
7.震动权限（必选）
使用通知功能必选

    <uses-permission android:name="android.permission.VIBRATE”/>
复制
8.获取最近活跃任务权限（必选）
获取任务信息，目的是防止sdk被频繁唤醒

    <uses-permission android:name="android.permission.GET_TASKS”/>
复制
9.位置及蓝牙权限（可选）
支持个推3.0 电子围栏功能

    <uses-permission android:name="android.permission.BLUETOOTH"/>
    <uses-permission android:name="android.permission.BLUETOOTH_ADMIN"/>
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION”/>
    <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
复制
10.自定义权限（可选）
防止小部分手机服务没法正常工作

    <uses-permission android:name="getui.permission.GetuiService.${applicationId}"/>

    <permission
        android:name="getui.permission.GetuiService.${applicationId}"
        android:protectionLevel="normal"/>