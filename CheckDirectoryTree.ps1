[CmdletBinding()]
Param(
    [Parameter( Mandatory = $True, Position = 1)]
        [ValidateScript({Test-Path $_ -PathType 'Container'})]
        [string]$OriginalDirectory,
    [Parameter( Mandatory = $True, Position = 2)]
        [ValidateScript({Test-Path $_ -PathType 'Container'})]
        [string]$CheckDirectory,
    [Parameter(Mandatory = $False)]
        [string]$PrependText
)

$DirectoryCalledFrom = Get-Location

Set-Location $OriginalDirectory

foreach( $item in Get-ChildItem -Recurse ) {
    $RelativePath = Resolve-Path -Relative $item.fullname
    Write-Verbose "Checking file at $OriginalDirectory\$RelativePath... "
    Write-Debug "Original Path: $OriginalDirectory\$RelativePath"
    Write-Debug "Check Path: $CheckDirectory\$RelativePath`_result"
    Write-Debug "Check Path Exists: $(Test-Path "$CheckDirectory\$RelativePath`_result")"
    if( Test-Path "$CheckDirectory\$RelativePath`_result") {
        Write-Verbose "Found file at $CheckDirectory\$RelativePath`_result"
        if( $PrependText -and !$item.PSIsContainer ) {
            Write-Verbose "Prepending $OriginalDirectory\$RelativePath"
            Rename-Item "$OriginalDirectory\$RelativePath" "$PrependText$item"
        }
    Write-Output ("$RelativePath - Succeded")
    }
    else {
        Write-Output ("$RelativePath - Failed")
    }
}

#
Set-Location $DirectoryCalledFrom
