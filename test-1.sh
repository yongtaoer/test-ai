#!/bin/bash

set -e

REPO_NAME=${PWD##*/}
GITHUB_USER=$(gh api user --jq .login)

echo "🚧 初始化 Git 仓库..."
git init
git add .
git commit -m "Initial commit"

echo "🚀 创建 GitHub 仓库 $REPO_NAME ..."
gh repo create "$REPO_NAME" --public --source=. --remote=origin --push

echo "📦 使用 gh-pages 分支发布 GitHub Pages ..."
gh repo deploy-pages --branch gh-pages --force

echo "📤 推送 gh-pages 分支"
git switch -c gh-pages
git push -u origin gh-pages

echo "🌐 获取页面访问地址..."
sleep 3
echo "✅ 你的网站将很快可访问："
echo "https://$GITHUB_USER.github.io/$REPO_NAME/"