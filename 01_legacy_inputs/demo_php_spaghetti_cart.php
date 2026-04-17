<?php
// LEGACY E-COMMERCE CART (PHP 5.2)
mysql_connect("localhost", "root", "password");
mysql_select_db("shop_db");

$userId = $_GET['user_id']; // КРИТИЧНА ВРАЗЛИВІСТЬ: SQL Injection
$query = mysql_query("SELECT total_price, is_vip FROM carts WHERE user_id = " . $userId);
$cart = mysql_fetch_assoc($query);

$total = $cart['total_price'];
$discount = 0;

// Бізнес-логіка прямо у файлі відображення
if ($cart['is_vip'] == 1) {
    $discount = 0.15; // 15% VIP знижка
} elseif ($total > 1000) {
    $discount = 0.05; // 5% звичайна знижка
}

$finalPrice = $total - ($total * $discount);

// Оновлення БД та вивід HTML в одному місці
mysql_query("UPDATE carts SET final_price = " . $finalPrice . " WHERE user_id = " . $userId);

echo "<h1>Your Total: $" . $finalPrice . "</h1>";
?>