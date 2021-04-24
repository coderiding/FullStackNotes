//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"

#if __has_include(<flutter_webview_plugin/FlutterWebviewPlugin.h>)
#import <flutter_webview_plugin/FlutterWebviewPlugin.h>
#else
@import flutter_webview_plugin;
#endif

#if __has_include(<fluttertoast/FluttertoastPlugin.h>)
#import <fluttertoast/FluttertoastPlugin.h>
#else
@import fluttertoast;
#endif

#if __has_include(<path_provider/FLTPathProviderPlugin.h>)
#import <path_provider/FLTPathProviderPlugin.h>
#else
@import path_provider;
#endif

#if __has_include(<shared_preferences/SharedPreferencesPlugin.h>)
#import <shared_preferences/SharedPreferencesPlugin.h>
#else
@import shared_preferences;
#endif

#if __has_include(<sqflite/SqflitePlugin.h>)
#import <sqflite/SqflitePlugin.h>
#else
@import sqflite;
#endif

#if __has_include(<video_player/VideoPlayerPlugin.h>)
#import <video_player/VideoPlayerPlugin.h>
#else
@import video_player;
#endif

#if __has_include(<webview_flutter/WebViewFlutterPlugin.h>)
#import <webview_flutter/WebViewFlutterPlugin.h>
#else
@import webview_flutter;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [FlutterWebviewPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterWebviewPlugin"]];
  [FluttertoastPlugin registerWithRegistrar:[registry registrarForPlugin:@"FluttertoastPlugin"]];
  [FLTPathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTPathProviderPlugin"]];
  [FLTSharedPreferencesPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTSharedPreferencesPlugin"]];
  [SqflitePlugin registerWithRegistrar:[registry registrarForPlugin:@"SqflitePlugin"]];
  [FLTVideoPlayerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTVideoPlayerPlugin"]];
  [FLTWebViewFlutterPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTWebViewFlutterPlugin"]];
}

@end
