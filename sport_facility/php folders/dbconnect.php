<?php
$servername = "localhost";
$username = "lilbeara_lim_clarin";
$password = "HWTA94hmHyYPA7b";
$dbname = "lilbeara_uumsportfacilities";

$conn = new mysqli($servername,$username,$password,$dbname);
if ($conn -> connect_error){
    die("Connection failed:".$conn ->connect_error);
    
}
?>
