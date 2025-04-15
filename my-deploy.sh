#!/bin/bash

# 设置错误时退出
set -e

# 输出颜色设置
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 打印带颜色的信息函数
print_message() {
    echo -e "${GREEN}=== $1 ===${NC}"
}

print_warning() {
    echo -e "${YELLOW}WARNING: $1${NC}"
}

# 检查是否安装了 Git
if ! command -v git &> /dev/null; then
    echo "错误: Git 未安装，请先安装 Git"
    exit 1
fi

# 确保当前目录包含网站文件
if [ ! -f "index.html" ]; then
    echo "错误: 未找到 index.html 文件，请确保在正确的目录中运行此脚本"
    exit 1
fi

# 初始化新的 git 仓库（如果需要）
if [ ! -d ".git" ]; then
    print_message "初始化 Git 仓库"
    git init
fi

# 提示用户输入仓库信息
read -p "请输入 GitHub 用户名: " username
read -p "请输入仓库名称: " repo_name

# 检查远程仓库是否已配置
if ! git remote | grep -q "^origin$"; then
    print_message "配置远程仓库"
    git remote add origin "https://github.com/$username/$repo_name.git"
else
    # 更新现有的远程仓库 URL
    git remote set-url origin "https://github.com/$username/$repo_name.git"
fi

# 创建 .gitignore 文件
print_message "创建 .gitignore 文件"
cat > .gitignore << EOL
.DS_Store
node_modules/
.env
*.log
EOL

# 添加所有文件到暂存区
print_message "添加文件到 Git"
git add .

# 提交更改
print_message "提交更改"
git commit -m "Deploy to GitHub Pages"

# 创建并切换到 gh-pages 分支
print_message "创建并切换到 gh-pages 分支"
if git show-ref --verify --quiet refs/heads/gh-pages; then
    git branch -D gh-pages
fi
git checkout -b gh-pages

# 推送到 GitHub
print_message "推送到 GitHub"
git push -f origin gh-pages

# 切回主分支
git checkout main 2>/dev/null || git checkout master

# 打印部署信息
print_message "部署完成！"
echo "您的网站将在几分钟内可以通过以下地址访问："
echo "https://$username.github.io/$repo_name"

# 提供进一步的说明
print_warning "请确保在 GitHub 仓库设置中启用 GitHub Pages："
echo "1. 访问 https://github.com/$username/$repo_name/settings/pages"
echo "2. 在 'Source' 部分选择 'gh-pages' 分支"
echo "3. 点击 'Save'"

# 添加执行权限提醒
print_warning "如果脚本无法执行，请运行："
echo "chmod +x my-deploy.sh" 