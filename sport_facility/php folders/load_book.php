<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];

if (isset($email)){
   $sql = "SELECT FACILITY.ID, FACILITY.NAME, FACILITY.PRICE, FACILITY.HOURS,  BOOK.CHOURS FROM FACILITY INNER JOIN BOOK ON BOOK.PRODID = FACILITY.ID WHERE BOOK.EMAIL = '$email'";
}

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["book"] = array();
    while ($row = $result->fetch_assoc())
    {
        $booklist = array();
        $booklist["id"] = $row["ID"];
        $booklist["name"] = $row["NAME"];
        $booklist["price"] = $row["PRICE"];
        $booklist["hours"] = $row["HOURS"];
        $booklist["chours"] = $row["CHOURS"];
         
        $booklist["yourprice"] = round(doubleval($row["PRICE"])*(doubleval($row["CHOURS"])),2)."";
        array_push($response["book"], $booklist);
    }
    echo json_encode($response);
}
else
{
    echo "Book Empty";
}
?>


