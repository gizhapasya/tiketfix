<?php
header("Content-Type: application/json");
include("../config/db.php");

$code = $_POST['code'] ?? '';

if (empty($code)) {
    echo json_encode(["success" => false, "message" => "Code is required"]);
    exit;
}

// Check if order exists
$stmt = $conn->prepare("SELECT id, status FROM orders WHERE code = ?");
$stmt->bind_param("s", $code);
$stmt->execute();
$result = $stmt->get_result();

if ($row = $result->fetch_assoc()) {
    if ($row['status'] == 'success') {
         echo json_encode(["success" => false, "message" => "Ticket already used/verified"]);
    } else {
         // Update to success
         $update = $conn->prepare("UPDATE orders SET status = 'success' WHERE id = ?");
         $update->bind_param("i", $row['id']);
         if ($update->execute()) {
             echo json_encode(["success" => true, "message" => "Ticket verified successfully!"]);
         } else {
             echo json_encode(["success" => false, "message" => "Update failed"]);
         }
    }
} else {
    echo json_encode(["success" => false, "message" => "Invalid ticket code"]);
}

$stmt->close();
?>
