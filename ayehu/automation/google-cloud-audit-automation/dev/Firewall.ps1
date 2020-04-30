#code to check directory exists or not,if not create one

$name = $ENV:WORKSPACE + "\ayehu\automation\google-cloud-audit-automation\dev\Gcloud_Firewall_Inventory_Module.ps1"


import-module -name $name -DisableNameChecking  -Force


$DesktopPath = "/tmp/"+"Firewall_Inventory_Files"

$OldPath = "/tmp/"+"Firewall_old_Inventory_Files"
$NewPath = "/tmp/"+"Firewall_new_Inventory_Files"
$UpdatePath = "/tmp/"+"Firewall_update_Inventory_Files"

if(!(test-path $DesktopPath))
{
 echo "Directory Not exists"
 echo "----- Creating the Directory -----"
 [system.io.directory]::CreateDirectory($DesktopPath)
}
else
{
 echo "Directory already exists"
}
if(!(test-path $OldPath))
{
 echo "Directory Not exists"
 echo "----- Creating the Directory -----"
 [system.io.directory]::CreateDirectory($OldPath)
}
else
{
 echo "Directory already exists"
}
if(!(test-path $NewPath))
{
 echo "Directory Not exists"
 echo "----- Creating the Directory -----"
 [system.io.directory]::CreateDirectory($NewPath)
}
else
{
 echo "Directory already exists"
}
if(!(test-path $UpdatePath))
{
 echo "Directory Not exists"
 echo "----- Creating the Directory -----"
 [system.io.directory]::CreateDirectory($UpdatePath)
}
else
{
 echo "Directory already exists"
}

$Newfilepath = $NewPath + "\" +"DEV_Non_Production.csv"
$oldfilepath = $OldPath + "\" +"DEV_Non_Production.csv"


try
{
if(Get-ChildItem -path $Newfilepath)
{
move-Item -Path $Newfilepath -Destination $oldfilepath -Force
}
}
catch
{
$_.Exception |out-null
}

$transcriptpath  = $DesktopPath+"/"+"Transcript_$(get-date -f yyyy_MM_dd_HH_mm__ss).txt"

Start-Transcript -Path $transcriptpath


#Code to generate csv filename with timestamp

[string]$filepath = $DesktopPath+"/"+"DEV-nonproduction.csv";
[string]$directory = [System.IO.Path]::GetDirectoryName($filePath);
[string]$strippedFileName = [System.IO.Path]::GetFileNameWithoutExtension($filePath);
[string]$extension = [System.IO.Path]::GetExtension($filePath);
[string]$newFileName = $strippedFileName+"_" + [DateTime]::Now.ToString("yyyy_MM_dd_HH_mm_ss") + $extension;
[string]$filename = [System.IO.Path]::Combine($directory, $newFileName);

#Function call for instances data

$data = Get-Firewall-Data

#Exporting data to CSV

$data = $data |Select-Object -SkipLast 1

$path2 = $ENV:WORKSPACE + "\ayehu\automation\google-cloud-audit-automation\dev\DEV_Non_Production.csv"

$data |Export-Csv -Path $filename -NoTypeInformation

$data |Export-Csv -Path $path2 -NoTypeInformation

$data |Export-Csv -Path $Newfilepath -NoTypeInformation


#Code for Comparsion of Old CSV with New csv to get Updated CSV with changes

$reference=$null


try
{
$reference = Import-Csv -Path $oldfilepath
}

catch 
{
$_.Exception |out-null
}

