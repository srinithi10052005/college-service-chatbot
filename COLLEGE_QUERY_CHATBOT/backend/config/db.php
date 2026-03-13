<?php

// Database configuration
$host = "localhost";
$user = "root";
$password = "";          // default XAMPP password is empty
$dbname = "college_db";  // ✅ your database name
$port = 3306;            // MySQL default port

// Create connection
$conn = new mysqli($host, $user, $password, $dbname, $port);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Optional: Uncomment to test connection
// echo "Database Connected Successfully!";

?>