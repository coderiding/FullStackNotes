git config --global http.proxy
查询到当前设置了代理，所以我取消这个设置：
git config --global --unset http.proxy
再查询，已经没有了代理，然后再push,成功了！