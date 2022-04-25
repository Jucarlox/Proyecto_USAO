package com.salesianostriana.dam.USAO_api.errores.excepciones;

public class EntityNotFoundException extends RuntimeException {

    public EntityNotFoundException(String message) {
        super(message);
    }
}
