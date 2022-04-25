package com.salesianostriana.dam.USAO_api.errores.excepciones;

public class NickUserNotFoundException extends EntityNotFoundException {

    public NickUserNotFoundException(String nick, Class clazz) {
        super(String.format("No se puede encontrar una entidad del tipo %s con nick: %s", clazz.getName(), nick));
    }
}