New-Item 'HKLM:\SYSTEM\CurrentControlSet\Services\Csc\Parameters' -Force | Out-Null
New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Services\Csc\Parameters' -name 'FormatDatabase' -value '1' -PropertyType 'DWord' -Force | Out-Null
