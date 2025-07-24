'testv6'
'new line'
'test123'
function Get-DirectoryReport
{
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if (-not (Test-Path $Path))
    {
        Write-Error "Path '$Path' does not exist."
        return
    }

    $items = Get-ChildItem -Path $Path -Force
    $report = @()

    foreach ($item in $items)
    {
        $type = if ($item.PSIsContainer) { 'Directory' } else { 'File' }
        $size = if ($item.PSIsContainer)
        { 
            (Get-ChildItem -Path $item.FullName -Recurse -File | Measure-Object -Property Length -Sum).Sum
        }
        else
        {
            $item.Length
        }
        $report += [PSCustomObject]@{
            Name          = $item.Name
            Type          = $type
            Size          = $size
            LastWriteTime = $item.LastWriteTime
            FullPath      = $item.FullName
        }
    }

    $report | Sort-Object Type, Name | Format-Table -AutoSize
}

# Example usage:
# Get-DirectoryReport -Path "C:\Temp"
