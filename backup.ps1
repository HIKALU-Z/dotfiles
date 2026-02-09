# Dotfiles 自动备份脚本
# 功能: 自动提交并推送配置更改到远程仓库
# 用法: .\backup.ps1 [-Message "自定义提交信息"]

param(
    [string]$Message = "Weekly backup: $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
)

$ErrorActionPreference = "Stop"
$DotfilesPath = $PSScriptRoot

# 颜色定义
$Green = "Green"
$Yellow = "Yellow"
$Red = "Red"
$Cyan = "Cyan"

Write-Host @"
╔══════════════════════════════════════════════════════════════╗
║                 Dotfiles Auto Backup                         ║
║                                                              ║
║  $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')                              ║
╚══════════════════════════════════════════════════════════════╝
"@ -ForegroundColor $Cyan

# 检查 Git 仓库
if (-not (Test-Path (Join-Path $DotfilesPath ".git"))) {
    Write-Error "错误: 当前目录不是 Git 仓库" -ForegroundColor $Red
    exit 1
}

Set-Location $DotfilesPath

# 获取当前分支
$currentBranch = git branch --show-current 2>$null
if (-not $currentBranch) {
    Write-Error "错误: 无法获取当前分支" -ForegroundColor $Red
    exit 1
}

Write-Host "当前分支: $currentBranch" -ForegroundColor $Yellow
Write-Host "提交信息: $Message" -ForegroundColor $Yellow
Write-Host ""

# 检查远程仓库
$remoteUrl = git remote get-url origin 2>$null
if (-not $remoteUrl) {
    Write-Error "错误: 未配置远程仓库 origin" -ForegroundColor $Red
    exit 1
}

Write-Host "远程仓库: $remoteUrl" -ForegroundColor $Yellow
Write-Host ""

# 检查是否有更改
$status = git status --porcelain
if (-not $status) {
    Write-Host "✓ 没有需要提交的更改" -ForegroundColor $Green
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor $Cyan
    Write-Host "备份完成: 无需提交" -ForegroundColor $Green
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor $Cyan
    exit 0
}

# 显示更改的文件
Write-Host "待提交的文件:" -ForegroundColor $Yellow
$status | ForEach-Object {
    $file = $_.Substring(3)
    $statusCode = $_.Substring(0, 2)
    Write-Host "  [$statusCode] $file" -ForegroundColor $Cyan
}
Write-Host ""

# 执行 Git 操作
try {
    # 拉取最新更改
    Write-Host "正在拉取远程更新..." -ForegroundColor $Yellow
    git pull origin $currentBranch --quiet
    Write-Host "✓ 拉取完成" -ForegroundColor $Green
    Write-Host ""

    # 添加所有更改
    Write-Host "正在添加更改..." -ForegroundColor $Yellow
    git add .
    Write-Host "✓ 添加完成" -ForegroundColor $Green
    Write-Host ""

    # 提交
    Write-Host "正在提交..." -ForegroundColor $Yellow
    git commit -m "$Message" --quiet
    Write-Host "✓ 提交完成" -ForegroundColor $Green
    Write-Host ""

    # 推送
    Write-Host "正在推送到远程..." -ForegroundColor $Yellow
    git push origin $currentBranch --quiet
    Write-Host "✓ 推送完成" -ForegroundColor $Green
    Write-Host ""

    # 显示提交信息
    $commitHash = git rev-parse --short HEAD
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor $Cyan
    Write-Host "备份成功!" -ForegroundColor $Green
    Write-Host "  提交哈希: $commitHash" -ForegroundColor $Cyan
    Write-Host "  提交时间: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor $Cyan
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor $Cyan

} catch {
    Write-Error "备份失败: $_" -ForegroundColor $Red
    exit 1
}
