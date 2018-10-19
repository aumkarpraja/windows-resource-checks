param($w="80",$c="90")

$mem_total = Get-WmiObject win32_OperatingSystem | Select-Object -ExpandProperty TotalVisibleMemorysize
$mem_free = Get-WmiObject win32_OperatingSystem | Select-Object  -ExpandProperty FreePhysicalMemory
$mem_used = $mem_total - $mem_free

$mem_usage = [math]::Round(($mem_used / $mem_total) * 100)


# Edge cases (if for some reason disk usage is beyond what it should be)
if ($mem_usage -lt 0 -or $mem_usage -gt 100) {
	Write-Host "status=unknown,mem_usage=$mem_usage"
}

if ($mem_usage -ge $w -and $mem_usage -lt $c){
	Write-Host "status=warn,$mem_usage"
	Exit 1
}
elseif ($mem_usage -ge $c) {
	Write-Host "status=crit,mem_usage=$mem_usage"
	Exit 2
}
else {
	Write-Host "status=ok,mem_usage=$mem_usage"
	Exit 0
}