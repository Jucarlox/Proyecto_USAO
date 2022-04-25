package com.salesianostriana.dam.USAO_api.validacion.validadores;

import com.salesianostriana.dam.USAO_api.users.repository.UserEntityRepository;
import com.salesianostriana.dam.USAO_api.validacion.anotaciones.UserNickUniqueValueMatch;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

public class UserNickUniqueValueMatchValitor implements ConstraintValidator<UserNickUniqueValueMatch, String> {

    @Autowired
    private UserEntityRepository userEntityRepository;

    public UserNickUniqueValueMatchValitor() {
    }

    public void initialize(UserNickUniqueValueMatch constraintAnnotation) {

    }

    @Override
    public boolean isValid(String value, ConstraintValidatorContext constraintValidatorContext) {

        return StringUtils.hasText(value) && !userEntityRepository.existsByNick(value);
    }
}
