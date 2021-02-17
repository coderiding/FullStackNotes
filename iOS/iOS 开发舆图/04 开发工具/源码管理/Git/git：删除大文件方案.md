# git：删除大文件方案

* https://gitee.com/help/articles/4232#article-header2
* https://rtyley.github.io/bfg-repo-cleaner/
* https://git-scm.com/docs/git-filter-branch
* https://github.com/newren/git-filter-repo
* https://www.baidu.com/s?ie=utf-8&f=8&rsv_bp=1&ch=&tn=91614996_hao_pg&bar=&wd=BFG+Repo-Cleaner+%E4%BD%BF%E7%94%A8&oq=%25E5%2588%25A0%25E9%2599%25A4%25E6%259F%2590%25E4%25B8%25AAcommit%25E7%2589%2588%25E6%259C%25AC&rsv_pq=b5d4e03b00003cdb&rsv_t=a194q1p57q3UKhWcwjVGCtdX6fEqZp%2Bp6VrQvn3SP2%2BmkM2wVp%2Fz8f67FjMJm%2Br%2FJ2trshMA&rqlang=cn&rsv_enter=1&rsv_dl=tb&inputT=2401
* https://www.cnblogs.com/imzhizi/p/delete-files-thoroughly-using-bfg.html
* https://www.jianshu.com/p/60ed9f5e2c05

* 首先需要自行从项目中删除不想要的文件并提交, 这样能最大程度避免误删、误操作.
* 最近开发中有一个需求，就是让我从一个仓库clone代码下来，然后提交到另一个仓库，需求确实不算难，理想情况：从一个地址clone下来，然后push到另一个地址，结束。现实：↗↘↗↘↘↗
在往另一个仓库push的时候，发现另一个仓库的服务器不支持这么大的文件(500多M)的库上传。
所以我在询问过负责人之后，告诉我可以把附件删除，只保留代码即可，但是手动删除之后，仓库还是那么大，因为在仓库的历史中还是有这些附件的记录的，所以就需要把这些附件从历史中进行删除。
* https://www.jianshu.com/p/60ed9f5e2c05
* https://rtyley.github.io/bfg-repo-cleaner/
* https://www.cnblogs.com/imzhizi/p/delete-files-thoroughly-using-bfg.html

## 首先需要自行从项目中删除不想要的文件
```
rm file-to-delete
```

## 提交改动, 即最新分支是不包含要被删除的文件
```
git commit -m "删除 file-to-delete"
git push
然后使用 --mirror 命令裸克隆(clone)整个项目.

Copy
git clone --mirror git@github.com:username/some-project.git
```

## 根据经验, 如果是包含大文件的项目, 使用 ssh 将会克隆的非常缓慢, 可以改用 https
```
git clone --mirror https://github.com/username/some-project.git
```

## 这个时候, 你的当前目录下就会产生一个名为 some-project.git 的文件夹
```
接着开始删除文件历史.

Copy
```

## 根据情况的不同, bfg 可选择根据文件大小删除
```
java -jar bfg.jar --strip-blobs-bigger-than 100M some-project.git
```

## 根据情况的不同, bfg 可选择直接根据名字删除
```
java -jar bfg.jar --delete-files name-of-file  some-project.git
任选以上命令执行其中一个后, 执行 git gc 真正删除这些文件并提交.

Copy
cd some-project.git
git reflog expire --expire=now --all && git gc --prune=now --aggressive
git push
```