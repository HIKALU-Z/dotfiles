# Dotfiles

个人配置文件集合，使用 Git 进行版本控制，通过符号链接管理。

## 📁 包含的配置

| 工具 | 配置路径 | 原配置位置 |
|------|----------|------------|
| [WezTerm](https://wezfurlong.org/wezterm/) | `wezterm/` | `~/.config/wezterm` |
| [Neovim](https://neovim.io/) (LazyVim) | `nvim/` | `~/.config/nvim` 或 `~/AppData/Local/nvim` |
| [Nushell](https://www.nushell.sh/) | `nushell/` | `~/.config/nushell` 或 `~/AppData/Roaming/nushell` |
| [Starship](https://starship.rs/) | `starship/` | `~/.config/starship.toml` |

## 🚀 快速开始

### 首次安装（Windows）

#### 方式一：使用安装脚本（推荐）

```powershell
# 1. 克隆仓库
git clone git@github.com:HIKALU-Z/dotfiles.git $env:USERPROFILE\dotfiles
cd $env:USERPROFILE\dotfiles

# 2. 运行安装脚本（建议以管理员身份运行）
.\install.ps1
```

#### 方式二：手动创建符号链接

```powershell
# WezTerm
New-Item -ItemType SymbolicLink -Path "~\.config\wezterm" -Target "$env:USERPROFILE\dotfiles\wezterm"

# Neovim
New-Item -ItemType SymbolicLink -Path "~\AppData\Local\nvim" -Target "$env:USERPROFILE\dotfiles\nvim"

# Nushell
New-Item -ItemType SymbolicLink -Path "~\AppData\Roaming\nushell" -Target "$env:USERPROFILE\dotfiles\nushell"

# Starship
New-Item -ItemType SymbolicLink -Path "~\.config\starship.toml" -Target "$env:USERPROFILE\dotfiles\starship\starship.toml"
```

### 更新配置

```powershell
cd e:\playground\dotfiles
git add .
git commit -m "Update configs"
git push
```

## 📂 目录结构

```
dotfiles/
├── .backup/                    # 配置备份目录
│   ├── wezterm_YYYYMMDD_HHMMSS/
│   ├── nvim_YYYYMMDD_HHMMSS/
│   ├── nushell_YYYYMMDD_HHMMSS/
│   └── starship_YYYYMMDD_HHMMSS/
├── wezterm/                    # WezTerm 终端配置
│   ├── wezterm.lua            # 主配置文件
│   ├── config/                # 配置模块
│   ├── colors/                # 主题颜色
│   └── ...
├── nvim/                       # Neovim (LazyVim) 配置
│   ├── init.lua               # 入口文件
│   ├── lua/
│   │   ├── config/            # 核心配置
│   │   └── plugins/           # 插件配置
│   └── ...
├── nushell/                    # Nushell 配置
│   ├── config.nu              # 主配置
│   ├── env.nu                 # 环境变量
│   └── ...
├── starship/                   # Starship 提示符配置
│   ├── starship.toml          # 默认主题
│   ├── starship-dracula.toml  # Dracula 主题
│   ├── starship-gruvbox.toml  # Gruvbox 主题
│   └── starship-agnoest.toml  # Agnoest 主题
├── install.ps1                # Windows 自动安装脚本
├── .gitignore                 # Git 忽略文件
└── README.md                  # 本文件
```

## 🔧 各工具说明

### WezTerm
- 跨平台 GPU 加速终端
- 配置使用 Lua 语言
- 支持多标签、多窗口、自定义主题

### Neovim (LazyVim)
- 基于 Neovim 的现代化 IDE 配置
- 使用 Lazy.nvim 作为插件管理器
- 预配置 LSP、代码补全、文件树等

### Nushell
- 现代化 shell，使用结构化数据
- 配置使用 Nu 语言
- 支持管道操作表格数据

### Starship
- 跨 shell 的极简提示符
- 支持多种语言和工具的状态显示
- 可切换不同主题配置

## 📝 常用操作

### 切换 Starship 主题

```powershell
# 临时切换（当前会话）
$ENV:STARSHIP_CONFIG = "e:\playground\dotfiles\starship\starship-dracula.toml"

# 永久切换（添加到 shell 配置文件）
# 在 Nushell 的 env.nu 中添加：
$env.STARSHIP_CONFIG = "e:\playground\dotfiles\starship\starship-dracula.toml"
```

### 备份当前配置

```powershell
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
Copy-Item -Path "~\.config\wezterm" -Destination "e:\playground\dotfiles\.backup\wezterm_$timestamp" -Recurse
```

### 恢复备份

```powershell
# 删除当前配置
Remove-Item -Path "~\.config\wezterm" -Recurse -Force

# 从备份恢复
Copy-Item -Path "e:\playground\dotfiles\.backup\wezterm_YYYYMMDD_HHMMSS" -Destination "~\.config\wezterm" -Recurse
```

## ⚠️ 注意事项

1. **符号链接权限**：Windows 上创建符号链接可能需要管理员权限，或开启开发者模式
2. **配置冲突**：确保原配置目录已备份并删除，再创建符号链接
3. **路径问题**：不同工具在不同操作系统上的配置路径可能不同，请参考各工具官方文档

## 🔗 相关链接

- [WezTerm 文档](https://wezfurlong.org/wezterm/)
- [LazyVim 文档](https://www.lazyvim.org/)
- [Nushell 文档](https://www.nushell.sh/book/)
- [Starship 文档](https://starship.rs/guide/)

## 📄 License

MIT License - 自由使用和修改
