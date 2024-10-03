#!/bin/bash

curl -s https://raw.githubusercontent.com/ziqing888/logo.sh/main/logo.sh | bash
sleep 3

show() {
    echo
    echo -e "\e[1;34m$1\e[0m"
    echo
}

if ! [ -x "$(command -v git)" ]; then
    show "Git 未安装，正在安装 Git..."
    sudo apt-get update && sudo apt-get install git -y
else
    show "Git 已安装。"
fi

show "正在安装 npm..."
source <(wget -O - https://raw.githubusercontent.com/ziqing888/installation/main/node.sh)

if [ -d "Story-Protocol" ]; then
    show "正在删除现有的 Story 目录..."
    rm -rf Story-Protocol
fi

show "正在克隆 Story 仓库..."
git clone https://github.com/zunxbt/Story-Protocol.git && cd Story-Protocol

show "正在安装 npm 依赖..."
npm install
echo

read -p "请输入您的钱包私钥: " WALLET
read -p "请输入 Pinata JWT 令牌: " JWT


cat <<EOF > .env
WALLET_PRIVATE_KEY=$WALLET
PINATA_JWT=$JWT
EOF


show "正在运行 npm 脚本以创建 SPG 集合..."
npm run create-spg-collection
echo

read -p "请输入 NFT 合约地址: " CONTRACT
echo

echo "NFT_CONTRACT_ADDRESS=$CONTRACT" >> .env

show "正在运行 npm 脚本以处理元数据..."
npm run metadata
echo
