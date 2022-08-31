#Get a server object which corresponds to the default instance
Set-Location SQLSERVER:\SQL\
$srv = get-item default 


#Create a new database
$db = New-Object -TypeName microsoft.sqlserver.management.smo.database
$db.Create()

#Reference the database and display the date when it was created
$db = $srv.Databases["Test3"]
$db.CreateDate

#Drop the database
$db.Drop()