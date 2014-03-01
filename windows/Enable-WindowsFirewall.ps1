
function Enable-WindowsFirewall { 
    netsh advfirewall set allprofiles state on
}

function Disable-WindowsFirewall { 
    netsh advfirewall set allprofiles state off
}