package com.salesianostriana.dam.USAO.validacion.anotaciones;

import com.salesianostriana.dam.USAO.validacion.validadores.UserEmailUniqueValueMatchValitor;

import javax.validation.Constraint;
import javax.validation.Payload;
import java.lang.annotation.*;


@Constraint(validatedBy = UserEmailUniqueValueMatchValitor.class)
@Target({ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface UserEmailUniqueValueMatch {
    String message();

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};


}
