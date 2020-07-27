<?php
error_reporting(0);
include_once ("dbconnect.php");
$orderid = $_POST['orderid'];

$sql = "SELECT FACILITY.ID, FACILITY.NAME, FACILITY.PRICE, FACILITY.HOURS, BOOKHISTORY.CHOURS FROM FACILITY INNER JOIN BOOKHISTORY ON BOOKHISTORY.PRODID = FACILITY.ID WHERE  BOOKHISTORY.ORDERID = '$orderid'";

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["bookhistory"] = array();
    while ($row = $result->fetch_assoc())
    {
        $booklist = array();
        $booklist["id"] = $row["ID"];
        $booklist["name"] = $row["NAME"];
        $booklist["price"] = $row["PRICE"];
        $booklist["chours"] = $row["CHOURS"];
        array_push($response["bookhistory"], $booklist);
    }
    echo json_encode($response);
}
else
{
    echo "Book Empty";
}
?>
