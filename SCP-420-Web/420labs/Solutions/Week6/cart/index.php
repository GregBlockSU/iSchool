<?php 
require('../model/database.php');
require('../model/category.php');
require('../model/category_db.php');
require('../model/product.php');
require('../model/product_db.php');
require('../model/orderitem.php');
require('../model/cart_db.php');

$action = filter_input(INPUT_POST, 'action');
if ($action == NULL) {
    $action = filter_input(INPUT_GET, 'action');
    if ($action == NULL) {
        $action = 'view_cart';
    }
}

if ($action == 'add') {
    $order_id = filter_input(INPUT_POST, 'order_id', FILTER_VALIDATE_INT);
    $product_id = filter_input(INPUT_POST, 'product_id', FILTER_VALIDATE_INT);
    $quantity = filter_input(INPUT_POST, 'quantity', FILTER_VALIDATE_INT);
    $list_price = filter_input(INPUT_POST, 'list_price', FILTER_VALIDATE_FLOAT);
    $discount_amount = filter_input(INPUT_POST, 'discount_amount', FILTER_VALIDATE_FLOAT);
   
    $cartDB = new CartDB(); 
    $cartDB->addItemToCart($order_id, $product_id, $quantity, $list_price, $discount_amount);
}

$cartDB = new CartDB();
$orderItems = $cartDB->getCustomerOrderItems(2);
$itemCount = count($orderItems); // $cartDB->countCustomerItems(2);
include '../view/header.php'; 
?>
<main>
<h1>Shopping Cart (<?php echo $itemCount ?>)</h1>
    <table border='1'>
        <tr>

        <th>Product</th>
        <th>Quantity</th>
        <th>Price</th>
        <th>Discount</th>
        <th>Your Price</th>        
        <th>Extended Price</th>        
        </tr>
        <?php $total_price = 0 ?>
        <?php foreach ($orderItems as $orderItem) : ?>
            <?php $total_price += $orderItem->getQuantity() * ($orderItem->getProduct()->getPrice() - $orderItem->getProduct()->getDiscountAmount()); ?>
            <?php $product = $orderItem->getProduct() ?>
            <tr>
            <td><?php echo $product->getName() ?></td>
            <td><?php echo $orderItem->getQuantity() ?></td>
            <td><?php echo number_format($product->getPrice(), 2) ?></td>
            <td><?php echo number_format($product->getDiscountAmount(), 2) ?></td>
            <td><?php echo number_format($product->getPrice() - $product->getDiscountAmount(), 2)?></td>
            <td><?php echo number_format($orderItem->getQuantity() * ($product->getPrice() - $product->getDiscountAmount()), 2) ?></td>
            </tr>            
            <?php endforeach; ?>
            <tr>
                <td colspan='5'>Total</td>
                <td><?php echo number_format($total_price, 2) ?></td>
        </table>
 </main>
 <a href='..'>Product Catalog</a>
<?php include '../view/footer.php'; ?>
