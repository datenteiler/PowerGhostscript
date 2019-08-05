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
      Add-Type -Path $(Join-Path $PSScriptRoot "GhostscriptSharp.dll")
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
      [GhostscriptSharp.GhostscriptWrapper]::GenerateOutput($GsInputPath, $GsOutputPath, $GsSettings)
    }
}
