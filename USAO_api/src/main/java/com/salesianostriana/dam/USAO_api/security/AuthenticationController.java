package com.salesianostriana.dam.USAO_api.security;

import com.salesianostriana.dam.USAO_api.security.dto.JwtUserResponse;
import com.salesianostriana.dam.USAO_api.security.dto.LoginDto;
import com.salesianostriana.dam.USAO_api.security.jwt.JwtProvider;
import com.salesianostriana.dam.USAO_api.users.dto.UserDtoConverter;
import com.salesianostriana.dam.USAO_api.users.model.User;
import com.salesianostriana.dam.USAO_api.users.services.UserEntityService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class AuthenticationController {
    private final AuthenticationManager authenticationManager;
    private final JwtProvider jwtProvider;
    private final UserDtoConverter userDtoConverter;
    private final UserEntityService userEntityService;

    @PostMapping("/auth/login")
    public ResponseEntity<?> login(@RequestBody LoginDto loginDto) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        loginDto.getEmail(),
                        loginDto.getPassword()
                )
        );

        SecurityContextHolder.getContext().setAuthentication(authentication);


        String jwt = jwtProvider.generateToken(authentication);


        User user = (User) authentication.getPrincipal();

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(convertUserToJwtUserResponse(user, jwt));

    }

    private JwtUserResponse convertUserToJwtUserResponse(User user, String jwt) {
        return JwtUserResponse.builder()
                .nike(user.getNick())
                .email(user.getEmail())
                .role(user.getRoles().toString())
                .id(user.getId())
                .token(jwt)
                .build();
    }

    /*@GetMapping("/me")
    public ResponseEntity<?> me(@AuthenticationPrincipal User userPrincipal) {

        GetUserDto getUserDto = userEntityService.visializarMiPerfif(userPrincipal, userPrincipal.getId());

        return ResponseEntity.status(HttpStatus.OK)
                .body(getUserDto);
    }*/


}
