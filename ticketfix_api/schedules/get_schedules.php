<?php
header("Content-Type: application/json");
include("../config/db.php");

$query = "SELECT * FROM schedules";
$result = mysqli_query($conn, $query);

$data = [];
while ($row = mysqli_fetch_assoc($result)) {
  $data[] = $row;
}

echo json_encode([
  "success" => true,
  "data" => $data
]);
