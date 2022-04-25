package com.salesianostriana.dam.USAO_api.validacion.anotaciones;


import com.salesianostriana.dam.USAO_api.validacion.validadores.PasswordsMatchValidator;

import javax.validation.Constraint;
import javax.validation.Payload;
import java.lang.annotation.*;

@Constraint(validatedBy = PasswordsMatchValidator.class)
@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface PasswordsMatch {

    String message();

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};

    String passwordField();

    String verifyPasswordField();

}
