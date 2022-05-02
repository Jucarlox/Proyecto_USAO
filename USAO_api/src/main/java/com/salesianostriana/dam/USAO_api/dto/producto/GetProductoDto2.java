package com.salesianostriana.dam.USAO_api.dto.producto;

import com.salesianostriana.dam.USAO_api.users.dto.GetUserDto3;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class GetProductoDto2 {
    private Long id;
    private String nombre;
    private String categoria;
    private double precio;
    private String descripcion;
    private String fileScale;
}
