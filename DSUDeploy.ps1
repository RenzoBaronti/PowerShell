# Deploy-DellUpdates.ps1

# Set working directory to script location
Set-Location -Path $PSScriptRoot

# Prepare repository and catalog paths
$repoPath = Join-Path -Path $PSScriptRoot -ChildPath "repository"
$catalogPath = Join-Path -Path $PSScriptRoot -ChildPath "catalog.xml"

# Start logging
$logPath = Join-Path -Path $env:TEMP -ChildPath "DSU-Deploy.log"
Start-Transcript -Path $logPath -Force

try {
    Write-Output "Starting Dell System Update (DSU) deployment..."

    # Run DSU silently with manual repo/catalog override
    $arguments = @(
        "--non-interactive",
        "--apply-upgrades-only",
        "--reboot=disable",
        "--repository=$repoPath",
        "--catalog-location=$catalogPath"
    )

    $process = Start-Process -FilePath ".\DSU\DSU.exe" `
        -ArgumentList $arguments `
        -Wait -NoNewWindow -PassThru

    if ($process.ExitCode -eq 0) {
        Write-Output "DSU completed successfully."
        $success = $true
    }
    else {
        Write-Output "DSU exited with code $($process.ExitCode)."
        $success = $false
    }
}
catch {
    Write-Error "An error occurred: $_"
    $success = $false
}
finally {
    Stop-Transcript
}

# Return exit code for SCCM detection
if ($success) {
    exit 0
} else {
    exit 1
}
