#!/bin/bash

# 需要设置的 GitHub 仓库名和分支
REPO_NAME="your-repository-name" # 修改为你的 GitHub 仓库名
BRANCH_NAME="main" # 如果你的主分支是 master 请改成 master
GH_USERNAME="your-github-username" # 修改为你的 GitHub 用户名

# 检查 GitHub CLI 是否安装
if ! command -v gh &> /dev/null
then
    echo "GitHub CLI (gh) 未安装，请安装它以继续"
    exit 1
fi

# 检查是否已经在当前目录下初始化 git 仓库
if [ ! -d ".git" ]; then
    echo "未检测到 git 仓库，正在初始化..."
    git init
    git add .
    git commit -m "initial commit"
fi

# 设置远程仓库
git remote set-url origin https://github.com/$GH_USERNAME/$REPO_NAME.git

# 提交代码并推送到 GitHub 仓库
git add .
git commit -m "Automated deployment"
git push -u origin $BRANCH_NAME

# 启用 GitHub Pages（设置 GitHub Pages 目标分支）
echo "正在启用 GitHub Pages..."

# 如果已经启用了 GitHub Pages，则不会更改
gh repo edit --enable-pages --source main

# 获取 GitHub Pages 地址
echo "GitHub Pages 地址:"
echo "https://$GH_USERNAME.github.io/$REPO_NAME/"

# 完成
echo "部署完成！你可以在上面的链接查看项目的预览。"
