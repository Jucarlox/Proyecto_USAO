package com.salesianostriana.dam.USAO.errores.excepciones;

import java.util.List;

public class UnsupportedMediaType extends EntityNotFoundException {

    public UnsupportedMediaType(List<String> extensiones) {
        super(String.format("Archivo no soportado, pruebe con estos archivos: %s", extensiones));
    }
}
