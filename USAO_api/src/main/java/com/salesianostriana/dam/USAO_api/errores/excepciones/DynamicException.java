package com.salesianostriana.dam.USAO_api.errores.excepciones;

public class DynamicException extends EntityNotFoundException {
    public DynamicException(String mensaje) {
        super(mensaje);
    }
}
