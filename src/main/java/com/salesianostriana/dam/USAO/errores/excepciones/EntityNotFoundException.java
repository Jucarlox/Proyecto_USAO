package com.salesianostriana.dam.USAO.errores.excepciones;

public class EntityNotFoundException extends RuntimeException {

    public EntityNotFoundException(String message) {
        super(message);
    }
}
