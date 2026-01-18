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

// Generate unique ticket code (e.g., TIX-TIMESTAMP-RANDOM)
$code = "TIX-" . time() . "-" . rand(1000, 9999);
$status = "pending"; // Initial status is pending

$stmt = $conn->prepare("INSERT INTO orders (movie_id, schedule_id, user_name, seats, total_price, code, status) VALUES (?, ?, ?, ?, ?, ?, ?)");
// s for string, d for double/decimal, i for integer
// movie_id (i), schedule_id (i), user_name (s), seats (s), total_price (d/s), code (s), status (s)
$stmt->bind_param("iisssss", $movie_id, $schedule_id, $user_name, $seats, $total_price, $code, $status);

if ($stmt->execute()) {
    echo json_encode(["success" => true, "message" => "Order placed successfully"]);
} else {
    echo json_encode(["success" => false, "message" => "Order failed: " . $stmt->error]);
}

$stmt->close();
?>
