param(
  [string]$Entry = "main.lua",
  [string]$Lua = "lua"
)

$basePath = Split-Path -Parent $MyInvocation.MyCommand.Path
Push-Location $basePath

if (-not (Test-Path $Entry)) {
  Write-Error "Entry file '$Entry' not found in $basePath"
  Pop-Location
  exit 1
}

# Clear any previous host outputs and show startup message
Write-Host "========================================="
Write-Host "Starting Lua Watcher"
Write-Host "Watching .lua files in $basePath"
Write-Host "Entry file: $Entry"
Write-Host "Press Ctrl+C to stop."
Write-Host "========================================="

# 1. Run once on startup so the user sees the initial output
Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Initial execution:"
try {
  & $Lua $Entry
  $code = $LASTEXITCODE
  Write-Host "Lua exit code: $code"
} catch {
  Write-Host "Error while running script: $_"
}
Write-Host "-----------------------------------------"

# Track the last write time of files
$lastWriteTimes = @{}

# Helper function to get all lua files and their write times
function Get-LuaFiles {
  Get-ChildItem -Path $basePath -Filter "*.lua" -Recurse | Where-Object { $_.Attributes -notlike "*Directory*" }
}

# Initialize the file tracking list
Get-LuaFiles | ForEach-Object {
  $lastWriteTimes[$_.FullName] = $_.LastWriteTime
}

try {
  while ($true) {
    Start-Sleep -Milliseconds 500
    
    $currentFiles = Get-LuaFiles
    $changeDetected = $false
    $changedFile = ""
    
    # Check for modifications or new files
    foreach ($file in $currentFiles) {
      $path = $file.FullName
      $lastWrite = $file.LastWriteTime
      
      if (-not $lastWriteTimes.ContainsKey($path)) {
        # New file added
        $lastWriteTimes[$path] = $lastWrite
        $changeDetected = $true
        $changedFile = $file.Name
      } elseif ($lastWriteTimes[$path] -ne $lastWrite) {
        # Existing file modified
        $lastWriteTimes[$path] = $lastWrite
        $changeDetected = $true
        $changedFile = $file.Name
      }
    }
    
    # Check for deleted files
    $deletedPaths = @()
    foreach ($path in $lastWriteTimes.Keys) {
      if (-not (Test-Path $path)) {
        $deletedPaths += $path
        $changeDetected = $true
        $changedFile = "$(Split-Path $path -Leaf) (Deleted)"
      }
    }
    foreach ($path in $deletedPaths) {
      $lastWriteTimes.Remove($path)
    }
    
    # If change was detected, run the Lua script
    if ($changeDetected) {
      Write-Host "`n[$(Get-Date -Format 'HH:mm:ss')] Change detected: $changedFile"
      Write-Host "Running: $Lua $Entry"
      try {
        & $Lua $Entry
        $code = $LASTEXITCODE
        Write-Host "Lua exit code: $code"
      } catch {
        Write-Host "Error while running script: $_"
      }
      Write-Host "-----------------------------------------"
    }
  }
} finally {
  Pop-Location
}
