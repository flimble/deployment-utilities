function EnumOrchestrations($catalog)
{
    Write-Host `r`n======================
    Write-Host ===  ORCHESTRATIONS  ===
    Write-Host ======================`r`n 

    #=== Enumerating the assemblies and pulling orchestration information ===#

    foreach($assembly in $catalog.Assemblies)
    {
        foreach($orch in $assembly.Orchestrations)
        {
            #=== We can’t report the host if it is not hosted or enlisted ===#
            if ($orch.Status -ieq "Unenlisted")
            {
                Write-Host Name : $orch.Fullname`r`nHost : N/A`r`nStatus : $orch.Status
            }
            else
            {
                Write-Host Name : $orch.Fullname`r`nHost : $orch.Host.Name`r`nStatus : $orch.Status
            }

            #=== Reporting port types and operations ===#
            foreach($port in $orch.Ports)
            {
                Write-Host "`tPort:"$port.PortType.FullName

                foreach($portop in $port.PortType.Operations)
                {
                    Write-Host "`t`tOperation:"$portop.Name
                }
            }

            #=== Reporting Used roles ===#
            foreach($role in $orch.UsedRoles)
            {
                Write-Host "`tRole:"$role.Name"`("$role.ServiceLinkType"`)"

                foreach($EnlistedParty in $role.EnlistedParties)
                {
                    Write-Host "`t`tParty:"$Enlistedparty.Party.Name
                }
            }

            #=== Reporting implemented roles ===#
            foreach($role in $orch.ImplementedRoles)
            {
                Write-Host "`tRole:"$role.Name"`("$role.ServiceLinkType"`)"
            }

            Write-Host
        }
    }
}


Function EnumOtherArtifacts($catalog)
{
    Write-Host `r`n======================
    Write-Host "===   ASSEMBLIES   ==="
    Write-Host ======================`r`n 

    foreach($assembly in $catalog.Assemblies)
    {
        Write-Host $assembly.Name
    }

    Write-Host `r`n======================
    Write-Host "===     HOSTS      ==="
    Write-Host ======================`r`n 

    foreach($btshost in $catalog.Hosts)
    {
        Write-Host $btshost.Name"`($($btshost.Type)`)"
    }

    Write-Host `r`n======================
    Write-Host "===    PARTIES     ==="
    Write-Host ======================`r`n 

    foreach($party in $catalog.Parties)
    {
        Write-Host $party.Name

        foreach($sendport in $party.SendPorts)
        {
            Write-Host "`tSendPort:"$sendport.Name
        }

        foreach($alias in $party.Aliases)
        {
            Write-Host "`tAlias:"$alias.Name":"$alias.Qualifier"="$alias.Value
        }
    }

    Write-Host `r`n======================
    Write-Host "===   TRANSFORMS   ==="
    Write-Host ======================`r`n 

    foreach($transform in $catalog.Transforms)
    {
        Write-Host $transform.FullName":`r`n`t"$transform.SourceSchema.Fullname"==>"$transform.TargetSchema.Fullname`r`n
    }
}



#=== Main Script Body ===#

#=== Make sure the ExplorerOM assembly is loaded ===#

[void] [System.reflection.Assembly]::LoadWithPartialName("Microsoft.BizTalk.ExplorerOM")

#=== Connect to the BizTalk Management database ===#

$Catalog = New-Object Microsoft.BizTalk.ExplorerOM.BtsCatalogExplorer
$Catalog.ConnectionString = "SERVER=.;DATABASE=BizTalkMgmtDb;Integrated Security=SSPI"

#=== All reporting is performed in the following two functions ===#

EnumOrchestrations $Catalog
EnumOtherArtifacts $Catalog