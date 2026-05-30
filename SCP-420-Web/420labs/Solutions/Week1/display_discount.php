<?php

        $product_description = filter_input(INPUT_POST, 'product_description');
	$list_price = filter_input(INPUT_POST, 'list_price', FILTER_VALIDATE_FLOAT);
	$discount_percent = filter_input(INPUT_POST, 'discount_percent', FILTER_VALIDATE_FLOAT);

        // set default error message of empty string
        $error_message = '';

        // validate list pricet
        if ($list_price === FALSE ) {
            $error_message .= 'List price must be a valid number.<br>'; 
        } else if ( $list_price <= 0 ) {
            $error_message .= 'List price must be greater than zero.<br>'; 
        }        

       // validate list pricet
        if ($discount_percent === FALSE ) {
            $error_message .= 'List price must be a valid number.<br>'; 
        } else if ( $discount_percent <= 0 ) {
            $error_message .= 'List price must be greater than zero.<br>'; 
        }        

        if ($error_message != '') {
            include('index.php');
            exit();
        }    

 	
        $discount = $list_price * $discount_percent * .01;
        $discount_price = $list_price - $discount;
        $sales_tax = .08;
        $taxed_price = $discount_price * $sales_tax;
        $final_price = $discount_price + $taxed_price;
             
        $list_price_f = "$".number_format($list_price, 2);
        $discount_percent_f = $discount_percent."%";
        $discount_f = "$".number_format($discount, 2);
        $discount_price_f = "$".number_format($discount_price, 2);
        $sales_tax_f = number_format(100*$sales_tax, 2)."%";
        $taxed_price_f = "$".number_format($taxed_price, 2);
        $final_price_f = "$".number_format($final_price, 2);
        
?>
<!DOCTYPE html>
<html>
<head>
    <title>Product Discount Calculator</title>
    <link rel="stylesheet" href="main.css">
</head>
<body>
    <main>
        <h1>Product Discount Calculator</h1>

        <label>Product Description:</label>
        <span><?php echo htmlspecialchars($product_description); ?></span><br>

        <label>List Price:</label>
        <span><?php echo $list_price_f; ?></span><br>

        <label>Discount Percent:</label>
        <span><?php echo $discount_percent_f; ?></span><br>

        <label>Discount Amount:</label>
        <span><?php echo $discount_f; ?></span><br>

        <label>Discount Price:</label>
        <span><?php echo $discount_price_f; ?></span><br>

       <label>Sales Tax Rate:</label>
        <span><?php echo $sales_tax_f; ?></span><br>
 
        <label>Sales Tax:</label>
        <span><?php echo $taxed_price_f; ?></span><br>

        <label>Final price:</label>
        <span><?php echo $final_price_f; ?></span><br>
    </main>
</body>
</html>