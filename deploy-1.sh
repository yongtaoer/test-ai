#!/bin/bash
set -e

# 检查是否安装 GitHub CLI
if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI 未安装，请先访问 https://cli.github.com 安装"
    exit 1
fi

# 验证登录状态
if ! gh auth status &> /dev/null; then
    echo "请先执行 GitHub 登录：gh auth login"
    exit 1
fi

# 获取当前目录名作为仓库名
REPO_NAME=$(basename $(pwd))

# 检查仓库是否存在
if ! gh repo view $REPO_NAME &> /dev/null; then
    echo "创建新仓库: $REPO_NAME"
    gh repo create $REPO_NAME --public --push --source .
else
    # 推送现有改动到 main 分支
    git add .
    git commit -m "Auto-commit by deployment script" || true
    git push origin main
fi

# 切换到 gh-pages 分支（如果不存在则创建）
git checkout --orphan gh-pages 2>/dev/null || git checkout gh-pages

# 清理旧文件（保留.git目录）
find . -path ./.git -prune -o -exec rm -rf {} \; 2>/dev/null

# 复制所有文件（包括隐藏文件，排除.git目录）
cp -r ../$REPO_NAME/{.,}* . 2>/dev/null || true

# 提交并强制推送
git add .
git commit -m "Auto-deploy $(date +'%Y-%m-%d %H:%M:%S')"
git push -f origin gh-pages

# 返回 main 分支
git checkout main

# 启用 GitHub Pages
gh api repos/$(gh repo view --json nameWithOwner -q .nameWithOwner)/pages \
    --method POST \
    -F build_type=workflow \
    -F source.branch=gh-pages \
    -F source.path=/ &> /dev/null || true

# 获取并显示预览地址
sleep 5  # 等待部署初始化
echo "正在获取预览地址..."
DEPLOY_URL=$(gh api repos/$(gh repo view --json nameWithOwner -q .nameWithOwner)/pages -q .html_url)
echo "部署成功！预览地址：$DEPLOY_URL"