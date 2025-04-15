#!/bin/bash

set -e

# 获取当前目录名作为仓库名
REPO_NAME=${PWD##*/}
GITHUB_USER=$(gh api user --jq .login)

echo "📁 当前项目目录：$REPO_NAME"
echo "👤 当前 GitHub 用户：$GITHUB_USER"

echo "🔧 初始化 Git 仓库..."
git init
git add .
git commit -m "Initial commit"

echo "🚀 创建远程仓库并推送 main 分支..."
gh repo create "$REPO_NAME" --public --source=. --remote=origin --push

echo "🛠️ 设置 GitHub Pages 发布源为 main 分支根目录..."
gh api -X PATCH "repos/$GITHUB_USER/$REPO_NAME" -f has_pages=true
gh api -X PUT "repos/$GITHUB_USER/$REPO_NAME/pages" \
  -f source.branch="main" \
  -f source.path="/"

echo "🌍 获取 GitHub Pages URL..."
sleep 5
PAGE_URL=$(gh api "repos/$GITHUB_USER/$REPO_NAME/pages" --jq '.html_url')

echo "✅ 部署成功！你可以通过以下地址访问你的站点："
echo "$PAGE_URL"