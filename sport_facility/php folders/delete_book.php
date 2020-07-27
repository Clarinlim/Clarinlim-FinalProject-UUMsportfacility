<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$prodid = $_POST['prodid'];

if(isset($_POST['prodid'])){
        $sqldelete = "DELETE FROM BOOK WHERE EMAIL = '$email' AND PRODID='$prodid'";
}else{
    $sqldelete = "DELETE FROM BOOK WHERE EMAIL = '$email'";
}

if($conn->query($sqldelete) == true)
{
    $sqlhours= "SELECT * FROM BOOK WHERE EMAIL = '$email'";
    $resultq = $conn->query($sqlhours);
    if ($resultq->num_rows > 0){
        $hours = 0;
        while ($row = $resultq ->fetch_assoc()){
            $hours =$row["CHOURS"] + $hours;
        }
         $hours = $hours;
         echo"success,".$hours;
    } else {
        echo "success,0";
    }
    
}else {
        echo "failed";
    }
?>