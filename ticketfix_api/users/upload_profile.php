<?php
header("Content-Type: application/json");
include("../config/db.php");

$username = $_POST['username'] ?? '';

if (empty($username)) {
    echo json_encode(["success" => false, "message" => "Username required"]);
    exit;
}

if (!isset($_FILES['image'])) {
    echo json_encode(["success" => false, "message" => "No image uploaded"]);
    exit;
}

$target_dir = "../uploads/profiles/";
if (!file_exists($target_dir)) {
    mkdir($target_dir, 0777, true);
}

$file_extension = strtolower(pathinfo($_FILES["image"]["name"], PATHINFO_EXTENSION));
// Sanitize username for filename
$safe_username = preg_replace("/[^a-zA-Z0-9]/", "", $username);
$new_filename = $safe_username . "_" . time() . "." . $file_extension;
$target_file = $target_dir . $new_filename;

// Check file size (limit to 5MB)
if ($_FILES["image"]["size"] > 5000000) {
    echo json_encode(["success" => false, "message" => "Sorry, your file is too large."]);
    exit;
}

// Allow certain file formats
if($file_extension != "jpg" && $file_extension != "png" && $file_extension != "jpeg"
&& $file_extension != "gif" ) {
    echo json_encode(["success" => false, "message" => "Sorry, only JPG, JPEG, PNG & GIF files are allowed."]);
    exit;
}

// Check if image file is a actual image or fake image
$check = getimagesize($_FILES["image"]["tmp_name"]);
if($check === false) {
    echo json_encode(["success" => false, "message" => "File is not an image."]);
    exit;
}

if (move_uploaded_file($_FILES["image"]["tmp_name"], $target_file)) {
    // Update database
    // Store relative path or full URL. Storing relative path 'uploads/profiles/filename' is usually better/flexible.
    $db_path = "uploads/profiles/" . $new_filename;
    
    $stmt = $conn->prepare("UPDATE users SET profile_picture = ? WHERE username = ?");
    $stmt->bind_param("ss", $db_path, $username);
    
    if ($stmt->execute()) {
         echo json_encode([
             "success" => true, 
             "message" => "Profile picture updated",
             "data" => ["profile_url" => $db_path]
         ]);
    } else {
         echo json_encode(["success" => false, "message" => "Database update failed: " . $stmt->error]);
    }
    $stmt->close();
} else {
    echo json_encode(["success" => false, "message" => "Sorry, there was an error uploading your file."]);
}
?>
