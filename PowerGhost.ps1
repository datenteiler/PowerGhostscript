function Convert-PDFtoTiff
<#
.Synopsis
   Convert a PDF file into a Tiff file
.DESCRIPTION
   Convert a PDF file into a Tiff file with GhostscriptSharp
   as wrapper for the native Ghostscript dll: gsdll64.dll
.EXAMPLE
   Convert-PDFtoTiff -pdf "C:\Users\Public\Franz.pdf" -tiff "C:\Users\Public\Franz.tiff" -dpi 600 -a4
#>
{
  [CmdletBinding()]
  [Alias()]
  [OutputType([int])]
  Param
  (
    [Parameter(Mandatory=$true, Position=0)]
    [string]$pdf,

    [Parameter(Mandatory=$true, Position=1)]
    [string]$tiff,
        
    [Parameter(Mandatory=$true, Position=2)]
    [int]$dpi,
        
    [Parameter(Mandatory = $true, ParameterSetName = 'byA4')]
    [Switch]$a4,

    [Parameter(Mandatory = $true, ParameterSetName = 'byLetter')]
    [Switch]$letter
  )

  Begin
  {
    # Decode DLLs from text files
    if (!(Test-Path $(Join-Path $PSScriptRoot "gsdll64.dll")))
    {
      certutil -decode gsdll64.txt gsdll64.dll | Write-Verbose
    }
    if (!(Test-Path $(Join-Path $PSScriptRoot "GhostscriptSharp.dll")))
    {
      certutil -decode GhostscriptSharp.txt GhostscriptSharp.dll | Write-Verbose
    }
    # Check if Ghostscript if in path
    if (Test-Path $(Join-Path $PSScriptRoot "GhostscriptSharp.dll"))
    {
      Add-Type -Path $(Join-Path $PSScriptRoot "GhostscriptSharp.dll")
    }
    else
    {
      Write-Error "GhostscriptSharp.dll is missing!"
    }
    Add-Type -AssemblyName System.Drawing
  }
  
  Process
  {
    $Size = New-Object System.Drawing.Size($dpi,$dpi)

    [string]$GsInputPath = $pdf
    [string]$GsOutputPath = $tiff
    $GsSettings = New-Object GhostscriptSharp.GhostscriptSettings
    $GsSettings.Device = [GhostscriptSharp.Settings.GhostscriptDevices]::tiffpack
    $GsSettings.Page.AllPages = $true
    $GsSettings.Resolution = $Size
    if ($a4) {
      $GsSettings.Size.Native = [GhostscriptSharp.Settings.GhostscriptPageSizes]::a4
    }
    if ($letter) {
      $GsSettings.Size.Native = [GhostscriptSharp.Settings.GhostscriptPageSizes]::letter
    }   
  }
  
  End
  {
    Write-Verbose "Create TIFF file $GsOutputPath with $($Size.Height) dpi as $($GsSettings.Size.Native)"
    [GhostscriptSharp.GhostscriptWrapper]::GenerateOutput($GsInputPath, $GsOutputPath, $GsSettings)
    Write-Verbose "TIFF file $GsOutputPath from $GsInputPath created."
  }
}
