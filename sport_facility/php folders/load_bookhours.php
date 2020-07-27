<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];

$sql = "SELECT * FROM BOOK WHERE EMAIL = '$email'";    
$hrs = 0;
 
$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    while ($row = $result->fetch_assoc())
    {
      $hrs = $hrs + $row["CHOURS"];
      
    }
    echo  $hrs;
}
else
{
    echo "0";
}
?>
