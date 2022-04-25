package com.salesianostriana.dam.USAO_api.users.dto;

import lombok.*;

import javax.validation.constraints.NotEmpty;
import java.time.LocalDate;


@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CreateUserDtoEdit {

    private LocalDate fechaNacimiento;
    private String avatar;
    private boolean privacity;
    @NotEmpty
    private String password;
}