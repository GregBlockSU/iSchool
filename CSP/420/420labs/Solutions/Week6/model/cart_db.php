<?php
class CartDB {
    public function countCustomerItems($customer_id) {
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

    public function getCustomerOrder($customer_id) {
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

    public function getCustomerOrderItems($customer_id) {
        $db = Database::getDB();
        $query = 'SELECT ITM.OrderID, ITM.ItemID, ITM.ProductID, ITM.quantity
                    FROM orders AS ORD
                    INNER JOIN orderItems AS ITM ON ITM.OrderID = ORD.OrderID
                    WHERE ORD.CustomerID = :customer_id';
        $statement = $db->prepare($query);
        $statement->bindValue(':customer_id', $customer_id);
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

        public function addItemToCart($order_id, $product_id, $quantity, $list_price, $discount_amount) {
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
}
?>
