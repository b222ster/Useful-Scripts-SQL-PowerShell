#Declare Credentials
[string]$SqlAuthLoginName = "sa2"
[string]$SqlAuthPassword = "testpassword"
#Declare the connection string
[string]$ConnectionString = "server=KINGDEL;database=master;trusted_connection=false;uid=$SqlAuthLoginName;Password=$SqlAuthPassword;"

#Pass on the connection string and connect to SQL Server
$Connection = New-Object System.Data.SqlClient.SqlConnection
$Connection.ConnectionString = $ConnectionString
$Connection.Open()


#Specify the command
$Command = $Connection.CreateCommand()
$Command.CommandText = "SELECT @@SERVERNAME"

#Execute the command
$reader = $Command.ExecuteReader()
$reader.HasRows
#Close the connection
$Command.Dispose()
$Connection.Close()