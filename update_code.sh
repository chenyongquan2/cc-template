#!/bin/bash
set -e  # 出错立即退出
set -x  # 打印执行的命令，方便调试

# 子模块目录名称，可以根据需要修改
SUBMODULE_DIR="fp-common"

# 1. 在主仓库 stash
git stash

# 2. 更新主仓库（rebase 拉取）
git pull -r

# 3. 进入子模块并 stash
if [ -d "$SUBMODULE_DIR" ]; then
  cd "$SUBMODULE_DIR"
  git stash
  cd ..
else
  echo "❌ 子模块目录 $SUBMODULE_DIR 不存在"
  exit 1
fi

# 4. 初始化/更新子模块
git submodule update --init --recursive

# 5. 在子模块中执行 stash pop
cd "$SUBMODULE_DIR"
git stash pop || true
cd ..

# 6. 在主仓库 stash pop
git stash pop || true

echo "✅ Git 操作已完成"