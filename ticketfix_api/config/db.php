<?php

header('Content-Type: application/json');

$host = "localhost";
$user = "root";
$pass = ""; 
$db   = "ticketfix_db2";
$port = 3307; 
$conn = mysqli_connect($host, $user, $pass, $db, $port);


if (!$conn) {
    echo json_encode([
        "success" => false,
        "message" => "Database connection failed",
        "error"   => mysqli_connect_error()
    ]);
    exit;
}
// echo json_encode(["success" => true, "message" => "Koneksi Berhasil!"]);
?>