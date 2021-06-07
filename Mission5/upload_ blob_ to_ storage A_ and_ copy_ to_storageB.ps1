Connect-AzAccount
$tid = (Get-AzTenant).Id
azcopy login --tenant-id $tid  
git clone https://github.com/JanShalom/JanShalom.git
.\create-100-blobs.ps1

#list all storage account names
$RG = read-Host -Prompt 'Please Enter the Resource Group Name '
Get-AzStorageaccount -r $RG |select StorageAccountName

# set the storage account the blobs will be uploaded to
$StorageA= read-Host -Prompt 'Please Enter the Storage A name'
$StorageB= read-Host -Prompt 'Please Enter the Storage B name'

# get StorageA account key
$storageAccountKey = (Get-AzStorageAccountKey -ResourceGroupName $RG -Name $StorageA).Value[0]
# get StorageB account key
$storageAccountKeyB = (Get-AzStorageAccountKey -ResourceGroupName $RG -Name $StorageB).Value[0]

# set storageA context
$ctx = New-AzStorageContext -StorageAccountName $StorageA -StorageAccountKey $storageAccountKey

#create a Container
New-AzStorageContainer -Name "ms-challenge" -Permission Blob -Context $ctx

#can be done via AZcopy command as well
# make ms-challenge container


azcopy make https://$storageA.blob.core.windows.net/ms-challenge


# copy Blobs from local PC to storageA
#azcopy copy  "[Local path]\*" https://[storagA_name].blob.core.windows.net/ms-challenge/--recursive
azcopy copy  "$FolderPath\*" https://$storageA.blob.core.windows.net/ms-challenge

## Copy blobs from storageA to StorageB

# set storageB context
$ctxB=New-AzStorageContext -StorageAccountName $Storageb -StorageAccountKey $storageAccountKey



#obtain Storage B Uri.AbsoluteUri
$bloburi = (Get-AzStorageAccount -ResourceGroupName $RG -Name $StorageA|select PrimaryEndpoints).PrimaryEndpoints.blob
$bloburiB = (Get-AzStorageAccount -ResourceGroupName $RG -Name $StorageB|select PrimaryEndpoints).PrimaryEndpoints.blob

#Generate storage SAS key
$saskey = New-AzStorageAccountSASToken -Service Blob -ResourceType Service,Container,Object -Permission racwdlup -Context $ctx -ExpiryTime (Get-Date).AddDays(+3)
$saskeyB = New-AzStorageAccountSASToken -Service Blob -ResourceType Service,Container,Object -Permission racwdlup -Context $ctxB -ExpiryTime (Get-Date).AddDays(+3)

## Copy blobs from storage A to B
# StorageA uri = $bloburi
# StorageB uri = $bloburiB
# StorageA SAS Keys= $saskey
# StorageB SAS Keys= $saskeyB



azcopy cp "$bloburi/ms-challenge$saskey" "$bloburiB" --recursive
