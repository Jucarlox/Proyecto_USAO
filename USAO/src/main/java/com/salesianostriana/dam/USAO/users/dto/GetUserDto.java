package com.salesianostriana.dam.USAO.users.dto;


import com.salesianostriana.dam.USAO.models.Estado;
import lombok.*;

import java.time.LocalDate;
import java.util.List;
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