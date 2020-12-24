# To avoid interference

## Step 1: Before you push your local repo

Firstly, please check the others' pull request.

### They haven't changed your new files or the changed parts are different

In this case, merge their repo into the default repo, and then pull the default repo to merge your local one. You should know that it won't change the files you have changed. Instead, it will show you

```c
branch            main       -> FETCH_HEAD
Already up to date.
```

### The parts you've changed were also changed by them

This is intriguing and should be taken care. At that time, you are supposed to back up the files you have changed, and merge their repo to the default repo. Then,

```c
git pull origin main
```

or

```c
git pull upstream main 
```

After that, you can **change whatever you want reference to your backup ones.**

## Step 2: Push

 Finally, **push your code in your sub branch.**

## Some questions

1. What if there is also without commit in others' sub branches, when the next time you push? --- Jump to step 2.
2. Can I just create a pull request to default branch? --- If you are not the repo owner, you are welcomed to do that.

简而言之，就是不要自己merge自己的branch到default branch。

Cheers,

Anthon Dave

# About Git
## Frok 之后的初始化

```c
mkdir GrdProcess # 创建GrdProcess目录
cd GrdProcess # 切换到GrdProcess目录
git init # 创建并初始化git库
git remote add origin https://github.com/Davidietop/GrdProcess.git # 添加远程git仓库
ssh-keygen -t rsa -C "your register email" # 添加SSH秘钥到git远程库，邮箱可以从git账号里查看
cat ~/.ssh/id_rsa.pub # 查看秘钥
```

 复制添加到你git账号里的ssh key列表里，就可以通过安全认证传输数据了。参考[Git如何fork别人的仓库并作为贡献者提交代码](https://www.cnblogs.com/javaIOException/p/11867988.html)。

```c
git pull origin main # 将远程git库代码下载到本地 (origin代表远程仓库，main代表主分支)
```

## 忽略不用上传的文件

请使用.gitignore文件，将你在当前文件夹不想上传的文件或子文件夹给屏蔽掉，vscode中这些文件夹会变成灰色。

## push

一般步骤：

```c
git add newfilename.type
git commit -m 'commit'
git push -u origin main
```

每次修改前，注意使用先把上游仓库合并到本地仓库。**推荐每次代码待提交前,都从原项目拉取一下最新的代码。**

```c
git remote add upstream https://github.com/beenoera/GrdProcess.git # 添加上游仓库地址
git remote -v # 查看 origin 和 upstream 对应的仓库是否正确
git pull upstream main # 从上游仓库获取最新的代码合并到自己本地仓库的main分支上
git push -u origin main
```

注意一般不要用

```c
 git push --force
```

## 关于增删文件名
**删除文件名**

```C
git rm file1.txt
git commit -m "remove file1.txt"
```

增加文件直接加就好了，然后也是commit

# GrdProcess

The repo is grinding process kinematic simulation in MATLAB.