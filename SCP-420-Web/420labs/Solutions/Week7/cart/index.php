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
   
    CartDB::addItemToCart($order_id, $product_id, $quantity, $list_price, $discount_amount);
} else if ($action == 'empty_cart') {
    $order_id = filter_input(INPUT_POST, 'order_id', FILTER_VALIDATE_INT);
    CartDB::emptyCart($order_id);
} else if ($action == 'delete_item') {
    // Get the IDs
    $item_id = filter_input(INPUT_POST, 'item_id', FILTER_VALIDATE_INT);

    // Delete the product
    CartDB::deleteItem($item_id);
}
$customerOrder = CartDB::getCustomerOrder(2);
$orderItems = CartDB::getCart($customerOrder);

$itemCount = count($orderItems); // $cartDB->countCustomerItems(2);
include '../view/header.php'; 
?>
<main>
<h1>Shopping Cart (<?php echo $itemCount ?>)</h1>
    <span>Order number:<?php echo $customerOrder ?></span>
    <table>
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
            <td><form action="index.php" method="post"
                          id="delete_item_form">
                    <input type="hidden" name="action"
                           value="delete_item" />
                    <input type="hidden" name="item_id" value="<?php echo $orderItem->getItemId(); ?>" />
                    <input type="submit" value="Delete" />
                </form></td>
        </tr>            
            <?php endforeach; ?>
            <tr>
                <td colspan='5'>Total</td>
                <td><?php echo number_format($total_price, 2) ?></td>
        </table>
        <form action="<?php echo '../cart/index.php' ?>" method="post">
                <input type="hidden" name="action" value="empty_cart" />
                <input type="hidden" name="order_id" value="<?php echo $customerOrder; ?>" />
                <input type="submit" value="Empty Cart" />
        </form>
    </main>

<?php include '../view/footer.php'; ?>
