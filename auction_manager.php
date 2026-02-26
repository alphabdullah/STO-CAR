<?php
// ==========================================
// DATABASE CONFIGURATION
// ==========================================
$host = "127.0.0.1"; 
$dbname = "u600298837_stoappgroup";
$username = "u600298837_stoappgroup";
$password = "Stoappgroup@123";
$tableName = "auctions"; 

// Initialize PDO Connection
try {
    $dsn = "mysql:host=$host;dbname=$dbname;charset=utf8mb4";
    $options = [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES   => false,
    ];
    $pdo = new PDO($dsn, $username, $password, $options);
} catch (\PDOException $e) {
    die("Database Connection Failed: " . $e->getMessage());
}

// Get messages from URL (for Post/Redirect/Get pattern)
$message = $_GET['message'] ?? "";
$status = $_GET['status'] ?? "";

// ==========================================
// HANDLE FORM SUBMISSION (INSERT)
// ==========================================
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['action']) && $_POST['action'] == 'add_auction') {
    
    $title = $_POST['title'] ?? '';
    $slug = strtolower(trim(preg_replace('/[^A-Za-z0-9-]+/', '-', $title))) . '-' . uniqid();
    $description = $_POST['description'] ?? '';
    $car_make = $_POST['car_make'] ?? '';
    $car_model = $_POST['car_model'] ?? '';
    $car_year = $_POST['car_year'] ?? date('Y');
    $car_mileage = $_POST['car_mileage'] ?? 0;
    $car_color = $_POST['car_color'] ?? '';
    $car_condition = $_POST['car_condition'] ?? 'good';
    $car_transmission = $_POST['car_transmission'] ?? 'Automatic';
    $car_fuel_type = $_POST['car_fuel_type'] ?? 'Petrol';
    $starting_bid = $_POST['starting_bid'] ?? 0;
    $bid_increment = $_POST['bid_increment'] ?? 100;
    
    $uploadDir = 'uploads/auctions/';
    if (!is_dir($uploadDir)) {
        mkdir($uploadDir, 0777, true);
    }
    
    $featured_image = null;
    if (isset($_FILES['featured_image']) && $_FILES['featured_image']['error'] === UPLOAD_ERR_OK) {
        $fileName = time() . '_' . preg_replace("/[^a-zA-Z0-9.-]/", "_", basename($_FILES['featured_image']['name']));
        $targetPath = $uploadDir . $fileName;
        if (move_uploaded_file($_FILES['featured_image']['tmp_name'], $targetPath)) {
            $featured_image = $targetPath;
        }
    }

    $images_array = [];
    if (isset($_FILES['images_files']) && !empty($_FILES['images_files']['name'][0])) {
        foreach ($_FILES['images_files']['name'] as $key => $name) {
            if ($_FILES['images_files']['error'][$key] === UPLOAD_ERR_OK) {
                $fileName = time() . '_' . $key . '_' . preg_replace("/[^a-zA-Z0-9.-]/", "_", basename($name));
                $targetPath = $uploadDir . $fileName;
                if (move_uploaded_file($_FILES['images_files']['tmp_name'][$key], $targetPath)) {
                    $images_array[] = $targetPath;
                }
            }
        }
    }
    $images_json = !empty($images_array) ? json_encode($images_array, JSON_UNESCAPED_SLASHES) : null;

    try {
        $sql = "INSERT INTO $tableName (
            title, slug, description, car_make, car_model, car_year, car_mileage, 
            car_color, car_condition, car_transmission, car_fuel_type, starting_bid, 
            bid_increment, featured_image, images, created_by, status, start_time, end_time, 
            created_at, updated_at
        ) VALUES (
            :title, :slug, :description, :car_make, :car_model, :car_year, :car_mileage,
            :car_color, :car_condition, :car_transmission, :car_fuel_type, :starting_bid,
            :bid_increment, :featured_image, :images, 1, 'live', NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY), 
            NOW(), NOW()
        )";
        
        $stmt = $pdo->prepare($sql);
        $stmt->execute([
            ':title' => $title,
            ':slug' => $slug,
            ':description' => $description,
            ':car_make' => $car_make,
            ':car_model' => $car_model,
            ':car_year' => $car_year,
            ':car_mileage' => $car_mileage,
            ':car_color' => $car_color,
            ':car_condition' => $car_condition,
            ':car_transmission' => $car_transmission,
            ':car_fuel_type' => $car_fuel_type,
            ':starting_bid' => $starting_bid,
            ':bid_increment' => $bid_increment,
            ':featured_image' => $featured_image,
            ':images' => $images_json
        ]);

        // SUCCESS REDIRECT (Prevents resubmission on reload)
        header("Location: " . $_SERVER['PHP_SELF'] . "?status=success&message=" . urlencode("Auction record added successfully!"));
        exit();
        
    } catch (\PDOException $e) {
        $status = "error";
        $message = "Data Entry Failed: " . $e->getMessage();
    }
}

