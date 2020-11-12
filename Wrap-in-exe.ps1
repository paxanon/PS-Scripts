#
# wrap Source into Source-Version.exe
#

if(!(Get-InstalledModule ps2exe)) {
	Install-Module -Name ps2exe -force -scope CurrentUser
	Import-Module -Name ps2exe
} else {
	Import-Module -Name ps2exe
}

# Variables
$Source = $args[0]
$TargetVersion = $args[1]
$nameExExtention = [System.IO.Path]::GetFileNameWithoutExtension("$Source")
$tempUTF8File = "$env:TEMP\$nameExExtention"
$targetFile = "$nameExExtention-v$TargetVersion.exe"

#Functions


function Convert-File($OldPath, $NewPath) {
  $Content = Get-Content $OldPath -Raw
  $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
  [System.IO.File]::WriteAllLines($NewPath, $Content, $Utf8NoBomEncoding)
}


function wrap {
    param (
        [Parameter(
            Mandatory = $True,
            Position = 0
            )]
        [ValidateLength(1, 1024)]
        [string[]]$Source,

        [Parameter(
            Mandatory = $True,
            Position = 1
            )]
        [ValidateLength(1, 1024)]
        [string[]]$TargetVersion
	)
	Convert-File $Source $tempUTF8File
	Invoke-ps2exe -inputFile $tempUTF8File -outputFile $targetFile -noOutput -noError -noConsole -version $TargetVersion -company "Industriens Pension"
	Remove-Item $tempUTF8File -force
}

wrap $Source $TargetVersion