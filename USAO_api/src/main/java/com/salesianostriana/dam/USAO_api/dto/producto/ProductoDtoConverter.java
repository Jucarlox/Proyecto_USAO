package com.salesianostriana.dam.USAO_api.dto.producto;

import com.salesianostriana.dam.USAO_api.models.Producto;
import com.salesianostriana.dam.USAO_api.users.dto.UserDtoConverter;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@RequiredArgsConstructor
@Component
public class ProductoDtoConverter {

    private final UserDtoConverter userDtoConverter;
    public GetProductoDto convertProductoToGetProductoDto(Producto producto) {
        return GetProductoDto.builder()
                .id(producto.getId())
                .nombre(producto.getNombre())
                .descripcion(producto.getDescripcion())
                .fileScale(producto.getFileScale())
                .propietario(userDtoConverter.convertUserEntityToGetUserDto(producto.getPropietario()))
                .build();
    }

}
