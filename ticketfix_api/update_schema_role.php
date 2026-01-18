<?php
include("config/db.php");

$query = "ALTER TABLE users ADD COLUMN role VARCHAR(10) NOT NULL DEFAULT 'user'";

if (mysqli_query($conn, $query)) {
    echo "Column 'role' added successfully.<br>";
    // Create a default admin user if not exists
    $admin_user = 'admin';
    $admin_pass = password_hash('admin123', PASSWORD_DEFAULT);
    
    // Check if admin exists
    $check = mysqli_query($conn, "SELECT * FROM users WHERE username = 'admin'");
    if (mysqli_num_rows($check) == 0) {
        $insert = "INSERT INTO users (username, password, role) VALUES ('$admin_user', '$admin_pass', 'admin')";
        if (mysqli_query($conn, $insert)) {
            echo "Default admin user created (admin/admin123).<br>";
        }
    } else {
        // Update existing admin to have role admin
        mysqli_query($conn, "UPDATE users SET role = 'admin' WHERE username = 'admin'");
        echo "Existing admin user updated to role 'admin'.<br>";
    }

} else {
    echo "Error adding 'role': " . mysqli_error($conn) . "<br>";
}
?>
