package com.salesianostriana.dam.USAO_api.dto.producto;

import com.salesianostriana.dam.USAO_api.users.model.User;
import lombok.*;

import javax.validation.constraints.NotEmpty;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CreateProductoDto {

    @NotEmpty
    private String nombre;
    @NotEmpty
    private String descripcion;
    private String fileOriginal;
    private String fileScale;
    private String categoria;
    private double precio;
}
