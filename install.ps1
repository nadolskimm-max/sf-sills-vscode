<#
.SYNOPSIS
    Installs Salesforce Copilot instructions for VS Code.
.DESCRIPTION
    Copies instruction files to .github/instructions/ in the current project
    and optionally copies copilot-instructions.md to .github/.
.PARAMETER List
    Show available instructions without installing.
.PARAMETER Skills
    Comma-separated list of specific instructions to install.
.PARAMETER Uninstall
    Remove all sf-* instructions from .github/instructions/.
#>
param(
    [switch]$List,
    [string]$Skills,
    [switch]$Uninstall
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$InstructionsSource = Join-Path $ScriptDir "instructions"
$CopilotInstructionsSource = Join-Path $ScriptDir "copilot-instructions.md"
$ProjectDir = Get-Location
$TargetDir = Join-Path $ProjectDir ".github" "instructions"
$TargetCopilot = Join-Path $ProjectDir ".github" "copilot-instructions.md"

$AllInstructions = Get-ChildItem -Path $InstructionsSource -Filter "sf-*.md" | Select-Object -ExpandProperty BaseName | Sort-Object

if ($List) {
    Write-Host "`nAvailable Salesforce Instructions ($($AllInstructions.Count)):" -ForegroundColor Cyan
    Write-Host ("-" * 55)
    foreach ($name in $AllInstructions) {
        $file = Join-Path $InstructionsSource "$name.md"
        $desc = (Get-Content $file -Raw) -replace '(?s).*description:\s*', '' -replace '(?s)\r?\n(applyWhen|---).*', '' -replace '\r?\n', ' '
        $desc = $desc.Substring(0, [Math]::Min(80, $desc.Length)).Trim()
        Write-Host "  $name" -ForegroundColor Green -NoNewline
        Write-Host " - $desc"
    }
    Write-Host ""
    exit 0
}

if ($Uninstall) {
    Write-Host "`nUninstalling Salesforce instructions..." -ForegroundColor Yellow
    $removed = 0
    foreach ($name in $AllInstructions) {
        $target = Join-Path $TargetDir "$name.md"
        if (Test-Path $target) {
            Remove-Item -Path $target -Force
            Write-Host "  Removed: $name.md" -ForegroundColor Red
            $removed++
        }
    }
    if (Test-Path $TargetCopilot) {
        Remove-Item -Path $TargetCopilot -Force
        Write-Host "  Removed: copilot-instructions.md" -ForegroundColor Red
    }
    if ($removed -eq 0) {
        Write-Host "  No instructions found to remove." -ForegroundColor Gray
    } else {
        Write-Host "`nRemoved $removed instruction(s)." -ForegroundColor Yellow
    }
    exit 0
}

$selected = $AllInstructions
if ($Skills) {
    $selected = $Skills -split "," | ForEach-Object { $_.Trim() }
    foreach ($s in $selected) {
        if ($s -notin $AllInstructions) {
            Write-Host "Unknown instruction: $s" -ForegroundColor Red
            Write-Host "Run .\install.ps1 -List to see available instructions."
            exit 1
        }
    }
}

if (-not (Test-Path $TargetDir)) {
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
}

Write-Host "`nInstalling $($selected.Count) instruction(s) to $TargetDir ..." -ForegroundColor Cyan
$installed = 0
foreach ($name in $selected) {
    $source = Join-Path $InstructionsSource "$name.md"
    $target = Join-Path $TargetDir "$name.md"
    Copy-Item -Path $source -Destination $target -Force
    Write-Host "  Installed: $name.md" -ForegroundColor Green
    $installed++
}

$ghDir = Join-Path $ProjectDir ".github"
if (-not (Test-Path $ghDir)) {
    New-Item -ItemType Directory -Path $ghDir -Force | Out-Null
}
Copy-Item -Path $CopilotInstructionsSource -Destination $TargetCopilot -Force
Write-Host "  Installed: copilot-instructions.md" -ForegroundColor Green

Write-Host "`nDone! Installed $installed instruction(s) + global copilot-instructions.md." -ForegroundColor Green
Write-Host ""
