<?php include '../view/header.php'; ?>
<main>
<p>
    Shopping cart: <?php echo ($cart_item_count == 0) ? 'empty' : $cart_item_count; ?>
</p>
    <aside>
        <h1>Categories</h1>
        <?php include '../view/category_nav.php'; ?>
    </aside>
    <section>
        <h1><?php echo $category_name; ?></h1>
        <ul class="nav">
            <!-- display links for products in selected category -->
            <?php foreach ($products as $product) : ?>
            <li>
                <a href="?action=view_product&amp;product_id=<?php 
                          echo $product['productID']; ?>">
                    <?php echo $product['productName']; ?>
                </a>
            </li>
            <?php endforeach; ?>
        </ul>
    </section>
</main>
<?php include '../view/footer.php'; ?>