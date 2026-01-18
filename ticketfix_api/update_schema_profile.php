<?php
include("config/db.php");

$query = "ALTER TABLE users ADD COLUMN profile_picture VARCHAR(255) DEFAULT NULL";

if (mysqli_query($conn, $query)) {
    echo "Column profile_picture added successfully";
} else {
    echo "Error adding column: " . mysqli_error($conn);
}
?>
