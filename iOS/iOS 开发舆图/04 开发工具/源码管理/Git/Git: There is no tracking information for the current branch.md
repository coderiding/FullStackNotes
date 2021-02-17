Git: There is no tracking information for the current branch.

https://blog.csdn.net/sinat_36246371/article/details/79738782

在执行git pull的时候，提示当前branch没有跟踪信息：

git pull
There is no tracking information for the current branch.
Please specify which branch you want to merge with.

对于这种情况有两种解决办法，就比如说要操作master吧，一种是直接指定远程master：

git pull origin master

另外一种方法就是先指定本地master到远程的master，然后再去pull：

git branch --set-upstream-to=origin/master master
git pull

这样就不会再出现“There is no tracking information for the current branch”这样的提示了。
