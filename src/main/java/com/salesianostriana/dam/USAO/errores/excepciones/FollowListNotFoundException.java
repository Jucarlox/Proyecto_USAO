package com.salesianostriana.dam.USAO.errores.excepciones;

public class FollowListNotFoundException extends EntityNotFoundException{
    public FollowListNotFoundException(String nick) {
        super(String.format("No sigues a %s ", nick));
    }
}
