<?php
require('../model/database.php');
require('../model/category.php');
require('../model/category_db.php');
require('../model/product.php');
require('../model/product_db.php');

// create the CategoryDB and ProductDB objects
$categoryDB = new CategoryDB();
$productDB = new ProductDB();

$action = filter_input(INPUT_POST, 'action');
if ($action == NULL) {
    $action = filter_input(INPUT_GET, 'action');
    if ($action == NULL) {
        $action = 'list_products';
    }
}  

switch($action) {
    case 'list_products':
        $category_id = filter_input(INPUT_GET, 'category_id', 
                FILTER_VALIDATE_INT);
        if ($category_id == NULL || $category_id == FALSE) {
            $category_id = 1;
        }

        // Get product and category data
        $current_category = $categoryDB->getCategory($category_id);
        $categories = $categoryDB->getCategories();
        $products = $productDB->getProductsByCategory($category_id);

        // Display the product list
        include('product_list.php');
        break;
    case 'delete_product':
        // Get the IDs
        $product_id = filter_input(INPUT_POST, 'product_id', 
                FILTER_VALIDATE_INT);
        $category_id = filter_input(INPUT_POST, 'category_id', 
                FILTER_VALIDATE_INT);

        // Delete the product
        $productDB->deleteProduct($product_id);

        // Display the Product List page for the current category
        header("Location: .?category_id=$category_id");
        break;
    case 'show_add_form':
        $categories = $categoryDB->getCategories();
        include('product_add.php');
        break;
    case 'add_product':
        $category_id = filter_input(INPUT_POST, 'category_id', 
                FILTER_VALIDATE_INT);
        $code = filter_input(INPUT_POST, 'code');
        $name = filter_input(INPUT_POST, 'name');
        $price = filter_input(INPUT_POST, 'price', 
                FILTER_VALIDATE_FLOAT);
        if ($category_id == NULL || $category_id == FALSE || $code == NULL || 
                $name == NULL || $price == NULL || $price == FALSE) {
            $error = "Invalid product data. Check all fields and try again.";
            include('../errors/error.php');
        } else {
            $current_category = $categoryDB->getCategory($category_id);
            // Create the Product object
            $product = new Product();
            $product->setCategory($current_category);
            $product->setCode($code);
            $product->setName($name);
            $product->setPrice($price);

            // Add the Product object to the database
            $productDB->addProduct($product);

            // Display the Product List page for the current category
            header("Location: .?category_id=$category_id");
        }
        break;
}
?>