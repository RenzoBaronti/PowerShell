<#
.SYNOPSIS
    Brief description of what the script does.

.DESCRIPTION
    Detailed description of the script's functionality.

.PARAMETER ParameterName
    Description of the parameter.

.EXAMPLE
    Example usage of the script.

.NOTES
    Additional notes or author information.
#>

# Define parameters
param (
    [string]$Parameter1,
    [int]$Parameter2 = 10
)

# Function definition
function Get-SampleData {
    param (
        [string]$Input
    )
    Write-Host "Processing input: $Input"
}

# Main script logic
Write-Host "Starting script execution..."
Get-SampleData -Input $Parameter1
Write-Host "Script execution completed."
