package com.salesianostriana.dam.USAO_api.security;

import com.salesianostriana.dam.USAO_api.security.dto.JwtUserResponse;
import com.salesianostriana.dam.USAO_api.security.dto.LoginDto;
import com.salesianostriana.dam.USAO_api.security.jwt.JwtProvider;
import com.salesianostriana.dam.USAO_api.users.dto.GetUserDto;
import com.salesianostriana.dam.USAO_api.users.dto.UserDtoConverter;
import com.salesianostriana.dam.USAO_api.users.model.User;
import com.salesianostriana.dam.USAO_api.users.services.UserEntityService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
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


    @Operation(summary = "Logear")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201",
                    description = "Se ha logueado",
                    content = { @Content(mediaType = "application/json",
                            schema = @Schema(implementation = User.class))}),
            @ApiResponse(responseCode = "400",
                    description = "Error al loguearse",
                    content = @Content),
    })
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

    @Operation(summary = "Recoger tus datos")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha recogido tus datos",
                    content = { @Content(mediaType = "application/json",
                            schema = @Schema(implementation = User.class))}),
            @ApiResponse(responseCode = "400",
                    description = "Error al recoger tus datos",
                    content = @Content),
    })
    @GetMapping("/me")
    public ResponseEntity<?> me(@AuthenticationPrincipal User userPrincipal) {

        GetUserDto getUserDto = userEntityService.visializarMiPerfif(userPrincipal, userPrincipal.getId());

        return ResponseEntity.status(HttpStatus.OK)
                .body(getUserDto);
    }


}
