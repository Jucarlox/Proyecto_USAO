package com.salesianostriana.dam.USAO_api.dto.producto;

import com.salesianostriana.dam.USAO_api.users.dto.GetUserDto3;
import com.salesianostriana.dam.USAO_api.users.model.User;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class GetProductoDto {

    private Long id;
    private String nombre;
    private String descripcion;
    private String categoria;
    private double precio;
    private GetUserDto3 propietario;
    private String fileScale;

}
