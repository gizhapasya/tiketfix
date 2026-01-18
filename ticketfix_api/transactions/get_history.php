<?php
header("Content-Type: application/json");
include("../config/db.php");

$username = $_GET['username'] ?? '';

if (empty($username)) {
    echo json_encode(["success" => false, "message" => "Username is required"]);
    exit;
}

$query = "
    SELECT o.id, o.seats, o.total_price, o.order_date, m.title, m.poster_url, s.studio_name, s.start_time
    FROM orders o
    JOIN movies m ON o.movie_id = m.id
    JOIN schedules s ON o.schedule_id = s.id
    WHERE o.user_name = ?
    ORDER BY o.order_date DESC
";

$stmt = $conn->prepare($query);
$stmt->bind_param("s", $username);
$stmt->execute();
$result = $stmt->get_result();

$data = [];
while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode([
    "success" => true,
    "data" => $data
]);

$stmt->close();
?>
