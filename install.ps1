# Dotfiles 自动安装脚本 (Windows)
# 使用方法: 以管理员权限运行 PowerShell，然后执行: .\install.ps1

param(
    [string]$DotfilesPath = $PSScriptRoot
)

$ErrorActionPreference = "Stop"

Write-Host @"
╔══════════════════════════════════════════════════════════════╗
║                    Dotfiles Installer                        ║
║                                                              ║
║  WezTerm | Neovim | Nushell | Starship                      ║
╚══════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

# 检查管理员权限
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $isAdmin) {
    Write-Warning "建议以管理员权限运行此脚本，以确保符号链接创建成功"
    Write-Host ""
}

# 定义配置映射
$configs = @(
    @{
        Name = "WezTerm"
        Source = Join-Path $DotfilesPath "wezterm"
        Target = "$env:USERPROFILE\.config\wezterm"
        TargetParent = "$env:USERPROFILE\.config"
    },
    @{
        Name = "Neovim"
        Source = Join-Path $DotfilesPath "nvim"
        Target = "$env:LOCALAPPDATA\nvim"
        TargetParent = "$env:LOCALAPPDATA"
    },
    @{
        Name = "Nushell"
        Source = Join-Path $DotfilesPath "nushell"
        Target = "$env:APPDATA\nushell"
        TargetParent = "$env:APPDATA"
    },
    @{
        Name = "Starship"
        Source = Join-Path $DotfilesPath "starship\starship.toml"
        Target = "$env:USERPROFILE\.config\starship.toml"
        TargetParent = "$env:USERPROFILE\.config"
        IsFile = $true
    }
)

$successCount = 0
$skipCount = 0
$failCount = 0

foreach ($config in $configs) {
    Write-Host "Installing $($config.Name)..." -ForegroundColor Yellow
    
    # 检查源文件是否存在
    if (-not (Test-Path $config.Source)) {
        Write-Warning "  Source not found: $($config.Source)"
        $failCount++
        continue
    }
    
    # 确保目标父目录存在
    if (-not (Test-Path $config.TargetParent)) {
        New-Item -ItemType Directory -Path $config.TargetParent -Force | Out-Null
        Write-Host "  Created directory: $($config.TargetParent)" -ForegroundColor Gray
    }
    
    # 检查目标是否已存在
    if (Test-Path $config.Target) {
        $item = Get-Item $config.Target
        
        # 检查是否已经是正确的符号链接
        if ($item.Attributes -match "ReparsePoint") {
            $currentTarget = $item.Target
            if ($currentTarget -eq $config.Source) {
                Write-Host "  ✓ Already linked correctly" -ForegroundColor Green
                $successCount++
                continue
            } else {
                Write-Warning "  Existing link points to: $currentTarget"
                Write-Host "  Removing old link..." -ForegroundColor Gray
                Remove-Item $config.Target -Force
            }
        } else {
            # 备份现有配置
            $backupName = "$($config.Name)_backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
            $backupPath = Join-Path "$env:TEMP\dotfiles_backups" $backupName
            
            Write-Warning "  Existing config found, backing up to: $backupPath"
            New-Item -ItemType Directory -Path (Split-Path $backupPath) -Force | Out-Null
            Move-Item $config.Target $backupPath -Force
        }
    }
    
    # 创建符号链接
    try {
        if ($config.IsFile) {
            New-Item -ItemType SymbolicLink -Path $config.Target -Target $config.Source -Force | Out-Null
        } else {
            New-Item -ItemType SymbolicLink -Path $config.Target -Target $config.Source -Force | Out-Null
        }
        Write-Host "  ✓ Linked: $($config.Target) -> $($config.Source)" -ForegroundColor Green
        $successCount++
    } catch {
        Write-Error "  ✗ Failed to create link: $_"
        $failCount++
    }
    
    Write-Host ""
}

# 显示总结
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "Installation Summary:" -ForegroundColor Cyan
Write-Host "  Success: $successCount" -ForegroundColor Green
Write-Host "  Skipped: $skipCount" -ForegroundColor Yellow
Write-Host "  Failed:  $failCount" -ForegroundColor Red
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan

if ($failCount -eq 0) {
    Write-Host "`n🎉 All configurations installed successfully!" -ForegroundColor Green
    Write-Host "`nNext steps:" -ForegroundColor Cyan
    Write-Host "  1. Restart your terminal" -ForegroundColor White
    Write-Host "  2. Enjoy your dotfiles!" -ForegroundColor White
} else {
    Write-Host "`n⚠️  Some configurations failed to install." -ForegroundColor Yellow
    Write-Host "   Try running the script as Administrator." -ForegroundColor White
}

Write-Host ""
