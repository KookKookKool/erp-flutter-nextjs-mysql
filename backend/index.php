<?php
// Simple API entry point for ERP APP

// Database connection config
$host = 'gateway01.ap-southeast-1.prod.aws.tidbcloud.com'; // หรือ IP ของ TiDB Server
$user = '43Z6ZD5tYBbhK6b.root';      // ชื่อ user ของ TiDB
$pass = 'ILNTM3gaIcpSqTZl';          // รหัสผ่านของ TiDB
$port = 4000;        // Default port ของ TiDB

// รับ org_code จาก query string (หรือ header/body ได้ในอนาคต)
$org_code = isset($_GET['org_code']) ? $_GET['org_code'] : '';
if (!$org_code) {
    http_response_code(400);
    echo json_encode(['status' => 'error', 'message' => 'Missing org_code']);
    exit;
}

// ตรวจสอบรูปแบบ org_code (เบื้องต้น: อนุญาตเฉพาะ a-zA-Z0-9_)
if (!preg_match('/^[a-zA-Z0-9_]+$/', $org_code)) {
    http_response_code(400);
    echo json_encode(['status' => 'error', 'message' => 'Invalid org_code']);
    exit;
}

// กำหนดชื่อ database ตาม org_code (ตัวอย่าง: org_xxx)
$db = 'org_' . $org_code;

// เชื่อมต่อฐานข้อมูลด้วย MySQLi
$conn = new mysqli($host, $user, $pass, $db, $port);
if ($conn->connect_error) {
    http_response_code(500);
    echo json_encode(['status' => 'error', 'message' => 'Database connection failed', 'error' => $conn->connect_error]);
    exit;
}

header('Content-Type: application/json');

$action = isset($_GET['action']) ? $_GET['action'] : '';

switch ($action) {
    case 'employee':
        // Query employee (users) data
        $result = $conn->query('SELECT id, username, email, created_at FROM users');
        $users = [];
        if ($result) {
            while ($row = $result->fetch_assoc()) {
                $users[] = $row;
            }
        }
        echo json_encode([
            'status' => 'ok',
            'employees' => $users
        ]);
        break;
    default:
        echo json_encode([
            'status' => 'ERP Backend Ready'
        ]);
        break;
}

$conn->close();
