# Mac重装教程

## **安装cocoapods**



```
sudo gem update --system
gem sources --remove https://rubygems.org/
gem sources -a https://gems.ruby-china.com/
sudo gem install cocoapods -n /usr/local/bin
gem sources -l
pod setup
//需要翻墙
```

## 安装hexo

1.确保安装了homebrew



```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" 
```

```
brew install node 
```

3.重装hexo命令{这里是重新生成，如果之前有这个文件件，建议也重新安装，不然会出现很多奇怪的问题，估计是hexo版本不兼容，或者某些配置环境不兼容}



```
npm install hexo-cli -g  
hexo init blog  
cd blog  
npm install  
hexo server 
```

## **安装xcodetool**



```
xcode-select --install
```

## **安装fastlane**



```
sudo gem install fastlane -n /usr/local/bin
fastlane add_plugin pgyer 
```

## **过滤cornerstone**



```
,.git,*.git,fastlane,git,Pods,Reveal,Reveal.framework,Gemfile,Gemfile.lock,Podfile.lock
```