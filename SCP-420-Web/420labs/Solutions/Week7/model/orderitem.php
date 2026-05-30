<?php
class OrderItem {
    private int $itemId;
    private int $orderId;
    private ?Product $product;
    public function __construct() {
        $this->itemId = 0;
        $this->orderId = 0;
        $this->quantity = 0;
        $this->product = null;
    }

    public function getProduct() {
        return $this->product;
    }

    public function setProduct(Product $value) {
        $this->product = $value;
    }

    public function getItemId() {
        return $this->itemId;
    }

    public function setItemId(int $value) {
        $this->itemId = $value;
    }

    public function getOrderId() {
        return $this->orderId;
    }

    public function setOrderId(int $value) {
        $this->orderId = $value;
    }
    public function getQuantity() {
        return $this->quantity;
    }
    
    public function setQuantity(int $value) {
        $this->quantity = $value;
    }
}
?>