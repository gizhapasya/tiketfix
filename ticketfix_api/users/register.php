<?php
include("ticketfix/config/db.php");

$username = $_POST['username'];
$password = password_hash($_POST['password'], PASSWORD_DEFAULT);

$query = "INSERT INTO users (username, password)
          VALUES ('$username', '$password')";

if (mysqli_query($conn, $query)) {
  echo json_encode(["success" => true]);
} else {
  echo json_encode(["success" => false]);
}
