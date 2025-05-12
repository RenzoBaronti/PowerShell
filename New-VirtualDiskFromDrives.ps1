function New-VirtualDiskFromDrives {
    param (
        [Parameter(Mandatory=$true)]
        [string]$BMC,

        [Parameter(Mandatory=$true)]
        [string]$Username,

        [Parameter(Mandatory=$true)]
        [string]$Password,

        [Parameter(Mandatory=$true)]
        [string]$ControllerFQDD,

        [Parameter(Mandatory=$true)]
        [string[]]$Drives
    )

    $DriveCount = $Drives.Count

    if ($DriveCount -eq 2) {
        Write-Host "Creating RAID 1 with 2 drives..."

        Invoke-CreateVirtualDiskREDFISH -IP $BMC -Username $Username -Password $Password `
            -ControllerFQDD $ControllerFQDD `
            -RAIDLevel "RAID1" `
            -PhysicalDisks $Drives `
            -VolumeName "OS"

    } elseif ($DriveCount -gt 2 -and ($DriveCount % 2) -eq 1) {
        Write-Host "Creating RAID 10 with one global hot spare..."

        $Spare = $Drives[-1]
        $RAID10Disks = $Drives[0..($DriveCount - 2)]

        Invoke-CreateVirtualDiskREDFISH -IP $BMC -Username $Username -Password $Password `
            -ControllerFQDD $ControllerFQDD `
            -RAIDLevel "RAID10" `
            -PhysicalDisks $RAID10Disks `
            -HotSpareDisks @($Spare) `
            -VolumeName "DATA"

    } else {
        Write-Host "Invalid drive count for RAID setup. Provide exactly 2 drives for RAID 1, or at least 3 usable + 1 spare (odd number) for RAID 10 with a hot spare."
    }
}
