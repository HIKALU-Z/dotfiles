# config.nu
#
# Installed by:
# version = "0.110.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings, 
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R


# 1. 加载 Oh My Posh，指定主题（替换为你喜欢的主题名）
# oh-my-posh init nu --config "C://Users//DQ00658//.config//wezterm//posh-themes//hikalu.omp.json" | save -f ~/.config/wezterm/oh-my-posh.nu
# oh-my-posh init nu
source ~/.oh-my-posh.nu

# 2. 可选：启用 UTF-8 编码，避免图标乱码
$env.UTF-8 = 1

# 3. 可选：禁用 OSC 133 命令以防止某些终端问题
$env.config.shell_integration.osc133 = false


# 4. 加载 Starship 配置
# mkdir ($nu.data-dir | path join "vendor/autoload")
# starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")


# 5. 关闭 Nushell 启动 banner（欢迎信息/版本信息）
$env.config.show_banner = false


# nvim
alias vi = nvim
alias vim = nvim

# lazygit 
alias lg = lazygit

# 永久设置 gaa = git add .
alias gaa = git add .

# 可选：添加更多常用 Git 别名（示例）
alias gcm = git commit -m
alias gci = git commit
alias gpl = git pull
alias gpu = git push
alias gl = git log
alias gl1 = git log --oneline
alias gst = git status


# def --env y [...args] {
# 	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
# 	^yazi ...$args --cwd-file $tmp
# 	let cwd = (open $tmp)
# 	if $cwd != $env.PWD and (path exists $cwd) {
# 		cd $cwd
# 	}
# 	rm -fp $tmp

# }
# Yazi 包装函数 for Nushell
def --env yy [...args] {
    let tmp = (mktemp -t yazi-cwd.XXXXXX)
    yazi ...$args --cwd-file $tmp
    let cwd = (open $tmp)
    if $cwd != "" and $cwd != $env.PWD {
        cd $cwd
    }
    rm -f $tmp
}

