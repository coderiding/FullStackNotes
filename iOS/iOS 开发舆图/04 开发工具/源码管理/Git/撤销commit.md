// 只是撤销提交，不会影响改动的代码
// 注意，仅仅是撤回commit操作，您写的代码仍然保留。
// HEAD^的意思是上一个版本，也可以写成HEAD~1
// 如果你进行了2次commit，想都撤回，可以使用HEAD~2

git reset --soft HEAD^



https://blog.csdn.net/w958796636/article/details/53611133