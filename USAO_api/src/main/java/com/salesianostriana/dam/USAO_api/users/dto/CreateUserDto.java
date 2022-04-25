package com.salesianostriana.dam.USAO_api.users.dto;


import com.salesianostriana.dam.USAO_api.validacion.anotaciones.PasswordsMatch;
import com.salesianostriana.dam.USAO_api.validacion.anotaciones.UserEmailUniqueValueMatch;
import com.salesianostriana.dam.USAO_api.validacion.anotaciones.UserNickUniqueValueMatch;
import lombok.*;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotEmpty;
import java.time.LocalDate;


@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@PasswordsMatch(
        passwordField = "password",
        verifyPasswordField = "password2",
        message = "Las contraseñas no coinciden"
)
public class CreateUserDto {

    @UserNickUniqueValueMatch(message = "Ya hay otro usuario con ese nick")
    private String nick;
    @UserEmailUniqueValueMatch(message = "Ya hay otro usuario con ese email")
    @Email
    private String email;


    private LocalDate fechaNacimiento;

    private boolean privacity;
    @NotEmpty
    private String password;
    private String password2;
}