if($reference)
{

$lookup = $reference | Group-Object -AsHashTable -AsString -Property "Firewall Rule Name"

$results = $null

$results = Import-Csv -Path $Newfilepath  | foreach {
    
$Name = $_."Firewall Rule Name"


Write-host "Looking for $name"

    if ($lookup.ContainsKey($name)  )
    {
     
      
        $ipranges=$Null
        $Network=$Null
        $Direction=$Null
        $Description=$Null
        $Allowed_ports=$Null
        $region=$null
        $requested=$null
        

        $ipranges = ($lookup[$name])."Src_Ranges"
        #$ipranges
        $Network = ($lookup[$name])."Network"
        #$Network
        $Direction = ($lookup[$name])."Direction"
        #$Direction 
        $Description  = ($lookup[$name])."Description"
        #$Description
        $Allowed_ports = ($lookup[$name])."Protocols and Ports"
        #$Allowed_ports 
        $Region = ($lookup[$name])."Region"

        $requested = ($lookup[$name])."Requested By"

          }






    else
    {
      
        $ipranges=$_."Src_Ranges"
        $Network=$_."Network"
        $Direction=$_."Direction"
        $Description = $_."Description"
        $Allowed_ports=$_."Protocols and Ports"
        $region=$_."Region"
        $requested=$_."Requested By"

        


        $_."Src_Ranges"=$null
        $_."Network"=$null
        $_."Direction"=$null
        $_."Description"=$null
        $_."Protocols and Ports"=$null
        $_."Region"=$null
        $_."Requested By"=$Null

        

    }
 
    if ($_."Src_Ranges" -ne $ipranges -or  $_."Network" -ne $Network -or  $_."Direction" -ne $Direction -or $_."Protocols and Ports" -ne $Allowed_ports -or $_."Description" -ne $Description -or $_."Requested By" -ne $requested -or $_."Region" -ne $region -or $_."Src_Ranges" -eq $ipranges -or  $_."Network" -eq $Network -or  $_."Direction" -eq $Direction -or $_."Protocols and Ports" -eq $Allowed_ports -or $_."Description" -eq $Description -or $_."Requested By" -eq $requested -or $_."Region" -eq $region )
    
    {

      if($_."Src_Ranges" -eq $ipranges)
      {
       
       #$_."Src_Ranges"=$null
       $range3=$null

      }
      if($_."Network" -eq $Network)
      {
       $_."Network"=$null

      }

      if($_."Direction" -eq $Direction)
      {
        $_."Direction"=$null

      }
      if($_."Protocols and Ports" -eq $Allowed_ports )
      {
        $ports3=$null

      }
      if($_."Description" -eq $Description )
      {
       $_."Description"=$null

      }
       if($_."Requested By" -eq $requested)
      {
       $_."Requested By"=$null

      }
      if($_."Region" -eq $region )
      {
       $_."Region"=$null

      }
       if($_."Protocols and Ports" -ne $Allowed_ports )
      {
       
       $Allowed_ports_new= $Allowed_ports -split ','
       $_."Protocols and Ports"= $_."Protocols and Ports" -split ','

        $_."Protocols and Ports"= $_."Protocols and Ports" | where {$Allowed_ports_new  -notcontains $_}
        write-host $_."Protocols and Ports"
        $ports = $_."Protocols and Ports" -split ' '
        $ports2=$null
         if($ports.Count -gt '1')
          {
          
                  for($j=0;$j -lt $ports.Count;$j++)
                     {

                       $ports1=$ports[$j]
               
                       $ports2+=$ports1 + ","
                       $ports3=$ports2.TrimEnd(',')
                     }


              

              }

              else
              {
              
              $ports3 = $ports[0]
              


              }
              
             write-host $Ports3

      }
      if($_."Src_Ranges" -ne $ipranges )

      {
        $ipranges1 = $ipranges -split ','
        $_."Src_Ranges"  = $_."Src_Ranges"  -split ','

       
        $_."Src_Ranges"= $_."Src_Ranges" | where {$ipranges1  -notcontains $_}
      


         $range = $_."Src_Ranges" -split ' '
         $range2=$null
         if($range.Count -gt '1')
          {

                  for($k=0;$k -lt $range.Count;$k++)
                     {

                       $range1=$range[$k]
               
                       $range2+=$range1 + ","
                       $range3=$range2.TrimEnd(',')
                     }

              

              }

              else
              {
              
              $range3 = $range[0]
              


              }
             

      }

  

  [PSCustomObject]@{
           
             
            "Firewall Rule Name" = $name
            "Src_Ranges"=$ipranges
            "Protocols and Ports" = $Allowed_ports
            "Network"=$Network
            "Direction"=$Direction
            "Description"=$Description
            "Requested By" = $requested;
		    "Region" = $region;
            


            "New Src_Ranges"=$range3
            "New Protocols and Ports" = $ports3
            "New Network"=$_."Network"
            "New Direction"= $_."Direction"
            "New Description" =$_."Description"
            "New Requested By" = $_."Requested By";
		    "New Region" =  $_."Region";
           
        }
    }
}

#$results


$updatetxtpath = $updatepath + "\" + "updated_DEV-nonproduction.txt" 
$updatecsvpath = $updatepath + "\" + "DEV_Non_Production_Updated.csv"  




$path = $ENV:WORKSPACE + "\ayehu\automation\google-cloud-audit-automation\dev\DEV_Non_Production_Updated.csv"

$results | Export-Csv -Path $path  -NoTypeInformation

$results |Export-Csv -Path $updatecsvpath -NoTypeInformation


}

else
{

write-host "Reference file doesnt exist for comparison"

}

Stop-Transcript
