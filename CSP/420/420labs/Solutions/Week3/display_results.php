<?php
    // get the data from the form
    $investment = filter_input(INPUT_POST, 'investment', 
            FILTER_VALIDATE_FLOAT);
    $interest_rate = filter_input(INPUT_POST, 'interest_rate', 
            FILTER_VALIDATE_FLOAT);
    $years = filter_input(INPUT_POST, 'years', 
            FILTER_VALIDATE_INT);

    // set default error message of empty string
    $error_message = '';
    
    // validate investment
    if ($investment === FALSE ) {
        $error_message .= 'Investment must be a valid number.<br>'; 
    } else if ( $investment <= 0 ) {
        $error_message .= 'Investment must be greater than zero.<br>'; 
    } 
    
    // validate interest rate
    if ( $interest_rate === FALSE )  {
        $error_message .= 'Interest rate must be a valid number.<br>'; 
    } else if ( $interest_rate <= 0 ) {
        $error_message .= 'Interest rate must be greater than zero.<br>'; 
    } 
    
    // validate years
    if ( $years === FALSE ) {
        $error_message .= 'Years must be a valid whole number.<br>';
    } else if ( $years <= 0 ) {
        $error_message .= 'Years must be greater than zero.<br>';
    } else if ( $years > 30 ) {
        $error_message .= 'Years must be less than 31.<br>';
    } 

    // if an error message exists, go to the index page
    if ($error_message != '') {
        include('index.php');
        exit();
    }

    // calculate the future value
    $future_value = $investment;
    echo '$future_value: ' . $future_value . '<br>';
    echo '$interest_rate: ' . $interest_rate . '<br>';
    echo '$years: ' . $years . '<br>';
    echo 'For loop for calculating future value is starting...<br><br>';
    for ($i = 1; $i <= $years; $i++) {
        $future_value += $future_value * $interest_rate; 
        echo '$i: ' . $i . '<br>';
        echo '$future_value: ' . $future_value . '<br>';
    }

    // apply currency and percent formatting
    $investment_f = '$'.number_format($investment, 2);
    $yearly_rate_f = $interest_rate.'%';
    $future_value_f = '$'.number_format($future_value, 2);
?>
<!DOCTYPE html>
<html>
<head>
    <title>Future Value Calculator</title>
    <link rel="stylesheet" href="main.css"/>
</head>
<body>
    <main>
        <h1>Future Value Calculator</h1>

        <label>Investment Amount:</label>
        <span><?php echo $investment_f; ?></span><br>

        <label>Yearly Interest Rate:</label>
        <span><?php echo $yearly_rate_f; ?></span><br>

        <label>Number of Years:</label>
        <span><?php echo $years; ?></span><br>

        <label>Future Value:</label>
        <span><?php echo $future_value_f; ?></span><br>
    </main>
</body>
</html>