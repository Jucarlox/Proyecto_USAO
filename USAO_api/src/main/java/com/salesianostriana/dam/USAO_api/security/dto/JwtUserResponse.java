package com.salesianostriana.dam.USAO_api.security.dto;

import lombok.*;

import java.util.UUID;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class JwtUserResponse {
    private String email;
    private String nike;
    private UUID id;
    private String role;
    private String token;
}
