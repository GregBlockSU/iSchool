<?php 
require('../model/database.php');
require('../model/cart_db.php');

$action = filter_input(INPUT_POST, 'action');
if ($action == NULL) {
    $action = filter_input(INPUT_GET, 'action');
    if ($action == NULL) {
        $action = 'view_cart';
    }
}

if ($action == 'add') {
    $product_id = filter_input(INPUT_POST, 'product_id', FILTER_VALIDATE_INT);
    $quantity = filter_input(INPUT_POST, 'quantity', FILTER_VALIDATE_INT);
    $order_id = filter_input(INPUT_POST, 'order_id', FILTER_VALIDATE_INT);
    $list_price = filter_input(INPUT_POST, 'list_price', FILTER_VALIDATE_FLOAT);
    $discount_amount = filter_input(INPUT_POST, 'discount_amount', FILTER_VALIDATE_FLOAT);

    #if ($product_id == FALSE || $order_id == FALSE || $quantity == FALSE) {
    #    $error = "Invalid cart data. Check all fields and try again.";
    #    include('../errors/error.php');
    #} else { 
        add_to_cart($order_id, $product_id, $quantity, $list_price, $discount_amount);
    #}
}
$cart_items = get_cart_items(2);
include '../view/header.php'; 
?>

<main>
<?php if ($action == 'add') echo '<p>The item has been added to the cart</p>' ?>
    <h1>Shopping Cart</h1>
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
        <?php foreach ($cart_items as $item) : ?>
            <?php $total_price += $item['quantity'] * ($item['itemPrice'] - $item['discountAmount']); ?>
            <tr>
            <td><?php echo $item['productName'] ?></td>
            <td><?php echo $item['quantity'] ?></td>
            <td><?php echo number_format($item['itemPrice'], 2) ?></td>
            <td><?php echo number_format($item['discountAmount'], 2) ?></td>
            <td><?php echo number_format($item['itemPrice'] - $item['discountAmount'], 2)?></td>
            <td><?php echo number_format($item['quantity'] * ($item['itemPrice'] - $item['discountAmount']), 2) ?></td>
            </tr>            
            <?php endforeach; ?>
            <tr>
                <td colspan='5'>Total</td>
                <td><?php echo number_format($total_price, 2) ?></td>
        </table>
        </main>

<?php include '../view/footer.php'; ?>
