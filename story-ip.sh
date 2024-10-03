#!/bin/bash

# 显示自定义 Logo
curl -s https://raw.githubusercontent.com/ziqing888/logo.sh/main/logo.sh | bash
sleep 3

# 显示信息的函数
show() {
    echo
    echo -e "\e[1;34m$1\e[0m"
    echo
}

# 检查是否安装了 Git
if ! [ -x "$(command -v git)" ]; then
    show "Git 未安装，正在安装 Git..."
    sudo apt-get update && sudo apt-get install git -y || { echo "安装 Git 失败！"; exit 1; }
else
    show "Git 已经安装。"
fi

# 安装 npm
show "正在安装 npm..."
source <(wget -O - https://raw.githubusercontent.com/ziqing888/installation/main/node.sh) || { echo "npm 安装失败！"; exit 1; }

# 如果 Story-Protocol 目录存在，则删除它
if [ -d "Story-Protocol" ]; then
    show "删除现有的 Story-Protocol 目录..."
    rm -rf Story-Protocol || { echo "删除目录失败！"; exit 1; }
fi

# 克隆 Story-Protocol 仓库
show "正在克隆 Story-Protocol 仓库..."
git clone https://github.com/ziqing888/Story-Protocol.git || { echo "克隆失败！"; exit 1; }
cd Story-Protocol

# 安装 npm 依赖
show "正在安装 npm 依赖..."
npm install || { echo "npm 依赖安装失败！"; exit 1; }

# 读取用户输入的钱包私钥和 Pinata JWT
read -p "请输入您的钱包私钥: " WALLET
read -p "请输入 Pinata JWT token: " JWT

# 创建 .env 文件并写入私钥和 JWT
cat <<EOF > .env
WALLET_PRIVATE_KEY=$WALLET
PINATA_JWT=$JWT
EOF
chmod 600 .env  # 设置 .env 文件权限，确保其安全性

# 创建 SPG 集合
show "运行 npm 脚本创建 SPG 集合..."
npm run create-spg-collection || { echo "创建 SPG 集合失败！"; exit 1; }

# 获取并保存 NFT 合约地址
read -p "请输入 NFT 合约地址: " CONTRACT
echo "NFT_CONTRACT_ADDRESS=$CONTRACT" >> .env

# 运行元数据生成脚本
show "运行 npm 脚本生成元数据..."
npm run metadata || { echo "生成元数据失败！"; exit 1; }
