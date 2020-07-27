<?php
error_reporting(0);
include_once("dbconnect.php");
$id = $_POST['proid'];

$sqldelete = "DELETE FROM FACILITY WHERE ID = '$id'";
$imageUrl = "../images/'.$id.'.png";

if ($conn->query($sqldelete) === TRUE){
    if(file_exists($imageUrl)){
        unlink($imageUrl);
    }
       echo "success";
}else {
        echo "failed";
}

?>