package com.salesianostriana.dam.USAO_api.errores.excepciones;

public class ListEntityNotFoundException extends EntityNotFoundException{
    public ListEntityNotFoundException(Class clazz) {
        super(String.format("No se pueden encontrar elementos del tipo %s ", clazz.getName()));
    }
}