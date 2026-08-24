#!/bin/bash
{
echo "=== 开始验证 $(date -u +%FT%TZ) ==="
echo "=== 架构 ==="
uname -m
echo "=== node版本 ==="
node -v 2>&1
echo "=== npm版本 ==="
npm -v 2>&1
echo "=== 安装 @alipay/agent-payment@1.0.20 ==="
npm install -g @alipay/agent-payment@1.0.20 2>&1 | tail -3
echo "=== CLI路径 ==="
CLI_PATH=$(npm root -g)/@alipay/agent-payment
echo "CLI_PATH=$CLI_PATH"
echo "=== native目录内容 ==="
ls -la $CLI_PATH/dist/native/ 2>&1
echo "=== 加载blueshield.node ==="
node -e "const p=require(process.argv[1]); console.log('BlueShield加载成功, 导出键:', Object.keys(p).join(','))" $CLI_PATH/dist/native/blueshield.node 2>&1
echo "=== 加载apguard.node ==="
node -e "const p=require(process.argv[1]); console.log('ApGuard加载成功, 导出键:', Object.keys(p).join(','))" $CLI_PATH/dist/native/apguard.node 2>&1
echo "=== alipay-bot check-wallet ==="
timeout 30 alipay-bot check-wallet 2>&1 | head -25
echo "=== 验证结束 $(date -u +%FT%TZ) ==="
} > /workspaces/OperitForge/verify_result.log 2>&1
cd /workspaces/OperitForge
git config user.email "ling@lynx-t.local"
git config user.name "ling"
git add verify_result.log
git commit -m "alipay verify result" --quiet
git push origin main --quiet 2>&1
echo "PUSH_DONE"
