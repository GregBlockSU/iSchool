<?php include '../view/header.php'; ?>
<main>
    <a href='../cart/index.php'>Shopping cart (<?php echo $cartCount?>)</a><br/>
    <aside>
        <h1>Categories</h1>
        <nav>
            <ul>
                <!-- display links for all categories -->
                <?php foreach($categories as $category) : ?>
                <li>
                <a href="?category_id=<?php echo $category->getID(); ?>">
                    <?php echo $category->getName(); ?>
                </a>
                </li>
                <?php endforeach; ?>
            </ul>
        </nav>
    </aside>
    <section>
        <h1><?php echo $product->getName(); ?></h1>
        <div id="left_column">
            <p>
                <img src="<?php echo $product->getImagePath(); ?>"
                    alt="<?php echo $product->getImageAltText(); ?>" />
            </p>
        </div>

        <div id="right_column">
            <p><b>List Price:</b> $<?php echo $product->getPriceFormatted(); ?></p>
            <p><b>Discount:</b> <?php echo $product->getDiscountPercent(); ?>%</p>
            <p><b>Your Price:</b> $<?php echo $product->getDiscountPrice(); ?>
                 (You save $<?php echo $product->getDiscountAmount(); ?>)</p>
            <form action="<?php echo '../cart/index.php' ?>" method="post">
                <input type="hidden" name="action" value="add" />
                <input type="hidden" name="order_id" value="<?php echo $orderNumber; ?>" />
                <input type="hidden" name="product_id" value="<?php echo $product->getID(); ?>" />
                <input type="hidden" name="list_price" value="<?php echo $product->getPrice(); ?>" />
                <input type="hidden" name="discount_amount" value="<?php echo $product->getDiscountAmount(); ?>" />
                <b>Quantity:</b>
                <input type="text" name="quantity" value="1" size="2" />
                <input type="submit" value="Add to Cart" />
            </form>
        </div>
    </section>
</main>
<?php include '../view/footer.php'; ?>