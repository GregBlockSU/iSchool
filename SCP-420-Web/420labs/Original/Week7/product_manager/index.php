<?php
require('../model/database.php');
require('../model/category.php');
require('../model/category_db.php');
require('../model/product.php');
require('../model/product_db.php');


// Set up fields

$action = filter_input(INPUT_POST, 'action');
if ($action == NULL) {
    $action = filter_input(INPUT_GET, 'action');
    if ($action == NULL) {
        $action = 'list_products';
    }
}

switch($action) {
    case 'list_products':
        // Get the current category ID
        $category_id = filter_input(INPUT_GET, 'category_id', 
                FILTER_VALIDATE_INT);
        if ($category_id == NULL || $category_id == FALSE) {
            $category_id = 1;
        }

        // Get product and category data
        $current_category = CategoryDB::getCategory($category_id);
        $categories = CategoryDB::getCategories();
        $products = ProductDB::getProductsByCategory($category_id);

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
        ProductDB::deleteProduct($product_id);

        // Display the Product List page for the current category
        header("Location: .?category_id=$category_id");
        break;
    case 'show_add_form':
        $code = '';
        $name = '';
        $price = '';

        $categories = CategoryDB::getCategories();
        include('product_add.php');
        break;
    case 'add_product':

        // Get form data
        $category_id = filter_input(INPUT_POST, 'category_id', 
                FILTER_VALIDATE_INT);
        $code = filter_input(INPUT_POST, 'code');
        $name = filter_input(INPUT_POST, 'name');
        $price = filter_input(INPUT_POST, 'price');

        $current_category = CategoryDB::getCategory($category_id);
        $product = new Product($current_category, $code, $name, $price);
        ProductDB::addProduct($product);

        // Display the Product List page for the current category
        header("Location: .?category_id=$category_id");
        break;
}
?>