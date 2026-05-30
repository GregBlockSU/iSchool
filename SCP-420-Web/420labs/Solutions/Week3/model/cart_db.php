<?php
function count_cart_items($customer_id) {
    global $db;
    $query = 'SELECT COUNT(*) AS item_count
                FROM orders AS ORD
                INNER JOIN orderItems AS ITM ON ITM.OrderID = ORD.OrderID
                WHERE ORD.CustomerID = :customer_id';
    $statement = $db->prepare($query);
    $statement->bindValue(':customer_id', $customer_id);
    $statement->execute();
    $result = $statement->fetchColumn();
    return $result;    
}

function get_order($customer_id) {
    global $db;
    $query = 'SELECT MAX(OrderID) AS OrderID
                FROM orders AS ORD
                WHERE ORD.CustomerID = :customer_id';
    $statement = $db->prepare($query);
    $statement->bindValue(':customer_id', $customer_id);
    $statement->execute();
    $result = $statement->fetchColumn();
    return $result;    
}
function get_cart_items($customer_id) {
    global $db;
    $query = 'SELECT ITM.ItemID, ITM.itemPrice, ITM.discountAmount, ITM.quantity, PRO.productName
                FROM orders AS ORD
                INNER JOIN orderItems AS ITM ON ITM.OrderID = ORD.OrderID
                INNER JOIN products AS PRO ON PRO.ProductID = ITM.ProductID
                WHERE ORD.CustomerID = :customer_id';
    $statement = $db->prepare($query);
    $statement->bindValue(':customer_id', $customer_id);
    $statement->execute();
    return $statement;
}

function add_to_cart($order_id, $product_id, $quantity, $list_price, $discount_amount) {
    global $db;
    $query = 'INSERT INTO orderItems (OrderID, ProductID, quantity, itemPrice, discountAmount)
              VALUES (:order_id, :product_id, :quantity, :list_price, :discount_amount)';
    $statement = $db->prepare($query);
    $statement->bindValue(':order_id', $order_id);
    $statement->bindValue(':product_id', $product_id);
    $statement->bindValue(':quantity', $quantity);
    $statement->bindValue(':list_price', $list_price);
    $statement->bindValue(':discount_amount', $discount_amount);    
    $statement->execute();
    $statement->closeCursor();    
}

?>
