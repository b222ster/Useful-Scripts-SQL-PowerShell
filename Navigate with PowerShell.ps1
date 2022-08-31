#Get the item path
Get-Item -Path "C:\" 

#Get the Child item of the path
Get-ChildItem -Path "C:\"

#Combine them together
Get-Item -Path "C:\" | Get-ChildItem


