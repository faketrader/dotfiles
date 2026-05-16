# NVM
# export NVM_DIR="$HOME/.nvm"
# export NVM_DIR="/opt/nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# # export NVM_DIR="/opt/homebrew/opt/nvm" # Homebrew Apple
# # export NVM_DIR="/usr/local/opt/nvm" # Homebrew Intel

# PNPM
alias pn=pnpm
alias pni='pnpm install'

#
# --- Node.js Version Switcher for Homebrew ---
#
# Usage:
#   nodev <version>   (e.g., "nodev 22")
#   node22            (alias for "nodev 22")
#

nodev() {
  # 检查是否提供了版本号
  if [ -z "$1" ]; then
    echo "🚨 Usage: nodev <version>"
    echo "Example: nodev 22"
    return 1
  fi

  local version=$1
  # 动态获取 Homebrew 安装前缀 (/opt/homebrew or /usr/local)
  local brew_prefix
  brew_prefix=$(brew --prefix)

  # 构造目标 Node 版本的 bin 目录路径
  local node_path="$brew_prefix/opt/node@$version/bin"

  # 检查目标版本是否已通过 Homebrew 安装
  if [ ! -d "$node_path" ]; then
    echo "❌ Error: Node.js version $version is not installed by Homebrew."
    echo "➡️ Please install it first with: brew install node@$version"
    return 1
  fi

  # 1. 从当前的 PATH 中移除所有其他 Homebrew node 版本的路径
  local new_path=""
  if [ -n "$PATH" ]; then
    # 保存并修改 IFS (Internal Field Separator) 以便用冒号分割 PATH
    local old_ifs="$IFS"
    IFS=':'
    # 遍历 PATH 中的每个目录
    for dir in $PATH; do
      # 如果目录不是一个 Homebrew node 路径，就保留它
      case "$dir" in
        *"$brew_prefix/opt/node@"*) ;; # 匹配则忽略
        *) new_path="$new_path:$dir" ;; # 不匹配则追加
      esac
    done
    IFS="$old_ifs" # 恢复 IFS
  fi

  # 2. 将新的 Node 路径添加到 PATH 的最前面
  #    `"${new_path#:}"` 用于移除可能出现在开头的多余冒号
  export PATH="$node_path${new_path#:}"

  echo "✅ Switched to Node.js v$version"
  echo " PATH: $node_path"
  echo ""
  node -v
  npm -v
}

# --- Aliases ---
# 为常用的 Node 版本创建别名
alias node24="nodev 24"
alias node16="nodev 16"
# 当 Homebrew 支持时，你可以添加更多
# alias node24="nodev 24"


# Homebrew

# node@24 is keg-only, which means it was not symlinked into /opt/homebrew,
# because this is an alternate version of another formula.

# If you need to have node@24 first in your PATH, run:
#   echo 'export PATH="/opt/homebrew/opt/node@24/bin:$PATH"' >> ~/.zshrc

# For compilers to find node@24 you may need to set:
#   export LDFLAGS="-L/opt/homebrew/opt/node@24/lib"
#   export CPPFLAGS="-I/opt/homebrew/opt/node@24/include"
