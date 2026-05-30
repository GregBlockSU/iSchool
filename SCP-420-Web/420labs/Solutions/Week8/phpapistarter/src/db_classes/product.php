<?php 

class Product extends Data_Access {
	protected $object_name = 'products';
	protected $object_view_name = 'product';

    public function __construct() {
        // attempt database connection
        $res = $this->dbConnect();
        
        // if we get anything but a good response ...
        if ($res['response'] != '200') {
            echo "Houston? We have a problem.";
            die;
        }
	}

	public function getProducts($varParams) {

		// build the query
		$query = "SELECT * FROM " . CONST_DB_SCHEMA . "." . $this->object_name;
		$res = $this->getResultSetArray($query);
		
		// if nothing comes back, then return a failure
		if ($res['response'] !== '200') {
			$responseArray = App_Response::getResponse('403');
		} else {
			$responseArray = $res;
		}

		// send back what we got
		return $responseArray;
	}	
}
