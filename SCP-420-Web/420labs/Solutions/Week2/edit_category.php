<?php
// Get the category data
$name = filter_input(INPUT_POST, 'name');

// Validate inputs
if ($name == NULL) {
    $error = "Invalid category data. Check all fields and try again.";
    include('error.php');
} else {
    require_once('database.php');

    // Add the product to the database  
    $query = 'INSERT INTO categories (categoryName)
              VALUES (:category_name)';
    $statement = $db->prepare($query);
    $statement->bindValue(':category_name', $name);
    $statement->execute();
    $statement->closeCursor();

    // Display the Category List page
    include('category_list.php');
}
?>