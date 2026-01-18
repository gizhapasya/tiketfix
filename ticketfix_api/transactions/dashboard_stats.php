<?php
header("Content-Type: application/json");
include("../config/db.php");

$username = $_GET['username'] ?? '';

if (empty($username)) {
    echo json_encode(["success" => false, "message" => "Username required"]);
    exit;
}

// 1. Total Tickets per Movie (Bar Chart Data)
$query1 = "
    SELECT m.title, COUNT(o.id) as total_tickets
    FROM orders o
    JOIN movies m ON o.movie_id = m.id
    WHERE o.user_name = ?
    GROUP BY m.title
";

$stmt = $conn->prepare($query1);
$stmt->bind_param("s", $username);
$stmt->execute();
$res1 = $stmt->get_result();
$tickets_per_movie = [];
while ($row = $res1->fetch_assoc()) {
    $tickets_per_movie[$row['title']] = $row['total_tickets'];
}

// 2. Total Expenditure per Month (Line Chart Data)
// Assuming MySQL functions MONTHNAME and MONTH. Adjust if strict mode issues arise.
$query2 = "
    SELECT MONTHNAME(o.order_date) as month_name, SUM(o.total_price) as total_spent
    FROM orders o
    WHERE o.user_name = ?
    GROUP BY YEAR(o.order_date), MONTH(o.order_date)
    ORDER BY YEAR(o.order_date), MONTH(o.order_date)
    LIMIT 6 -- Last 6 months
";

$stmt2 = $conn->prepare($query2);
$stmt2->bind_param("s", $username);
$stmt2->execute();
$res2 = $stmt2->get_result();
$expenditure_per_month = [];
while ($row = $res2->fetch_assoc()) {
    $expenditure_per_month[] = [
        "month" => $row['month_name'],
        "total" => (float)$row['total_spent']
    ];
}

echo json_encode([
    "success" => true,
    "data" => [
        "tickets_per_movie" => $tickets_per_movie,
        "expenditure_history" => $expenditure_per_month
    ]
]);

$stmt->close();
$stmt2->close();
?>
