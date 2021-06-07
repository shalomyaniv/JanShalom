# Create blob folder
$BlobFolderName = Read-Host -Prompt 'Please Enter Folder Name'

#Create blob Folder
New-Item -Path "c:\$BlobFolderName" -ItemType "directory"
$FolderPath = "c:\$BlobFolderName"
New-Item -ItemType "directory" -Path $FolderPath
1..100 | % { New-Item -Path $FolderPath -Name “$_.txt”  -ItemType file}
