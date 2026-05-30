<?php include '../view/header.php'; ?>
<main>
<p>
    <a href='../cart/index.php'>Shopping cart</a>: <?php echo ($cart_item_count == 0) ? 'empty' : $cart_item_count; ?>
</p>
    <aside>
        <h1>Categories</h1>
        <?php include '../view/category_nav.php'; ?>
    </aside>
    <section>
        <h1><?php echo $name; ?></h1>
        <div id="left_column">
            <p>
                <img src="<?php echo $image_filename; ?>"
                    alt="<?php echo $image_alt; ?>" />
            </p>
        </div>

        <div id="right_column">
            <p><b>List Price:</b> $<?php echo $list_price; ?></p>
            <p><b>Discount:</b> <?php echo $discount_percent; ?>%</p>
            <p><b>Your Price:</b> $<?php echo $unit_price_f; ?>
                 (You save $<?php echo $discount_amount_f; ?>)</p>
             <form action="../cart/index.php" method="post" id="view_cart_form">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="product_id" value="<?php echo $product_id; ?>">
                <input type="hidden" name="order_id" value="<?php echo $order_id; ?>">
                <input type="hidden" name="list_price" value="<?php echo $list_price; ?>">
                <input type="hidden" name="discount_amount" value="<?php echo $discount_amount; ?>">
                <br/>   
                
                <b>Quantity:</b>
                <input id="quantity" type="number" name="quantity" 
                       value="1" size="2">
                <br><br>
                <input type="submit" value="Add to Cart">
            </form>
        </div>
    </section>
</main>
<?php include '../view/footer.php'; ?>