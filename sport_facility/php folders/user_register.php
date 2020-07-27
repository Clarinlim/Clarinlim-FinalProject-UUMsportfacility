<?php
error_reporting(0);
include_once ("dbconnect.php");
$name =$_POST['name'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$password = sha1($_POST['password']);

$sqlinsert ="INSERT INTO USER(NAME,EMAIL,PHONE, CREDIT,PASSWORD,VERIFY) VALUES('$name','$email','$phone','0','$password','1')";

if($conn->query($sqlinsert) === true)
{
    sendEmail($email);
    echo "success";
    
}
else
{
    echo "failed";
    
}

function sendEmail($useremail){
    $to = $useremail;
    $subject ='Verification for UUM Sport Facilities' ;
    $message = 'http://lilbearandlilpanda.com/uumsportfacilities/php/verify.php?email='.$useremail;
    $headers ='From:noreply@uumsportfacilities.com' . "\r\n".
    'Reply-To: '.$useremail."\r\n".
    'X-Mailer: PHP/' . phpversion();
    mail($to,$subject,$message,$headers);
}
?>