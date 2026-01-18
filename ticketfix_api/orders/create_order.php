<?php
header("Content-Type: application/json");
include("../config/db.php");

$data = json_decode(file_get_contents("php://input"), true);

$movie_id = $data['movie_id'];
$schedule_id = $data['schedule_id'];
$user_name = $data['user_name'];
$seats = $data['seats'];
$total_price = $data['total_price'];

// Simple validation
if (empty($movie_id) || empty($schedule_id) || empty($user_name) || empty($seats)) {
    echo json_encode(["success" => false, "message" => "Incomplete data"]);
    exit;
}

$stmt = $conn->prepare("INSERT INTO orders (movie_id, schedule_id, user_name, seats, total_price) VALUES (?, ?, ?, ?, ?)");
// s for string, d for double/decimal, i for integer
// movie_id (i), schedule_id (i), user_name (s), seats (s), total_price (d/s)
// total_price in DB is decimal, bind as string is safer mostly if passed as string, or d
$stmt->bind_param("iisss", $movie_id, $schedule_id, $user_name, $seats, $total_price);

if ($stmt->execute()) {
    echo json_encode(["success" => true, "message" => "Order placed successfully"]);
} else {
    echo json_encode(["success" => false, "message" => "Order failed: " . $stmt->error]);
}

$stmt->close();
?>
