import-module WebAdministration

function Configure-IISWebSite(
[string] $siteName,
[string] $physicalPath,
[string] $applicationPool,
$bindings
) { 

if(!Get-WebSite $siteName){
  write-host "$siteName does not exist. creating at physical path $physicalpath"
  New-Website $siteName -PhysicalPath $physicalPath
}


  set-ItemProperty "IIS:\Sites\$siteName" -name physicalpath -value $physicalPath
  Set-ItemProperty 'IIS:\Sites\$SiteName\AppName' ApplicationPool $applicationPool
  Set-ItemProperty -Path 'IIS:\Sites\$siteName' -Name Bindings -Value $bindings
}


#Roles
#- NorBEWebServer
#- LDSAppServer
#- BiztalkAppServer
#- NorBESQLServer
#- BiztalkSQLServer