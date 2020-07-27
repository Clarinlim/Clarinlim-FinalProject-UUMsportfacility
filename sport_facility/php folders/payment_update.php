<?php
error_reporting(0);
include_once("dbconnect.php");
$userid = $_GET['userid'];
$mobile = $_GET['mobile'];
$amount = $_GET['amount'];
$orderid = $_GET['orderid'];
//$date = $_GET['date'];  

$data = array(
    'id' =>  $_GET['billplz']['id'],
    'paid_at' => $_GET['billplz']['paid_at'] ,
    'paid' => $_GET['billplz']['paid'],
    'x_signature' => $_GET['billplz']['x_signature']
);

$paidstatus = $_GET['billplz']['paid'];
if ($paidstatus=="true"){
    $paidstatus = "Success";
}else{
    $paidstatus = "Failed";
}
$receiptid = $_GET['billplz']['id'];
$signing = '';
foreach ($data as $key => $value) {
    $signing.= 'billplz'.$key . $value;
    if ($key === 'paid') {
        break;
    } else {
        $signing .= '|';
    }
}

$signed= hash_hmac('sha256', $signing, 'S-u0KTyPEbP7Om_HCTTUeEJw');
if ($signed === $data['x_signature']) {
    
    if ($paidstatus == "Success"){
        
        $sqlbook = "SELECT PRODID,CHOURS FROM BOOK WHERE EMAIL ='$userid'";
        $bookresult = $conn->query($sqlbook);
        if($bookresult->num_rows > 0)
        {
            while ($row = $bookresult->fetch_assoc())
            {
            $prodid = $row["PRODID"];
            $ch = $row["CHOURS"];
            //$pr = $row ["PRICE"];
            $sqlinsertbookhistory = "INSERT INTO BOOKHISTORY(EMAIL,ORDERID,BILLID,PRODID,CHOURS) VALUES ('$userid','$orderid','$receiptid','$prodid','$ch')";
            $conn->query($sqlinsertbookhistory);
            
            $selectfacility = "SELECT * FROM FACILITY WHERE ID = '$prodid'";
            $facilityresult = $conn->query($selectfacility);
             if ($facilityresult->num_rows > 0){
                  while ($rowp = $facilityresult->fetch_assoc()){
                    $prhours = $rowp["HOURS"];
                    $prevbooked =$rowp["BOOKED"];
                    $newhours = $prhours - $ch;
                    $newbooked = $prevbooked + $ch;
                    $sqlupdatehours = "UPDATE FACILITY SET HOURS = '$newhours', BOOKED = '$newbooked' WHERE ID = '$prodid'";
                    $conn->query($sqlupdatehours);
                  }
            }
        }
       $sqldeletebook = "DELETE FROM BOOK WHERE EMAIL = '$userid'";
       $sqlinsert = "INSERT INTO PAYMENT(ORDERID,BILLID,USERID,TOTAL) VALUES ('$orderid','$receiptid','$userid','$amount')";   
       
       $conn->query($sqldeletebook);
       $conn->query($sqlinsert);
    }
        echo '<br><br><body><div><h2><br><br><center>RECEIPT</center></h1><table border=1 width=80% align=center><tr><td>Order id</td><td>'.$orderid.'</td></tr><tr><td>Receipt ID</td><td>'.$receiptid.'</td></tr><tr><td>Email to </td><td>'.$userid. ' </td></tr><td>Amount </td><td>RM '.$amount.'</td></tr><tr><td>Payment Status </td><td>'.$paidstatus.'</td></tr><tr><td>Date </td><td>'.date("d/m/Y").'</td></tr><tr><td>Time </td><td>'.date("h:i a").'</td></tr></table><br><p><center>Press back button to return to UUM Sport Facilities</center></p></div></body>';
        //echo $sqlinsertcarthistory;
    } 
        else 
    {
    echo 'Payment Failed!';
    }
}

?>
       
       
