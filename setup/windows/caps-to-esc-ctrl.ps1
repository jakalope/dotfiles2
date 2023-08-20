$hexKey = "00,00,00,00,00,00,00,00,02,00,00,00,3A,00,1D,00,1D,00,3A,00,00,00,00,00"

$hexArray = $hexKey -split ',' | ForEach-Object { [byte]("0x$_") }

$kbLayout = [System.Text.Encoding]::Unicode.GetBytes("Keyboard Layout")
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout"

# Create the Scancode Map registry value
New-ItemProperty -Path $regPath -Name "Scancode Map" -Value ([byte[]]$hexArray) -PropertyType Binary -Force

# Load the new Scancode Map configuration
$kbLayout | ForEach-Object { $null = [System.Runtime.InteropServices.Marshal]::WriteInt16($_, 0) }

Write-Host "Caps Lock has been remapped to Ctrl and Esc. Please restart your computer to apply the changes."
