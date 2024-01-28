<?php
class CartDB {
    public static function countItems($customer_id) {
        $db = Database::getDB();
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

    public static function getCustomerOrder($customer_id) {
        $db = Database::getDB();
        $query = 'SELECT MAX(OrderID) AS OrderID
                    FROM orders AS ORD
                    WHERE ORD.CustomerID = :customer_id';
        $statement = $db->prepare($query);
        $statement->bindValue(':customer_id', $customer_id);
        $statement->execute();
        $result = $statement->fetchColumn();
        return $result;    
    }

    public static function emptyCart($order_id) {
        $db = Database::getDB();
        $query = 'DELETE  
                    FROM orderItems
                    WHERE OrderID = :order_id';
        $statement = $db->prepare($query);
        $statement->bindValue(':order_id', $order_id);
        $statement->execute();
    }

    public static function getCart($order_id) {
        $db = Database::getDB();
        $query = 'SELECT ITM.OrderID, ITM.ItemID, ITM.ProductID, ITM.quantity
                    FROM orders AS ORD
                    INNER JOIN orderItems AS ITM ON ITM.OrderID = ORD.OrderID
                    WHERE ORD.OrderID = :order_id';
        $statement = $db->prepare($query);
        $statement->bindValue(':order_id', $order_id);
        $statement->execute();
        $rows = $statement->fetchAll();
        $statement->closeCursor();

        $productDB = new ProductDB();

        $orderItems = [];
        foreach ($rows as $row) {
            $product = $productDB->getProduct($row['ProductID']);
            $orderItem = new OrderItem();

            $orderItem->setProduct($product);
            $orderItem->setOrderId($row['OrderID']);
            $orderItem->setItemId($row['ItemID']);
            $orderItem->setQuantity($row['quantity']);

            $orderItems[] = $orderItem;
        }
        return $orderItems;    
    }

    public static function checkItem($order_id, $product_id) {
        $db = Database::getDB();
        $query = 'SELECT COUNT(*) AS item_count
        FROM orders AS ORD
        INNER JOIN orderItems AS ITM ON ITM.OrderID = ORD.OrderID
        WHERE ORD.OrderID = :order_id AND ITM.ProductID = :product_id';
        $statement = $db->prepare($query);
        $statement->bindValue(':order_id', $order_id);
        $statement->bindValue(':product_id', $product_id);
        $statement->execute();
        $result = $statement->fetchColumn();
        return $result;    
    }

    public static function addItemToCart($order_id, $product_id, $quantity, $list_price, $discount_amount) {
        $itemCount = CartDB::checkItem($order_id, $product_id);
        if ($itemCount == 0) {
            CartDB::insertItem($order_id, $product_id, $quantity, $list_price, $discount_amount);
        } else {
            CartDB::updateItem($order_id, $product_id, $quantity);
        }
    }

    public static function insertItem($order_id, $product_id, $quantity, $list_price, $discount_amount) {
        $db = Database::getDB();
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

    public static function updateItem($order_id, $product_id, $quantity) {
        $db = Database::getDB();
        $query = 'UPDATE orderItems
            SET quantity = quantity + :quantity
            WHERE OrderID = :order_id AND ProductID = :product_id';
        $statement = $db->prepare($query);
        $statement->bindValue(':order_id', $order_id);
        $statement->bindValue(':product_id', $product_id);
        $statement->bindValue(':quantity', $quantity);
        $statement->execute();
        $statement->closeCursor();    
    }

    public static function deleteItem($item_id) {
        $db = Database::getDB();
        $query = 'DELETE 
            FROM orderItems
            WHERE ItemID = :item_id';
        $statement = $db->prepare($query);
        $statement->bindValue(':item_id', $item_id);
        $statement->execute();
        $statement->closeCursor();    
    }

}
?>
