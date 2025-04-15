#!/bin/bash

# === 配置区域 ===
REPO_NAME="my-static-site"           # 仓库名
GITHUB_USER="yongtaoer"              # 你的 GitHub 用户名
DEPLOY_BRANCH="gh-pages"             # 部署分支（GitHub Pages 默认分支）
COMMIT_MSG="deploy static site"

# === 初始化 Git 仓库（如果还没有） ===
git init
git add .
git commit -m "$COMMIT_MSG"

# === 创建远程仓库（如果还没有） ===
gh repo create "$REPO_NAME" --public --source=. --remote=origin --push || echo "远程仓库已存在，跳过创建"

# === 切换到部署分支并提交 ===
git checkout -b $DEPLOY_BRANCH
git add .
git commit -m "$COMMIT_MSG"
git push origin $DEPLOY_BRANCH --force

# === 设置 GitHub Pages 发布配置 ===
gh api -X PATCH "repos/$GITHUB_USER/$REPO_NAME" \
  -f name="$REPO_NAME" \
  -f has_pages=true \
  -f pages.branch="$DEPLOY_BRANCH" \
  -f pages.path="/"

# === 显示访问地址 ===
echo ""
echo "✅ 部署完成！你可以访问："
echo "👉 https://$GITHUB_USER.github.io/$REPO_NAME/"