Import-Module $env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1


function Get-WindowsFeatures([bool] $includeDisabled=$true, [bool] $includeEnabled=$true)
 { 
    
    $featureslog = join-path $env:temp windowsfeatures.log
    $windowsFeaturesArgs ="/c dism /online /get-features /format:table | Tee-Object -FilePath `'$featureslog`';"
    Start-ChocolateyProcessAsAdmin "cmd.exe $windowsFeaturesArgs" -nosleep
    $installOutput =  Get-Content $featureslog -Encoding Ascii | select-string '(Enabled|Disabled)' | sort line

    $windowsFeatures = @()
    
    

    foreach($match in $installOutput) {
         $split = $match.line.split('|');
         $feature = @{}
         $feature.Name = $split[0].trimend()
         $feature.enabled = if($match.line.contains('Enabled')) { $true } else { $false }   
         
         if(($feature.enabled -and $includeEnabled) -or (!$feature.enabled -and $includeDisabled)) {
            $windowsFeatures += $feature
         }
    	}
    
    return $windowsFeatures
}

function Get-EnabledWindowsFeatures() { 
  return Get-WindowsFeatures $false $true 
}

function Get-DisabledWindowsFeatures() { 
  return Get-WindowsFeatures $true $false 
}