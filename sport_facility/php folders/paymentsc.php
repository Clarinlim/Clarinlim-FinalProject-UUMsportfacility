<?php
error_reporting(0);
include_once("dbconnect.php");
$userid = $_POST['userid'];
$amount = $_POST['amount'];
$orderid = $_POST['orderid'];
$newcr = $_POST['newcr'];
$receiptid ="storecr";

 //$sqlbook ="SELECT BOOK.PRODID, BOOK.CHOURS, FACILITY.PRICE FROM BOOK INNER //JOIN FACILITY ON BOOK.PRODID = FACILITY.ID WHERE BOOK.EMAIL = '$userid'";
 $sqlbook = "SELECT PRODID,CHOURS FROM BOOK WHERE EMAIL ='$userid'";
        $bookresult = $conn->query($sqlbook);
        if ($bookresult->num_rows > 0)
        {
        while ($row = $bookresult->fetch_assoc())
        {
            $prodid = $row["PRODID"];
            $ch = $row["CHOURS"]; 
            //$pr = $row["PRICE"];
            $sqlinsertbookhistory = "INSERT INTO BOOKHISTORY(EMAIL,ORDERID,BILLID,PRODID,CHOURS) VALUES ('$userid','$orderid','$receiptid','$prodid','$ch')";
            $conn->query($sqlinsertbookhistory);
            
            $selectfacility = "SELECT * FROM FACILITY WHERE ID = '$prodid'";
            $facilityresult = $conn->query($selectfacility);
             if ($facilityresult->num_rows > 0){
                  while ($rowp = $facilityresult->fetch_assoc()){
                    $prhours = $rowp["HOURS"];
                    $prevbooked = $rowp["BOOKED"];
                    $newhours = $prhours - $ch; //quantity in store - quantity ordered by user
                    $newbooked = $prevbooked + $ch;
                    $sqlupdatehours = "UPDATE FACILITY SET HOURS = '$newhours', BOOKED = '$newbooked' WHERE ID = '$prodid'";
                    $conn->query($sqlupdatehours);
                  }
             }
        }
        
       $sqldeletebook = "DELETE FROM BOOK WHERE EMAIL = '$userid'";
       $sqlinsert = "INSERT INTO PAYMENT(ORDERID,BILLID,USERID,TOTAL) VALUES ('$orderid','$receiptid','$userid','$amount')";
        $sqlupdatecredit = "UPDATE USER SET CREDIT = '$newcr' WHERE EMAIL = '$userid'";
        
       $conn->query($sqldeletebook);
       $conn->query($sqlinsert);
       $conn->query($sqlupdatecredit);
       echo "success" ;
       
        }else{
            echo "failed";
        }

?>