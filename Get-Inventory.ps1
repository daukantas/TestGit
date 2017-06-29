$CPUInfo = Get-WmiObject Win32_Processor #Get CPU Information
$OSInfo = Get-WmiObject Win32_OperatingSystem #Get OS Information
#Get Memory Information. The data will be shown in a table as MB, rounded to the nearest second decimal.
$OSTotalVirtualMemory = [math]::round($OSInfo.TotalVirtualMemorySize / 1MB, 2)
$OSTotalVisibleMemory = [math]::round(($OSInfo.TotalVisibleMemorySize / 1MB), 2)
$PhysicalMemory = Get-WmiObject CIM_PhysicalMemory | Measure-Object -Property capacity -Sum | % { [Math]::Round(($_.sum / 1GB), 2) }
Foreach ($CPU in $CPUInfo)
{
  $infoObject = New-Object PSObject
  #The following add data to the infoObjects.
  Add-Member -inputObject $infoObject -memberType NoteProperty -name "ServerName" -value $CPU.SystemName
  Add-Member -inputObject $infoObject -memberType NoteProperty -name "Processor" -value $CPU.Name
  Add-Member -inputObject $infoObject -memberType NoteProperty -name "Model" -value $CPU.Description
  Add-Member -inputObject $infoObject -memberType NoteProperty -name "Manufacturer" -value $CPU.Manufacturer
  Add-Member -inputObject $infoObject -memberType NoteProperty -name "PhysicalCores" -value $CPU.NumberOfCores
  Add-Member -inputObject $infoObject -memberType NoteProperty -name "CPU_L2CacheSize" -value $CPU.L2CacheSize
  Add-Member -inputObject $infoObject -memberType NoteProperty -name "CPU_L3CacheSize" -value $CPU.L3CacheSize
  Add-Member -inputObject $infoObject -memberType NoteProperty -name "Sockets" -value $CPU.SocketDesignation
  Add-Member -inputObject $infoObject -memberType NoteProperty -name "LogicalCores" -value $CPU.NumberOfLogicalProcessors
  Add-Member -inputObject $infoObject -memberType NoteProperty -name "OS_Name" -value $OSInfo.Caption
  Add-Member -inputObject $infoObject -memberType NoteProperty -name "OS_Version" -value $OSInfo.Version
  Add-Member -inputObject $infoObject -memberType NoteProperty -name "TotalPhysical_Memory_GB" -value $PhysicalMemory
  Add-Member -inputObject $infoObject -memberType NoteProperty -name "TotalVirtual_Memory_MB" -value $OSTotalVirtualMemory
  Add-Member -inputObject $infoObject -memberType NoteProperty -name "TotalVisable_Memory_MB" -value $OSTotalVisibleMemory
  Out-Host -InputObject $infoObject #Output to the screen for a visual feedback.
  $infoColl += $infoObject
}
