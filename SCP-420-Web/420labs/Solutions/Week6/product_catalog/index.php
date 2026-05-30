<?php
require('../model/database.php');
require('../model/category.php');
require('../model/category_db.php');
require('../model/product.php');
require('../model/product_db.php');
require('../model/orderitem.php');
require('../model/cart_db.php');

// create the CategoryDB and ProductDB objects
$categoryDB = new CategoryDB();
$productDB = new ProductDB();
$cartDB = new CartDB();

$cart_item_count = $cartDB->countCustomerItems(2);

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

        $current_category = $categoryDB->getCategory($category_id);
        $categories = $categoryDB->getCategories();
        $products = $productDB->getProductsByCategory($category_id);

        include('product_list.php');
        break;
    case 'view_product':
        $categories = $categoryDB->getCategories();
        $order_id = $cartDB->getCustomerOrder(2);
        $product_id = filter_input(INPUT_GET, 'product_id', FILTER_VALIDATE_INT);   
        $product = $productDB->getProduct($product_id);
        include('product_view.php');
        break;
}

?>