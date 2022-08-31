#Variables - details of the connection, stored procedure and parameters
$connectionString = "server='KINGDEL';database='AdventureWorksDW2017';trusted_connection=true;";
$storedProcedureCall = "SELECT * FROM DatabaseLog";
$param1Value = "SomeValue";
 
#SQL Connection - connection to SQL server
$sqlConnection = new-object System.Data.SqlClient.SqlConnection;
$sqlConnection.ConnectionString = $connectionString;
 
#SQL Command - set up the SQL call
$sqlCommand = New-Object System.Data.SqlClient.SqlCommand;
$sqlCommand.Connection = $sqlConnection;
$sqlCommand.CommandText = $storedProcedureCall;
#$parameter = $sqlCommand.Parameters.AddWithValue("@param1",$param1Value);
 
#SQL Adapter - get the results using the SQL Command
$sqlAdapter = new-object System.Data.SqlClient.SqlDataAdapter 
$sqlAdapter.SelectCommand = $sqlCommand
$dataSet = new-object System.Data.Dataset
$recordCount = $sqlAdapter.Fill($dataSet) 
 
#Close SQL Connection
$sqlConnection.Close();
 
#Get single table from dataset
$data = $dataSet.Tables[0]
 
#File creation variables
$folderLocation = "C:\Users\Kingdel\OneDrive\Desktop\bidata\Extract Procedures Demo";

#Loop through each row of data and create a new file
#The dataset contains a column named FileName that I am using for the name of the file
    foreach($row in $data)
    { 
        $fullFileName = $folderLocation + $row.Object  +" - " + $row.Event +" ("+$row.DatabaseLogID + ").sql"
        $newFile = New-Item $fullFileName -ItemType file -Value $row.TSQL -Force
    }
