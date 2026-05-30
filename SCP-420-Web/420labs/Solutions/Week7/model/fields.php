<?php
class Field {
    private $hasError = FALSE;
    private $value;

    public function __construct(
            private $name, 
            private $message = '',
            private $required = TRUE,
    ) { }
    
    public function getName()    { return $this->name; }
    public function getMessage() { return $this->message; }
    public function hasError()   { return $this->hasError; }
    public function isRequired() { return $this->required; }
    public function isEmpty()    { return empty($this->value); }

    public function setValue($value) {
        $this->value = $value;
    }
    
    public function setErrorMessage($message) {
        $this->message = $message;
        $this->hasError = TRUE;
    }
    public function clearErrorMessage() {
        $this->message = '';
        $this->hasError = FALSE;
    }

    public function getHTML() {
        $message = htmlspecialchars($this->message);
        if ($this->hasError()) {
            return '<span class="error">' . $message . '</span>';
        } else {
            return '<span>' . $message . '</span>';
        }
    }
}

class Fields {
    private $fields = [];

    public function addField($name, $message = '', $required = TRUE) {
        $field = new Field($name, $message, $required);
        $this->fields[$field->getName()] = $field;
    }

    public function getField($name) {
        return $this->fields[$name];
    }

    public function hasErrors() {
        foreach ($this->fields as $field) {
            if ($field->hasError()) { return TRUE; }
        }
        // if we get here, there are no errors
        return FALSE;
    }
}
?>