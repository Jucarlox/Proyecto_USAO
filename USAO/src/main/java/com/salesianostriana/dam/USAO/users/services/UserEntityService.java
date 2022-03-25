package com.salesianostriana.dam.USAO.users.services;


import com.salesianostriana.dam.USAO.errores.excepciones.DynamicException;
import com.salesianostriana.dam.USAO.errores.excepciones.SingleEntityNotFoundException;
import com.salesianostriana.dam.USAO.errores.excepciones.UnsupportedMediaType;
import com.salesianostriana.dam.USAO.models.Estado;
import com.salesianostriana.dam.USAO.services.StorageService;
import com.salesianostriana.dam.USAO.services.base.BaseService;
import com.salesianostriana.dam.USAO.users.dto.*;

import com.salesianostriana.dam.USAO.users.model.User;
import com.salesianostriana.dam.USAO.users.model.UserRole;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import com.salesianostriana.dam.USAO.users.repository.UserEntityRepository;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;

import java.util.Optional;
import java.util.UUID;


@Service("userDetailsService")
@RequiredArgsConstructor
public class UserEntityService extends BaseService<User, UUID, UserEntityRepository> implements UserDetailsService {
    private final PasswordEncoder passwordEncoder;
    private final StorageService storageService;
    private final UserEntityRepository userEntityRepository;
    private final UserDtoConverter userDtoConverter;



    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        return this.repositorio.findFirstByEmail(email).orElseThrow(() -> new UsernameNotFoundException("El " + email + " no encontrado"));
    }


    public List<User> loadUserByRol(UserRole roles) throws UsernameNotFoundException {
        return this.repositorio.findByRoles(roles);
    }

    public Optional<User> loadUserById(UUID id) throws UsernameNotFoundException {
        return this.repositorio.findById(id);
    }

    public User saveUser(CreateUserDto newUser, MultipartFile file) throws IOException {
        String extension = StringUtils.getFilenameExtension(StringUtils.cleanPath(file.getOriginalFilename()));
        List<String> imagenExtension = Arrays.asList("png", "gif", "jpg", "svg");

        if (imagenExtension.contains(extension)) {
            String filename = storageService.escalado(file, 128);

            String uri = ServletUriComponentsBuilder.fromCurrentContextPath()
                    .path("/download/")
                    .path(filename)
                    .toUriString()
                    .replace("10.0.2.2", "localhost");


                User user = User.builder()
                        .password(passwordEncoder.encode(newUser.getPassword()))
                        .avatar(uri)
                        .nick(newUser.getNick())
                        .email(newUser.getEmail())
                        .fechaNacimiento(newUser.getFechaNacimiento())
                        .roles(UserRole.USER)
                        .privacity(newUser.isPrivacity() ? Estado.PRIVADO : Estado.PUBLICO)
                        .build();
                try {
                    return save(user);
                } catch (DataIntegrityViolationException ex) {
                    throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "El nombre de ese usuario ya existe");
                }

        } else {
            throw new UnsupportedMediaType(imagenExtension);
        }

    }


    /*public GetUserDto visializarPerfif(User user, UUID id) {

        Optional<User> userBuscado = userEntityRepository.findById(id);

        if (userBuscado.isPresent()) {

            if (userBuscado.get().getPrivacity().equals(Estado.PUBLICO)) {
                return userDtoConverter.convertUserEntityToGetUserDto2(userBuscado.get(), postRepository.findByUser(userBuscado.get()));

            } else {
                for (User usuarioDeLaLista : userEntityRepository.findFollowers(userBuscado.get().getId())) {
                    if (usuarioDeLaLista.getId().equals(user.getId())) {
                        return userDtoConverter.convertUserEntityToGetUserDto2(userBuscado.get(), postRepository.findByUser(userBuscado.get()));
                    }
                }
                throw new DynamicException("Cuenta privada, no sigues al usuario");
            }
        }
        throw new SingleEntityNotFoundException(id.toString(), User.class);

    }*/


    /*public GetUserDto visializarMiPerfif(User user, UUID id) {

        Optional<User> userBuscado = userEntityRepository.findById(id);


                return userDtoConverter.convertUserEntityToGetUserDto2(userBuscado.get(), postRepository.findByUser(userBuscado.get()));



    }*/


    public User userEdit(MultipartFile file, CreateUserDtoEdit createUserDto, User userLogeado) throws IOException {


        userLogeado.setPassword(createUserDto.getPassword());
        userLogeado.setFechaNacimiento(createUserDto.getFechaNacimiento());
        userLogeado.setPrivacity(createUserDto.isPrivacity() ? Estado.PRIVADO : Estado.PUBLICO);

        String extension = StringUtils.getFilenameExtension(StringUtils.cleanPath(file.getOriginalFilename()));

        List<String> imagenExtension = Arrays.asList("png", "gif", "jpg", "svg");

        if (imagenExtension.contains(extension)) {
            String avatar = StringUtils.cleanPath(String.valueOf(userLogeado.getAvatar())).replace("http://localhost:8080/download/", "")
                    .replace("%20", " ");
            Path path = storageService.load(avatar);
            String filename = StringUtils.cleanPath(String.valueOf(path)).replace("http://localhost:8080/download/", "")
                    .replace("%20", " ");
            Path pathScalse = Paths.get(filename);
            storageService.deleteFile(pathScalse);


            String filenameAvatar = storageService.escalado(file, 128);

            String uriAvatar = ServletUriComponentsBuilder.fromCurrentContextPath()
                    .path("/download/")
                    .path(filenameAvatar)
                    .toUriString();

            userLogeado.setAvatar(uriAvatar);
        } else {
            throw new UnsupportedMediaType(imagenExtension);
        }
        return repositorio.save(userLogeado);
    }


}
