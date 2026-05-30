<?php
    // get the data from the form
    $email = filter_input(INPUT_POST, 'email', FILTER_VALIDATE_EMAIL);
    $password = filter_input(INPUT_POST, 'password');
    $phone = filter_input(INPUT_POST, 'phone');
    
    $heard_from = filter_input(INPUT_POST, 'heard_from');
    if ($heard_from === NULL) {
        $heard_from = 'Unknown';
    }
    
    $update = 'No';
    if (isset($_POST['wants_updates'])) {
        $update = 'Yes';
    } else {
        $update = 'No';
    }

    $contact_via = filter_input(INPUT_POST, 'contact_via');

    $comments = filter_input(INPUT_POST, 'comments');
    $comments = htmlspecialchars($comments);  // NOTE: You must code htmlspecialchars before nl2br for this to work correctly
    $comments = nl2br($comments, FALSE);
    
    $error_messages = [];
    if ($email == NULL) array_push($error_messages, 'The email address is invalid');
    if ($password == NULL) array_push($error_messages, 'The password is invalid');
    if ($phone == NULL) array_push($error_messages, 'The phone is invalid');
?>
<!DOCTYPE html>
<html>
<head>
    <title>Account Information</title>
    <link rel="stylesheet" href="main.css"/>
</head>
<body>
    <main>
        <h1>Account Information</h1>

        <label>Email Address:</label>
        <span><?php echo htmlspecialchars($email); ?></span><br>
        <label>Password:</label>
        <span><?php echo htmlspecialchars($password); ?></span><br>
 
        <label>Phone Number:</label>
        <span><?php echo htmlspecialchars($phone); ?></span><br>

        <label>Heard From:</label>
        <span><?php echo htmlspecialchars($heard_from); ?></span><br>

        <label>Send Updates:</label>
        <span><?php echo $update; ?></span><br>

        <label>Contact Via:</label>
        <span><?php echo htmlspecialchars($contact_via); ?></span><br><br>

        <span>Comments:</span><br>
        <span><?php echo $comments; ?></span><br>
        <ul class='error'>
            <!-- display links for products in selected category -->
            <?php foreach ($error_messages as $error_message) : ?>
            <li>
                    <?php echo $error_message; ?>
            </li>
            <?php endforeach; ?>
        </ul>        
        <p>&nbsp;</p>
        <a href='.'>Edit form</a>
    </main>
</body>
</html>