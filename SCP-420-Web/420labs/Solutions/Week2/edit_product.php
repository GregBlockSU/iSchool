<?php

   // Get the product data
   $action = filter_input(INPUT_POST, 'action');
   if ($action == NULL) {
       $action = filter_input(INPUT_GET, 'action');
       if ($action == NULL) {
           $action = 'index';
       }
   } 

   // Validate inputs
    if ($action == 'edit_product') {
    $product_id = filter_input(INPUT_POST, 'product_id', FILTER_VALIDATE_INT);   
    $category_id = filter_input(INPUT_POST, 'category_id', FILTER_VALIDATE_INT);   
    
    if ($product_id == NULL || $product_id == FALSE) {
        $error = 'Missing or incorrect product id.';
        include('error.php');
    } else {
        $productCode = filter_input(INPUT_POST, 'productCode');
        $productName = filter_input(INPUT_POST, 'productName');
        $listPrice = filter_input(INPUT_POST, 'listPrice', FILTER_VALIDATE_FLOAT);
        require_once('database.php');

        // Add the product to the database  
        $query = 'UPDATE products
                    SET categoryID = :category_id,
                        productCode = :productCode,
                        productName = :productName,
                        listPrice = :listPrice
                    WHERE   productID = :product_id';
        $statement = $db->prepare($query);
        $statement->bindValue(':product_id', $product_id);
        $statement->bindValue(':category_id', $category_id);
        $statement->bindValue(':productCode', $productCode);
        $statement->bindValue(':productName', $productName);
        $statement->bindValue(':listPrice', $listPrice);
        $statement->execute();
        $statement->closeCursor();
    
        // Display the Product List page
        include('index.php');       
    }
}
?>