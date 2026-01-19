#!/bin/bash
# Mosaic 日志系统测试运行脚本

set -e  # 遇到错误立即退出

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🧪 Mosaic 日志系统单元测试"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 检查 Python 版本
echo "🔍 检查 Python 版本..."
python_version=$(python3 --version 2>&1 | awk '{print $2}')
echo "✅ Python $python_version"
echo ""

# 检查依赖
echo "🔍 检查依赖..."
if python3 -c "import yaml" 2>/dev/null; then
    echo "✅ PyYAML 已安装"
else
    echo "❌ PyYAML 未安装"
    echo "📦 正在安装 PyYAML..."
    pip3 install pyyaml
fi
echo ""

# 运行测试
echo "🚀 运行测试..."
echo ""

# 检查是否安装了 pytest
if command -v pytest &> /dev/null; then
    echo "使用 pytest 运行测试（推荐）"
    pytest test_analyze_logs.py -v --tb=short
else
    echo "使用 unittest 运行测试"
    python3 test_analyze_logs.py
fi

# 测试结果
if [ $? -eq 0 ]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✅ 所有测试通过！"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
else
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "❌ 测试失败，请查看上方错误信息"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    exit 1
fi
