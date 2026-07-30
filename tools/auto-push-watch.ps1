# Watches UserDefinedPhrase.dat for changes and auto commits+pushes to GitHub.
# Runs persistently in the background; registered as a Scheduled Task at logon.

$RepoPath = Split-Path -Parent $PSScriptRoot
$FileName = "UserDefinedPhrase.dat"
$LogPath = Join-Path $RepoPath "tools\auto-push.log"

function Write-Log([string]$msg) {
    $line = "[{0}] {1}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $msg
    Add-Content -Path $LogPath -Value $line
}

# Make sure git is resolvable even if this runs before PATH is fully populated for the session.
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

Write-Log "watcher started"

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $RepoPath
$watcher.Filter = $FileName
$watcher.NotifyFilter = [System.IO.NotifyFilters]::LastWrite -bor [System.IO.NotifyFilters]::Size
$watcher.EnableRaisingEvents = $true

$lastPushHash = $null

while ($true) {
    $result = $watcher.WaitForChanged([System.IO.WatcherChangeTypes]::Changed, 3600000)
    if ($result.TimedOut) { continue }

    # debounce: wait for the export tool to finish writing, then settle until size is stable
    Start-Sleep -Milliseconds 1500
    $prevSize = -1
    $target = Join-Path $RepoPath $FileName
    for ($i = 0; $i -lt 10; $i++) {
        if (-not (Test-Path $target)) { Start-Sleep -Milliseconds 500; continue }
        $size = (Get-Item $target).Length
        if ($size -eq $prevSize) { break }
        $prevSize = $size
        Start-Sleep -Milliseconds 500
    }

    try {
        $hash = (Get-FileHash -Path $target -Algorithm SHA256).Hash
    } catch {
        Write-Log "hash failed: $_"
        continue
    }
    if ($hash -eq $lastPushHash) { continue }

    Push-Location $RepoPath
    try {
        $status = git status --porcelain -- $FileName
        if ([string]::IsNullOrWhiteSpace($status)) {
            Write-Log "change detected but git sees no diff, skipping"
            $lastPushHash = $hash
            continue
        }
        git add -- $FileName | Out-Null
        $msg = "Auto-backup: dictionary updated $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        git commit -m $msg | Out-Null
        $pushOutput = git push 2>&1
        Write-Log "pushed: $msg"
        $lastPushHash = $hash
    } catch {
        Write-Log "push failed: $_"
    } finally {
        Pop-Location
    }
}
