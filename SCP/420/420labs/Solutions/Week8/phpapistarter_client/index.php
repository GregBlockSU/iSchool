<?php

    // the value of CONST_API_KEY must match the value of the column api_key in
    // table app_api_key in mySql
    define("CONST_API_KEY", "d7e1a3d7dd2a43a4");

    // the value of CONST_API_HOST is the location of the web service
    define("CONST_API_HOST", "http://localhost/420labs/Solutions/Week8/phpapistarter/");

    $apiToken = NULL;
    // check to see if our cookie is set; of not, query the $apiToken from the web service
    // and save it in the cookie
    if (!isset($_COOKIE['apistarter'])) {
        $resArray = setInitialCookie();
        $message = $resArray['message'];

        $apiToken = $resArray['apiToken'];
        $products = getProducts($apiToken);
    } else {
        $apiToken = getApiTokenFromCookie();
        $message = "<h2>You have a token</h2><br />".$apiToken."<br>Your token is already saved in a cookie.";
    }
    $products = getProducts($apiToken);

    //----------------------------------------------------------------------------------------------------
    function setInitialCookie() {
        // get an API token from the web service
        $apiFunctionName = 'getToken';
        $postDataJSONArray = 'apiFunctionName=' . urlencode($apiFunctionName) . '&';
        $postDataJSONArray .= 'apiFunctionParams=' . '{"api_key":"' . urlencode(CONST_API_KEY).'"}';

        $res = file_get_contents(CONST_API_HOST."?".$postDataJSONArray);

        $resArray = json_decode($res, true);  

        if ($resArray['response'] == '200') {

            // extract the goodies
            $apiToken = $resArray['dataArray']['token'];
            $apiHost = CONST_API_HOST;
            $acceptedCookie = FALSE;

            $arr = array('apiKey' => CONST_API_KEY, 'apiHost' => $apiHost, 'apiToken' => $apiToken);

            $cookieJSONArray = json_encode($arr);

            // store the token in a cookie. It will be managed from the client side after this.
            setrawcookie("apistarter", urlencode($cookieJSONArray), 0, "/");

            $message = "<h2>Your new token is:</h2><br />".$apiToken;
            return array('message' => $message, 'apiToken' => $apiToken);

        } else {
            // error
            echo "Error occurred while trying to connect to API. " . $resArray['responseDescription'];
            die();
        }
    }

    function getApiTokenFromCookie() {
        $rawCookie = $_COOKIE['apistarter'];
        //echo $rawCookie;
        $cookieArray = urldecode($rawCookie);
        //echo '<br>cookieArray: '.$cookieArray;

        $jsonArray = json_decode($cookieArray, true);
        $apiToken = $jsonArray['apiToken'];
    }

    function getProducts($apiToken = NULL) {
        $products = array();

        // the $apiToken comes from the parameter or the cookie
        // so if the parameter is not set but the cookie is, we can 
        // extract the token from the cookie
        if (!isset($apiToken) && isset($_COOKIE['apistarter'])) {
            $apiToken = getApiTokenFromCookie();
        }

        // if there is an $apiToken value, construct a URL to request the
        // product list from the web service
        if (isset($apiToken)) {
            $apiFunctionName = 'getProducts';
            $postDataJSONArray  = 'apiFunctionName=' . urlencode($apiFunctionName);
            $postDataJSONArray .= '&apiKey='.CONST_API_KEY;
            $postDataJSONArray .= '&apiToken='.$apiToken;
            $postDataJSONArray .= "&apiFunctionParams=";

            $res = file_get_contents(CONST_API_HOST."?".$postDataJSONArray);
            $resArray = json_decode($res, true);  

            if ($resArray['response'] == '200') {
                $products = $resArray['dataArray'];
            }   
        } 

        return $products;
    }
 ?>

<!doctype html>
<html lang="en">

    <head>

        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

        <title>PHP API Starter Kit</title>
        <meta name="description" content="PHP API Starter Kit">
        <meta name="robots" content="noindex, nofollow">
        
        <!-- Add Bootstrap CSS -->
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">

    </head>

    <body class="pt-5">
        <nav class="navbar navbar-expand-md navbar-dark bg-dark fixed-top">&nbsp;</nav>

        <main role="main" class="container">
            <h1>PHP Restful API Starter Kit - Client</h1>
            <p class="mt-5">
                <div class="mb-3" id="notificationMessage"><?php echo $message; ?></div>
                <button class="btn btn-primary" id="deleteCookie">Delete the Cookie</button>
            </p>
            <h2>Products</h2>
            <table border='1'>
                <tr>
                <th>ID</th>
                <th>Code</th>
                <th>Name</th>
                <th>List Price</th>
                <th>Discount Amount</th>
                </tr>
            <?php if (count($products) == 0) :?>
                <tr><td colspan="5">No products found</td>
            <?php endif; ?>
            <?php foreach ($products as $product) : ?>
            <tr>
               <td><?php echo $product['productID']; ?></td>
                <td><?php echo $product['productCode']; ?></td>
                <td><?php echo $product['productName']; ?></td>
                <td><?php echo $product['listPrice']; ?></td>
                <td><?php echo $product['discountPercent']; ?></td>
            </tr>
            <?php endforeach; ?>
            </table>

        </main>

        <!-- Load JavaScript: jQuery, Popper, Bootstrap,  -->      
        <script src="https://code.jquery.com/jquery-3.3.1.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>

        <script src="js/apiHandler.js" type="text/javascript"></script>
        <script src="js/cookieHandler.js" type="text/javascript"></script>

        <script type="text/javascript">
            $(function () {
                // delete cookie
                $('#deleteCookie').click(function(event) {
                    event.preventDefault();
                    deleteCookie('apistarter');
                    $('#deleteCookie').prop('disabled', true);
                    $('#getJQueryToken').prop('disabled', false);
                    $('#notificationMessage').html("<h2>Cookie has been deleted.</h2><br />Refresh the page to cause the client to call the web service and get you a new token.");
                });
                // get token via javascript and create cookie
                $('#getJQueryToken').click(function(event) {
                    event.preventDefault();
                    const apiKey = 'd7e1a3d7dd2a43a4';
                    const apiHost = 'http://localhost/phpapistarter/';
                    const apiFunctionName = 'getToken';
                    const apiFunctionParams = {api_key: apiKey};
                    
                    apiHandler(apiKey, apiHost, 'GET', apiFunctionName, JSON.stringify(apiFunctionParams), (jsonData) => {
                        res = jsonData.response;
                        if (res === '200') {
                            
                            apiToken = jsonData.dataArray.token;
                            
                            // reset our cookie with a token,
                            cookieArray = {
                                apiKey: apiKey, 
                                apiToken: apiToken, 
                                apiHost: apiHost,
                            };
                            encodedCookie = encodeCookie(JSON.stringify(cookieArray));
                            setCookie('apistarter', encodedCookie);
                            $('#notificationMessage').html("<h2>Your new token is:</h2><br />" + apiToken);
                            $('#deleteCookie').prop('disabled', false);
                            $('#getJQueryToken').prop('disabled', true);
                        }
                    });


                });
            });
        </script>  

    </body>

</html>