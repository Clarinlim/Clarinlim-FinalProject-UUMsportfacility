<?php
error_reporting(0);
include_once("dbconnect.php");
$type = $_POST['type'];
$name = $_POST['name'];

if(isset($type)){
    if($type == "All"){
        $sql = "SELECT * FROM FACILITY ";
    }else{
        $sql = "SELECT * FROM FACILITY WHERE TYPE = '$type'";
        
    }
}else{
    $sql = "SELECT * FROM FACILITY ";
}
if (isset($name)){
    $sql = "SELECT * FROM FACILITY WHERE NAME LIKE '%$name%'";
    
}
$result = $conn->query($sql);

if($result->num_rows > 0)
{
   $response["facility"] =array();
   while($row = $result->fetch_assoc())
   {
      $facilitylist = array();
      $facilitylist["id"]= $row["ID"];
      $facilitylist["name"]= $row["NAME"];
      $facilitylist["price"]= $row["PRICE"];
      $facilitylist["type"]= $row["TYPE"];
      $facilitylist["hours"]= $row["HOURS"];
      array_push($response["facility"], $facilitylist);
   }
   echo json_encode($response);
}
else
{
    echo "nodata";
}
?>
