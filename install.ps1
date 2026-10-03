<#
.SYNOPSIS
    Installs LazyVim configuration for Windows by creating a link in $env:LOCALAPPDATA\nvim.

.DESCRIPTION
    Checks prerequisites (nvim, git, ripgrep), backs up any existing Neovim configuration,
    creates a Directory Symbolic Link (or Directory Junction fallback), and launches
    Neovim to initialize plugins.

.PARAMETER InstallPrereqs
    Automatically attempt to install missing prerequisites using winget without prompting.

.PARAMETER SkipLaunch
    Skip launching Neovim after linking.
#>
[CmdletBinding()]
param(
    [switch]$InstallPrereqs,
    [switch]$SkipLaunch
)

$ErrorActionPreference = "Stop"

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "       LazyVim Configuration Installer       " -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

$repoRoot = [System.IO.Path]::GetFullPath($PSScriptRoot).TrimEnd('\', '/')
$targetDir = [System.IO.Path]::GetFullPath((Join-Path $env:LOCALAPPDATA "nvim")).TrimEnd('\', '/')

# 1. Check prerequisites
Write-Host "[1/4] Checking prerequisites..." -ForegroundColor Cyan

$prereqs = @(
    @{ Command = "nvim"; Name = "Neovim"; WingetId = "Neovim.Neovim" },
    @{ Command = "git";  Name = "Git";    WingetId = "Git.Git" },
    @{ Command = "rg";   Name = "Ripgrep"; WingetId = "BurntSushi.ripgrep.MSVC" }
)

$missingTools = @()
foreach ($tool in $prereqs) {
    if (Get-Command $tool.Command -ErrorAction SilentlyContinue) {
        Write-Host "  [+] Found $($tool.Name) ($($tool.Command))" -ForegroundColor Green
    } else {
        Write-Host "  [-] Missing $($tool.Name) ($($tool.Command))" -ForegroundColor Yellow
        $missingTools += $tool
    }
}

if ($missingTools.Count -gt 0) {
    $hasWinget = [bool](Get-Command winget -ErrorAction SilentlyContinue)
    if ($hasWinget) {
        $shouldInstall = $InstallPrereqs
        if (-not $shouldInstall -and [Environment]::UserInteractive) {
            $names = ($missingTools | ForEach-Object { $_.Name }) -join ", "
            $answer = Read-Host "Missing prerequisites ($names). Install them via winget now? (y/N)"
            if ($answer -match '^[Yy]') {
                $shouldInstall = $true
            }
        }

        if ($shouldInstall) {
            foreach ($tool in $missingTools) {
                Write-Host "Installing $($tool.Name) via winget..." -ForegroundColor Cyan
                winget install --id $tool.WingetId --exact --accept-package-agreements --accept-source-agreements
            }
            Write-Host "Installed missing tools. If command lookups fail, restart your shell after setup." -ForegroundColor Yellow
        } else {
            Write-Warning "Proceeding without installing missing tools: $(($missingTools | ForEach-Object { $_.Name }) -join ', '). Some features may not work until installed."
        }
    } else {
        Write-Warning "winget is not available. Please install missing tools manually: $(($missingTools | ForEach-Object { $_.Name }) -join ', ')."
    }
}

Write-Host ""

# 2. Check target path and backup if needed
Write-Host "[2/4] Verifying destination directory..." -ForegroundColor Cyan
Write-Host "  Target: $targetDir"
Write-Host "  Source: $repoRoot"

$inPlace = ($repoRoot -eq $targetDir)
$alreadyLinked = $false

if ($inPlace) {
    Write-Host "  [OK] Repository is already located at target destination ($targetDir)." -ForegroundColor Green
} elseif (Test-Path -LiteralPath $targetDir) {
    $item = Get-Item -LiteralPath $targetDir -Force
    if ($item.LinkType -and $item.Target) {
        $currentTarget = if ($item.Target -is [array]) { $item.Target[0] } else { $item.Target }
        $normalizedCurrent = [System.IO.Path]::GetFullPath($currentTarget).TrimEnd('\', '/')
        if ($normalizedCurrent -eq $repoRoot) {
            Write-Host "  [OK] Destination is already linked to this repository ($($item.LinkType))." -ForegroundColor Green
            $alreadyLinked = $true
        }
    }

    if (-not $alreadyLinked) {
        $timestamp = Get-Date -Format "yyyyMMddHHmmss"
        $backupPath = "$targetDir.bak.$timestamp"
        Write-Host "  Existing configuration detected. Backing up to:" -ForegroundColor Yellow
        Write-Host "  $backupPath" -ForegroundColor Yellow
        Move-Item -LiteralPath $targetDir -Destination $backupPath -Force
        Write-Host "  Backup created successfully." -ForegroundColor Green
    }
}

Write-Host ""

# 3. Create Symlink or Junction
Write-Host "[3/4] Linking configuration..." -ForegroundColor Cyan

if ($inPlace) {
    Write-Host "  Repository is already in target destination, skipping link creation." -ForegroundColor Green
} elseif ($alreadyLinked) {
    Write-Host "  Link already in place, skipping link creation." -ForegroundColor Green
} else {
    $parentDir = Split-Path -Parent $targetDir
    if (-not (Test-Path -LiteralPath $parentDir)) {
        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
    }

    $linkCreated = $false

    # Try Directory Symbolic Link first
    try {
        New-Item -ItemType SymbolicLink -Path $targetDir -Target $repoRoot -Force -ErrorAction Stop | Out-Null
        Write-Host "  [OK] Successfully created Symbolic Link ($targetDir -> $repoRoot)" -ForegroundColor Green
        $linkCreated = $true
    } catch {
        Write-Host "  Symbolic Link creation failed (requires Developer Mode or Administrator privileges)." -ForegroundColor Yellow
        Write-Host "  Falling back to Directory Junction (no admin rights required)..." -ForegroundColor Yellow
    }

    # Fallback to Directory Junction if symlink was not created
    if (-not $linkCreated) {
        $junctionOutput = cmd.exe /c mklink /J "$targetDir" "$repoRoot" 2>&1
        if ($LASTEXITCODE -eq 0 -and (Test-Path -LiteralPath $targetDir)) {
            Write-Host "  [OK] Successfully created Directory Junction ($targetDir -> $repoRoot)" -ForegroundColor Green
            $linkCreated = $true
        } else {
            throw "Failed to create directory link or junction: $junctionOutput"
        }
    }
}

Write-Host ""

# 4. Launch Neovim to initialize plugins
Write-Host "[4/4] Finalizing setup..." -ForegroundColor Cyan
if ($SkipLaunch) {
    Write-Host "  SkipLaunch specified. Run 'nvim' to initialize plugins." -ForegroundColor Yellow
} elseif (Get-Command nvim -ErrorAction SilentlyContinue) {
    Write-Host "  Launching Neovim to initialize LazyVim and plugins..." -ForegroundColor Green
    Write-Host "  Press Enter / wait for lazy.nvim to complete plugin downloads in the Neovim window." -ForegroundColor Cyan
    & nvim
} else {
    Write-Host "  'nvim' command not found in PATH." -ForegroundColor Yellow
    Write-Host "  Please install Neovim and run 'nvim' to complete plugin installation." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Setup completed successfully!" -ForegroundColor Green
