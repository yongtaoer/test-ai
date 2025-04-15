#!/bin/bash

set -e

# 获取当前目录名作为仓库名
REPO_NAME=${PWD##*/}
# 获取当前 GitHub 用户名
GITHUB_USER=$(gh api user --jq .login)

echo "🚧 初始化 Git 仓库..."
git init
git add .
git commit -m "Initial commit"

echo "🚀 创建 GitHub 仓库 $REPO_NAME ..."
gh repo create "$REPO_NAME" --public --source=. --remote=origin --push

echo "📦 创建并切换到 gh-pages 分支"
git checkout -b gh-pages
git push -u origin gh-pages

echo "⚙️ 设置 GitHub Pages 使用 gh-pages 分支"
gh api -X PUT "repos/$GITHUB_USER/$REPO_NAME/pages" \
  -f source.branch='gh-pages' \
  -f source.path='/'

echo "🌐 获取页面 URL..."
sleep 3
PAGE_URL=$(gh api "repos/$GITHUB_USER/$REPO_NAME/pages" --jq .html_url)

echo "✅ 部署成功！你可以通过以下地址访问："
echo "$PAGE_URL"