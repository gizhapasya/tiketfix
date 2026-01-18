<?php
header("Content-Type: application/json");
include("../config/db.php");

$movie_id = $_GET['movie_id'] ?? null;

if ($movie_id) {
    // Prevent SQL Injection using prepared statement
    $stmt = $conn->prepare("SELECT * FROM schedules WHERE movie_id = ? ORDER BY start_time ASC");
    $stmt->bind_param("i", $movie_id);
    $stmt->execute();
    $result = $stmt->get_result();
} else {
    $query = "SELECT * FROM schedules ORDER BY start_time ASC";
    $result = mysqli_query($conn, $query);
}

$data = [];
while ($row = mysqli_fetch_assoc($result)) {
    $data[] = $row;
}

echo json_encode([
    "success" => true,
    "data" => $data
]);
?>
