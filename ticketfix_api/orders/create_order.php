<?php
header("Content-Type: application/json");
include("../config/db.php");

$data = json_decode(file_get_contents("php://input"), true);

$movie_id = $data['movie_id'];
$schedule_id = $data['schedule_id'];
$user_name = $data['user_name'];
$seats = $data['seats'];
$total_price = $data['total_price'];

$query = "INSERT INTO orders (movie_id, schedule_id, user_name, seats, total_price)
          VALUES ('$movie_id', '$schedule_id', '$user_name', '$seats', '$total_price')";

if (mysqli_query($conn, $query)) {
  echo json_encode(["success" => true, "message" => "Tiket berhasil dipesan"]);
} else {
  echo json_encode(["success" => false, "message" => "Gagal memesan tiket"]);
}
