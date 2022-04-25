package com.salesianostriana.dam.USAO_api.validacion.anotaciones;


import com.salesianostriana.dam.USAO_api.validacion.validadores.UserNickUniqueValueMatchValitor;

import javax.validation.Constraint;
import javax.validation.Payload;
import java.lang.annotation.*;

@Constraint(validatedBy = UserNickUniqueValueMatchValitor.class)
@Target({ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface UserNickUniqueValueMatch {
    String message();

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};


}