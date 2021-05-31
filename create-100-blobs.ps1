$source = Read-Host -Prompt 'Please Enter the folder full path to which the blobs will be created in '
1..100 | % { New-Item -Path $source -Name “$_.txt”  -ItemType file}
