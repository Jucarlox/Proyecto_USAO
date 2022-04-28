package com.salesianostriana.dam.USAO_api.users.dto;


import com.salesianostriana.dam.USAO_api.dto.producto.GetProductoDto;

import com.salesianostriana.dam.USAO_api.users.model.UserRole;
import lombok.*;

import java.time.LocalDate;
import java.util.UUID;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class GetUserDto {

    private UUID id;
    private String nick;
    private String email;
    private LocalDate fechaNacimiento;
    private String avatar;
    private UserRole role;
    private List<GetProductoDto> productoList;


}