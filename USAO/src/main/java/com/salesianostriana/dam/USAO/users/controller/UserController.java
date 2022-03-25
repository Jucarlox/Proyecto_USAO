package com.salesianostriana.dam.USAO.users.controller;

import com.salesianostriana.dam.USAO.users.dto.*;
import com.salesianostriana.dam.USAO.users.model.User;
import com.salesianostriana.dam.USAO.users.services.UserEntityService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.validation.Valid;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

@RestController
@RequiredArgsConstructor
@CrossOrigin("http://localhost:4200")
public class UserController {

    private final UserEntityService userEntityService;
    private final UserDtoConverter userDtoConverter;


    @PostMapping("/auth/register")
    public ResponseEntity<GetUserDto3> nuevoUsuario(@RequestPart("file") MultipartFile file,@Valid @RequestParam("nick") String nick,@Valid @RequestParam("email") String email,@Valid @RequestParam("fechaNacimiento") String fechaNacimiento, @Valid @RequestParam("password") String password,@Valid @RequestParam("password2") String password2,@Valid @RequestParam("privacity") boolean privacity) throws IOException {

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-d");

        CreateUserDto userDto = CreateUserDto.builder()
                .nick(nick)
                .email(email)
                .fechaNacimiento(LocalDate.parse(fechaNacimiento, formatter))
                .password(password)
                .password2(password2)
                .privacity(privacity)
                .build();




        User saved = userEntityService.saveUser(userDto, file);

        if (saved == null)
            return ResponseEntity.badRequest().build();
        else
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(userDtoConverter.convertUserEntityToGetUserDto(saved));
    }

    /*@GetMapping("/profile/{id}")
    public ResponseEntity<?> visializarPerfif(@AuthenticationPrincipal User userPrincipal, @PathVariable UUID id) {


        return ResponseEntity.status(HttpStatus.OK)
                .body(userEntityService.visializarPerfif(userPrincipal, id));
    }*/

    @PutMapping("/profile/me")
    public ResponseEntity<?> editUser(@RequestPart("file") MultipartFile file, @Valid @RequestPart("user") CreateUserDtoEdit createUserDto, @AuthenticationPrincipal User userPrincipal) throws IOException {
        User userEditado = userEntityService.userEdit(file, createUserDto, userPrincipal);

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(userDtoConverter.convertUserEntityToGetUserDto(userEditado));
    }


}
