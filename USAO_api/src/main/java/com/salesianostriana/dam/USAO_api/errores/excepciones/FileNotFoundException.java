package com.salesianostriana.dam.USAO_api.errores.excepciones;

public class FileNotFoundException extends StorageException {

    public FileNotFoundException(String message) {
        super(message);
    }

    public FileNotFoundException(String message, Exception cause) {
        super(message, cause);
    }
}
