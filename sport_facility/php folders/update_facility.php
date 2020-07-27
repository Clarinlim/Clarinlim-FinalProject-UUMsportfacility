<?php
error_reporting(0);
include_once("dbconnect.php");
$id = $_POST['id'];
$name = $_POST['name'];
$price = $_POST['price'];
$type = $_POST['type'];
$hours = $_POST['hours'];
//$encoded_string = $_POST["encoded_string"];
//$decoded_string = base64_decode($encoded_string);
//$path = '../images/'.$id.'.png';






$sqlupdate = "UPDATE FACILITY SET NAME = '$name', PRICE = '$price', TYPE = '$type', HOURS = '$hours' WHERE ID = '$id'";


        

if ($conn->query($sqlupdate) === true)
{
    
    //if (file_put_contents($path, $decoded_string))
    echo "success";
}
else
{
    echo "failed";
}


//$conn->query($sqlupdatefacility);
$conn->close();
?>