package com.salesianostriana.dam.USAO_api.users.dto;

import com.salesianostriana.dam.USAO_api.validacion.anotaciones.UserNickUniqueValueMatch;
import lombok.*;

import javax.validation.constraints.NotEmpty;
import java.time.LocalDate;


@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CreateUserDtoEdit {

    private String localizacion;
    private LocalDate fechaNacimiento;
    private String avatar;
}