// FETCH AUCTIONS
$auctions = [];
try {
    $stmt = $pdo->query("SELECT id, title, car_make, car_model, car_year, starting_bid, current_bid, status, end_time FROM $tableName ORDER BY id DESC");
    $auctions = $stmt->fetchAll();
} catch (\PDOException $e) {}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Auctions Manager | STO App</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-dark: #09090b;
            --bg-card: rgba(24, 24, 27, 0.6);
            --border-color: rgba(255, 255, 255, 0.1);
            --accent-main: #3b82f6; 
            --accent-gradient: linear-gradient(135deg, #3b82f6, #8b5cf6);
            --text-main: #f8fafc;
            --text-muted: #94a3b8;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Plus Jakarta Sans', sans-serif; }
        body {
            background-color: var(--bg-dark);
            color: var(--text-main);
            min-height: 100vh;
            background-image: radial-gradient(circle at top right, rgba(59, 130, 246, 0.15), transparent 40%);
            padding: 2rem 1rem;
        }
        .dashboard-container { max-width: 1200px; margin: 0 auto; display: grid; grid-template-columns: 1fr; gap: 2rem; }
        @media (min-width: 968px) { .dashboard-container { grid-template-columns: 400px 1fr; } }
        .glass-card { background: var(--bg-card); backdrop-filter: blur(16px); border: 1px solid var(--border-color); border-radius: 24px; padding: 2rem; }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; }
        .form-group { margin-bottom: 1.2rem; grid-column: span 2; }
        .form-group.half { grid-column: span 1; }
        .form-group label { display: block; margin-bottom: 0.5rem; font-size: 0.85rem; color: #cbd5e1; }
        .form-group input, .form-group textarea, .form-group select {
            width: 100%; background: rgba(0, 0, 0, 0.3); border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 12px; padding: 0.8rem 1rem; color: #fff; outline: none; transition: all 0.3s ease;
        }
        .form-group input:focus { border-color: var(--accent-main); }
        .btn-submit { grid-column: span 2; width: 100%; background: var(--accent-gradient); color: white; border: none; padding: 1rem; border-radius: 12px; font-weight: 600; cursor: pointer; }
        .alert { padding: 1rem; border-radius: 12px; margin-bottom: 1.5rem; font-size: 0.9rem; }
        .alert.success { background: rgba(16, 185, 129, 0.1); border: 1px solid rgba(16, 185, 129, 0.2); color: #34d399; }
        .alert.error { background: rgba(239, 68, 68, 0.1); border: 1px solid rgba(239, 68, 68, 0.2); color: #f87171; }
        .table-responsive { overflow-x: auto; }
        .data-table { width: 100%; border-collapse: collapse; white-space: nowrap; }
        .data-table th { padding: 1rem; color: var(--text-muted); border-bottom: 1px solid var(--border-color); }
        .data-table td { padding: 1rem; border-bottom: 1px solid rgba(255, 255, 255, 0.05); }
        .status-badge { padding: 0.3rem 0.8rem; border-radius: 20px; font-size: 0.75rem; }
        .status-live { background: rgba(16, 185, 129, 0.15); color: #34d399; }
    </style>
</head>
<body>
<div class="dashboard-container">
    <div class="glass-card">
        <h2>Add Auction</h2>
        <?php if ($message): ?>
            <div class="alert <?= htmlspecialchars($status) ?>"><?= htmlspecialchars($message) ?></div>
        <?php endif; ?>
        <form method="POST" enctype="multipart/form-data">
            <input type="hidden" name="action" value="add_auction">
            <div class="form-grid">
                <div class="form-group"><label>Title*</label><input type="text" name="title" required></div>
                <div class="form-group"><label>Desc*</label><textarea name="description" required></textarea></div>
                <div class="form-group half"><label>Make*</label><input type="text" name="car_make" required></div>
                <div class="form-group half"><label>Model*</label><input type="text" name="car_model" required></div>
                <div class="form-group half"><label>Year</label><input type="number" name="car_year" value="2024"></div>
                <div class="form-group half"><label>Price*</label><input type="number" name="starting_bid" required></div>
                <div class="form-group"><label>Main Image</label><input type="file" name="featured_image" accept="image/*"></div>
                <button type="submit" class="btn-submit">Publish Auction</button>
            </div>
        </form>
    </div>
    <div class="glass-card">
        <h2>History</h2>
        <div class="table-responsive">
            <table class="data-table">
                <thead><tr><th>ID</th><th>Car</th><th>Year</th><th>Status</th><th>Price</th></tr></thead>
                <tbody>
                    <?php if (count($auctions) > 0): foreach($auctions as $row): ?>
                        <tr>
                            <td>#<?= $row['id'] ?></td>
                            <td><?= htmlspecialchars($row['car_make'].' '.$row['car_model']) ?></td>
                            <td><?= $row['car_year'] ?></td>
                            <td><span class="status-badge status-live"><?= $row['status'] ?></span></td>
                            <td>$<?= number_format($row['starting_bid'], 2) ?></td>
                        </tr>
                    <?php endforeach; else: ?>
                        <tr><td colspan="5">No data</td></tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
