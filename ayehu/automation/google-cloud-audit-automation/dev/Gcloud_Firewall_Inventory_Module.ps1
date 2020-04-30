function Get-Firewall-Data()
{

#Array Declaration

$data = @()

#Project ID

$project= "neon-shelter-262506" 

#Cmdlet to get Firewall rule names

$Namelist = gcloud compute firewall-rules list   --project $project --format="csv(name)"|Select-Object -Skip 1

#Iterate over Firewall rules

for($i=0;$i -lt $Namelist.count;$i++)
 {
    
    
    $ipranges = gcloud compute firewall-rules describe $Namelist[$i]  --project $project  --format="csv(sourceRanges.list():label=SRC_RANGES)" | Select-Object -Skip 1
    $Network = ((gcloud compute firewall-rules describe $Namelist[$i]  --project $project  --format="csv(network)") -split '/')[-1]
    $Direction = gcloud compute firewall-rules describe $Namelist[$i]  --project $project  --format="csv(direction)" |Select-Object -Skip 1
    $Description = gcloud compute firewall-rules describe $Namelist[$i]  --project $project  --format="csv(description)" |Select-Object -Skip 1
    $Allowed_ports = gcloud compute firewall-rules describe $Namelist[$i]  --project $project --format="csv(allowed[].map().firewall_rule().list())" |Select-Object -Skip 1
     
     #Iterate over Source IP Ranges

   
        #Hash Table Declaration

        $hashdata=[ordered]@{


        "Firewall Rule Name" = $Namelist[$i];
        "Src_Ranges" = $ipranges -replace ('"','');
        "Protocols and Ports" = $Allowed_ports  -replace ('"','');
        "Requested By" = "shan";
        "Region" = "US";
        "Network" = $Network;
        "Direction" = $Direction;
        "Description" = $Description;
        
    
         }

        $Obj = New-Object PSObject -Property $hashdata
        $data += $Obj
            
       }
return $data

}
