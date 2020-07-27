<?php
error_reporting(0);
include_once ("dbconnect.php");
$email =$_POST['email'];
$prodid =$_POST['prodid'];
$userhours = $_POST['hours'];


$sqlsearch ="SELECT * FROM BOOK WHERE EMAIL = '$email' AND PRODID = '$prodid'";

$result = $conn->query($sqlsearch);
if($result->num_rows > 0){
    while($row = $result->fetch_assoc()){
        $prhours = $row["CHOURS"];
}
$prhours =$prhours + $userhours;
$sqlinsert = "UPDATE BOOK SET CHOURS = '$prhours' WHERE PRODID = '$prodid' AND EMAIL = '$email'";

}else{
    $sqlinsert = "INSERT INTO BOOK(EMAIL,PRODID,CHOURS) VALUES ('$email','$prodid','$userhours')";
}
if($conn->query($sqlinsert) == true)
{
    $sqlhours= "SELECT * FROM BOOK WHERE EMAIL = '$email'";

$resultq = $conn->query($sqlhours);
if ($resultq->num_rows > 0){
    $hours = 0;
    while ($row = $resultq ->fetch_assoc()){
        $hours =$row["CHOURS"] + $hours;
        
    }
}
    $hours = $hours;
    echo"success,".$hours;
}
else
{
    echo"failed";
}
?>


