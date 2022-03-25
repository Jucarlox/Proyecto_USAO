package com.salesianostriana.dam.USAO.errores.excepciones;

public class DynamicException extends EntityNotFoundException {
    public DynamicException(String mensaje) {
        super(mensaje);
    }
}
