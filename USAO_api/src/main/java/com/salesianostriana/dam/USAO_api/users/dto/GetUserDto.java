package com.salesianostriana.dam.USAO_api.users.dto;


import com.salesianostriana.dam.USAO_api.models.Estado;
import lombok.*;

import java.time.LocalDate;
import java.util.UUID;

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
    private Estado estado;
    //private List<GetPostDto> postList;


}