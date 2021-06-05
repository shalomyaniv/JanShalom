$FolderPath = Read-Host -Prompt 'Please Enter the new folder full path and name to which the blobs will be created in'
New-Item -ItemType "directory" -Path $FolderPath
1..100 | % { New-Item -Path $FolderPath -Name “$_.txt”  -ItemType file}
