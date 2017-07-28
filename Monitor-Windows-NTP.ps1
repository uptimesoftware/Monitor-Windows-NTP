$computer = 'uptime-demo'

    $NTPStatus = w32tm /query /computer:$computer /status /verbose
    $NTPConfiguration = w32tm /query /computer:$computer /configuration

#build config array and clean it up

    $NTPConfigArray = New-Object System.Collections.Generic.List[String]
    $NTPConfigArray = $NTPConfiguration -split '[\r\n]'
    $NTPConfigArray = $NTPConfigArray + $NTPStatus -split '[\r\n]'

    $NTPConfigArray = $NTPConfigArray | ? {$_}
    $NTPConfigArray = $NTPConfigArray | ? {@("[Configuration]", "[TimeProviders]", "NtpClient (Local)", "NtpServer (Local)", "VMICTimeProvider (Local)") -notcontains $_}
    
    #Write-host ($NTPConfigArray | Out-String).Trim()

    foreach ($pair in $NTPConfigArray) {
        $element= @{}
        $element=$pair -split ':',2
        Write-Host $element[0].Replace(" ", "_").Trim() $element[1].Trim()
    }