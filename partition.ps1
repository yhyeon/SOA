$events = get-winevent -FilterHashtable @{logname = 'Microsoft-Windows-Partition/Diagnostic'} | foreach {$_.toxml()}
foreach ($partition in $events)
{
$partition = $partition.split("<")
$eventid = $partition | select-string -pattern 'EventID'
$eventid = $eventid.line.split(">")[1]
$time = $partition | select-string -pattern 'TimeCreated'
$time = [datetime]($time.line.split("=").split("/>").split("'")[2])
$computer = $partition | select-string -pattern 'Computer'
$computer = $computer.line.split(">")[1]
$sid = $partition | select-string -pattern 'Security UserID'
$sid = $sid.line.split("=").split("/>").split("'")[2]
$disknumber = $partition | select-string -pattern 'DiskNumber'
$disknumber = $disknumber.line.Split("=").Split(">").Split("'")[4]
$characteristics = $partition | select-string -Pattern 'Characteristics'
$characteristics = $characteristics.Line.Split("=").Split(">").Split("'")[4]
$busType = $partition | Select-String -Pattern 'BusType'
$bustype = $busType.Line.Split("=").Split(">").Split("'")[4]
$manufacturer = $partition | select-string -pattern 'Manufacturer'
$manufacturer = $manufacturer.line.split("=").split(">").Split("'")[4]
$model = $partition | select-string -Pattern 'Model'
$model = $model.line.Split("=").Split(">").Split("'")[4]
$revision = $partition | select-string -pattern 'Revision'
$revision = $revision.Line.Split("=").Split(">").Split("'")[4]
$serialnumber = $partition | select-string -Pattern 'SerialNumber'
$serialnumber = $serialnumber.line.split("=").Split(">").Split("'")[4]
$parentid = $partition | select-string -Pattern 'ParentId'
$parentid = $parentid.line.split("=").split(">").split("'")[4]
$parentid = $parentid.replace("&amp;","&")
$diskid = $partition | select-string -Pattern 'DiskId'
$diskid = $diskid.line.Split("=").Split(">").Split("'").split("{").split("}")[5]
$registryid = $partition | select-string -Pattern 'RegistryId'
$registryid = $registryid.line.Split("=").Split(">").Split("'").split("{").split("}")[5]
$eventid + " : " + $time + " : " + $computer + " : " + $sid + " : " + $disknumber + " : " + $characteristics + " : " + $busType + " : " + $manufacturer + " : " + $model + " : " + $revision + " : " + $serialnumber + " : " + $parentid + " : " + $diskid + " : " + $registryid | out-file C:\Users\Public\Documents\${env:COMPUTERNAME}_$(get-date -f yyyyMMddhhmm)_partition.txt -Append
}
