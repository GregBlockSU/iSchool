public class InvalidCoordinatesException extends Exception {
    public InvalidCoordinatesException(int x, int y) {
        super(String.format("Invalid coordinates %d, %d", x, y));
    }
}