<?php
error_reporting(0);
include_once ("dbconnect.php");
$id = $_POST['id'];
$name  = $_POST['name'];
$price  = $_POST['price'];
$type  = $_POST['type'];
$hours  = $_POST['hours'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);
$booked = '';
$path = '../images/'.$id.'.png';

$sqlinsert = "INSERT INTO FACILITY(ID,NAME,PRICE,TYPE,HOURS,BOOKED) VALUES ('$id','$name','$price','$type','$hours','$booked')";
$sqlsearch = "SELECT * FROM FACILITY WHERE ID='$id'";
$resultsearch = $conn->query($sqlsearch);
if ($resultsearch->num_rows > 0)
{
    echo 'found';
}else{
if ($conn->query($sqlinsert) === true)
{
    if (file_put_contents($path, $decoded_string)){
        echo 'success';
    }else{
        echo 'failed';
    }
}
else
{
    echo "failed";
}    
}


?>