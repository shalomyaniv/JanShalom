Connect-AzAccount
$tid = (Get-AzTenant).Id
azcopy login --tenant-id $tid  
git clone https://github.com/JanShalom/JanShalom.git
cd ./JanShalom/