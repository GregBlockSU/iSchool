<?php
require('database.php');
$product_id = filter_input(INPUT_GET, 'product_id', 
FILTER_VALIDATE_INT);
$query = 'SELECT *
          FROM categories
          ORDER BY categoryID';
$statement = $db->prepare($query);
$statement->execute();
$categories = $statement->fetchAll();
$statement->closeCursor();

$query = 'SELECT * FROM products
WHERE productID = :product_id';
$statement = $db->prepare($query);
$statement->bindValue(':product_id', $product_id);
$statement->execute();
$product = $statement->fetch();
$statement->closeCursor();
$category_id = $product['categoryID'];
$productCode = $product['productCode'];
$productName = $product['productName'];
$listPrice = $product['listPrice'];
?>
<!DOCTYPE html>
<html>

<!-- the head section -->
<head>
    <title>My Guitar Shop</title>
    <link rel="stylesheet" href="main.css">
</head>

<!-- the body section -->
<body>
    <header><h1>Product Manager</h1></header>

    <main>
        <h1>Edit Product</h1>
        <form action="edit_product.php" method="post"
              id="edit_product_form">
              <input type="hidden" name="action" value="edit_product">
              <input type='hidden' name='product_id' value="<?php echo $product_id; ?>">
              <table border='0'>
                <tr>
            <td><label>Category:</label></td>
            <td><select name="category_id">
            <?php foreach ($categories as $category) : ?>
                <option value="<?php echo $category['categoryID']; ?>" <?php if ($category['categoryID'] == $category_id) echo ' selected="selected"'; ?>>
                    <?php echo $category['categoryName']; ?>
                    
                </option>
            <?php endforeach; ?>
            </select></td>
            </tr>

            <tr>
            <td><label>Code:</label></td>
            <td><input type="text" name="productCode" value="<?php echo $productCode; ?>"></td>
            </tr>

            <tr>
            <td><label>Name:</label></td>
            <td><input type="text" name="productName"value="<?php echo $productName; ?>"></td>
            </tr>

            <tr>
                <td><label>List Price:</label></td>
            <td><input type="text" name="listPrice" value="<?php echo $listPrice; ?>"></td>
            </tr>

            <tr>
                <td><label>&nbsp;</label></td>
                <td><input type="submit" value="Save"></td>
            </tr>
            </table>
        </form>
        <p><a href="index.php">View Product List</a></p>
    </main>

    <footer>
        <p>&copy; <?php echo date("Y"); ?> My Guitar Shop, Inc.</p>
    </footer>
</body>
</html>