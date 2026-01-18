<?php
include("config/db.php");

$query1 = "ALTER TABLE orders ADD COLUMN code VARCHAR(50) NOT NULL DEFAULT ''";
$query2 = "ALTER TABLE orders ADD COLUMN status VARCHAR(20) NOT NULL DEFAULT 'success'";

if (mysqli_query($conn, $query1)) {
    echo "Column 'code' added successfully.<br>";
} else {
    echo "Error adding 'code': " . mysqli_error($conn) . "<br>";
}

if (mysqli_query($conn, $query2)) {
    echo "Column 'status' added successfully.<br>";
} else {
    echo "Error adding 'status': " . mysqli_error($conn) . "<br>";
}
?>
