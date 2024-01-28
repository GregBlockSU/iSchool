<?php
// Add an item to the cart
function add_item($key, $quantity, $product) {
    if ($quantity > 0) {
        // If item already exists in cart, update quantity
        if (isset($_SESSION['cart12'][$key])) {
            $quantity += $_SESSION['cart12'][$key]['qty'];
            update_item($key, $quantity);
        } else { 
            // Add item
            $item = [
                'name' => $product['name'],
                'cost' => $product['cost'],
                'qty'  => $quantity,
                'total' => $product['cost'] * $quantity,
            ];
            $_SESSION['cart12'][$key] = $item;
        }
    }
}

// Update an item in the cart
function update_item($key, $quantity) {
    $quantity = (int) $quantity;
    if (isset($_SESSION['cart12'][$key])) {
        // if quantity is less than zero, remove item
        if ($quantity <= 0) {
            unset($_SESSION['cart12'][$key]);
        } else {
            // update item
            $_SESSION['cart12'][$key]['qty'] = $quantity;
            $total = $_SESSION['cart12'][$key]['cost'] *
                     $_SESSION['cart12'][$key]['qty'];
            $_SESSION['cart12'][$key]['total'] = $total;
        }
    }
}

// Get cart subtotal
function get_subtotal() {
    $subtotal = 0;
    foreach ($_SESSION['cart12'] as $item) {
        $subtotal += $item['total'];
    }
    $subtotal_f = number_format($subtotal, 2);
    return $subtotal_f;
}
?>