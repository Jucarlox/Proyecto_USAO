package com.salesianostriana.dam.USAO_api.users.controller;

import com.salesianostriana.dam.USAO_api.users.dto.*;
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
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.validation.Valid;
import java.io.IOException;
import java.time.format.DateTimeFormatter;
import java.util.UUID;
import java.util.List;


@RestController
@RequiredArgsConstructor
@CrossOrigin("http://localhost:4200")
public class UserController {

    private final UserEntityService userEntityService;
    private final UserDtoConverter userDtoConverter;


    @Operation(summary = "Registrar")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201",
                    description = "Se ha registrado",
                    content = { @Content(mediaType = "application/json",
                            schema = @Schema(implementation = User.class))}),
            @ApiResponse(responseCode = "400",
                    description = "Error al registrarse",
                    content = @Content),
    })
    @PostMapping("/auth/register")
    public ResponseEntity<GetUserDto3> nuevoUsuario(@RequestPart("file") MultipartFile file,
                                                    @Valid @RequestPart("user")  CreateUserDto userDto) throws IOException {

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-d");

        User saved = userEntityService.saveUser(userDto, file);



        if (saved == null)
            return ResponseEntity.badRequest().build();
        else
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(userDtoConverter.convertUserEntityToGetUserDto(saved));
    }

    @Operation(summary = "Recoger los datos de un usuario")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha recogido los datos de un usuario",
                    content = { @Content(mediaType = "application/json",
                            schema = @Schema(implementation = User.class))}),
            @ApiResponse(responseCode = "400",
                    description = "Error al recoger los datos de un usuario",
                    content = @Content),
    })
    @GetMapping("/profile/{id}")
    public ResponseEntity<?> visializarPerfif(@AuthenticationPrincipal User userPrincipal, @PathVariable UUID id) {


        return ResponseEntity.status(HttpStatus.OK)
                .body(userEntityService.visializarPerfif(userPrincipal, id));
    }

    @Operation(summary = "Editar usuario")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201",
                    description = "Se ha editado el usuario",
                    content = { @Content(mediaType = "application/json",
                            schema = @Schema(implementation = User.class))}),
            @ApiResponse(responseCode = "400",
                    description = "Error al editar usuario",
                    content = @Content),
    })
    @PutMapping("/profile/me")
    public ResponseEntity<?> editUser(@RequestPart("file") MultipartFile file, @Valid @RequestPart("user") CreateUserDtoEdit createUserDto, @AuthenticationPrincipal User userPrincipal) throws IOException {
        User userEditado = userEntityService.userEdit(file, createUserDto, userPrincipal);

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(userDtoConverter.convertUserEntityToGetUserDto(userEditado));
    }

    @Operation(summary = "Eliminar usuario")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "204",
                    description = "Se ha eliminado el usuario",
                    content = { @Content(mediaType = "application/json",
                            schema = @Schema(implementation = User.class))}),
            @ApiResponse(responseCode = "204",
                    description = "Error al eliminar el usuario",
                    content = @Content),
    })
    @DeleteMapping("/profile/{id}")
    public ResponseEntity<?> deleteUser (@AuthenticationPrincipal User userPrincipal, @PathVariable UUID id) throws IOException{
        return userEntityService.deleteUser(userPrincipal,id);
    }



    @Operation(summary = "Recoger users")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha recogido los users",
                    content = { @Content(mediaType = "application/json",
                            schema = @Schema(implementation = User.class))}),
            @ApiResponse(responseCode = "400",
                    description = "Error al recoger los users",
                    content = @Content),
    })
    @GetMapping("/listUsers")
    public ResponseEntity<List<GetUserDto3>> listUsers() {
        return ResponseEntity.status(HttpStatus.OK)
                .body(userEntityService.listUsers());
    }


}
