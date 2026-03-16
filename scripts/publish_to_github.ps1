param(
    [string]$CommitMessage = ""
)

$ErrorActionPreference = "Stop"

function Invoke-Git {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$Args
    )

    & git @Args
    if ($LASTEXITCODE -ne 0) {
        throw "git command failed: git $($Args -join ' ')"
    }
}

$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

$branch = (git branch --show-current).Trim()
if (-not $branch) {
    throw "Could not detect the current git branch."
}

$gitUserName = (git config --get user.name).Trim()
$gitUserEmail = (git config --get user.email).Trim()
if (-not $gitUserName -or -not $gitUserEmail) {
    throw "Git identity is not configured. Run: git config --global user.name `"Your Name`" and git config --global user.email `"you@example.com`""
}

$remote = (git remote).Trim()
if (-not $remote -or $remote -notmatch "(^|`n)origin($|`n)") {
    throw "Git remote 'origin' is not configured."
}

$publishPaths = @(
    "docs",
    "reports",
    "artifacts",
    "scripts/publish_to_github.ps1"
)

$existingPaths = @($publishPaths | Where-Object { Test-Path $_ })
if ($existingPaths.Count -eq 0) {
    throw "No publishable paths were found."
}

if ([string]::IsNullOrWhiteSpace($CommitMessage)) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $CommitMessage = "publish stock analysis update $timestamp"
}

Invoke-Git -Args (@("add", "--") + $existingPaths)

& git diff --cached --quiet -- $existingPaths
$hasCachedChanges = ($LASTEXITCODE -ne 0)

& git diff --quiet -- $existingPaths
$hasWorkingTreeChanges = ($LASTEXITCODE -ne 0)

if (-not $hasCachedChanges -and -not $hasWorkingTreeChanges) {
    Write-Host "No changes detected in publish paths."
    exit 0
}

Invoke-Git -Args (@("commit", "--only", "-m", $CommitMessage, "--") + $existingPaths)
Invoke-Git -Args @("push", "-u", "origin", $branch)

Write-Host ""
Write-Host "Published to GitHub."
Write-Host "Branch: $branch"
Write-Host "Commit: $CommitMessage"
