<?php
// Simple API entry point for ERP APP

// Database connection config
$host = 'gateway01.ap-southeast-1.prod.aws.tidbcloud.com'; // หรือ IP ของ TiDB Server
$user = '43Z6ZD5tYBbhK6b.root';      // ชื่อ user ของ TiDB
$pass = 'ILNTM3gaIcpSqTZl';          // รหัสผ่านของ TiDB
$db   = 'org_1';   // ชื่อ database
$port = 4000;        // Default port ของ TiDB

// เชื่อมต่อฐานข้อมูลด้วย MySQLi
$conn = new mysqli($host, $user, $pass, $db, $port);

if ($conn->connect_error) {
    http_response_code(500);
    echo json_encode(['status' => 'error', 'message' => 'Database connection failed', 'error' => $conn->connect_error]);
    exit;
}

// ตัวอย่าง query users
$result = $conn->query('SELECT id, username, email, created_at FROM users');
$users = [];
if ($result) {
    while ($row = $result->fetch_assoc()) {
        $users[] = $row;
    }
}

$conn->close();

header('Content-Type: application/json');
echo json_encode([
    'status' => 'ERP Backend Ready',
    'users' => $users
]);
