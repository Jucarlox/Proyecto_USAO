package com.salesianostriana.dam.USAO_api.users.services;


import com.salesianostriana.dam.USAO_api.errores.excepciones.DynamicException;
import com.salesianostriana.dam.USAO_api.errores.excepciones.SingleEntityNotFoundException;
import com.salesianostriana.dam.USAO_api.errores.excepciones.UnsupportedMediaType;
import com.salesianostriana.dam.USAO_api.repository.ProductoRepository;
import com.salesianostriana.dam.USAO_api.services.StorageService;
import com.salesianostriana.dam.USAO_api.services.base.BaseService;
import com.salesianostriana.dam.USAO_api.users.dto.*;

import com.salesianostriana.dam.USAO_api.users.model.User;
import com.salesianostriana.dam.USAO_api.users.model.UserRole;
import lombok.RequiredArgsConstructor;
import org.springframework.core.convert.converter.GenericConverter;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import com.salesianostriana.dam.USAO_api.users.repository.UserEntityRepository;
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
    private final ProductoRepository productoRepository;


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
                    .roles(newUser.isCategoria() ? UserRole.ADMIN : UserRole.USER)
                    .localizacion(newUser.getLocalizacion())
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


    public GetUserDto visializarPerfif(User user, UUID id) {

        Optional<User> userBuscado = userEntityRepository.findById(id);

        if (userBuscado.isPresent()) {

            if (userBuscado.get().getRoles().equals(UserRole.USER)) {
                return userDtoConverter.convertUserEntityToGetUserDto2(userBuscado.get(), productoRepository.findByPropietario(userBuscado.get()), userBuscado.get().getProductosLike());
            }

        }
        throw new SingleEntityNotFoundException(id.toString(), User.class);

    }


    public GetUserDto visializarMiPerfif(User user, UUID id) {

        Optional<User> userBuscado = userEntityRepository.findById(id);


        return userDtoConverter.convertUserEntityToGetUserDto2(userBuscado.get(), productoRepository.findByPropietario(userBuscado.get()), userBuscado.get().getProductosLike());


    }


    public User userEdit(MultipartFile file, CreateUserDtoEdit createUserDto, User userLogeado) throws IOException {


        userLogeado.setPassword(createUserDto.getPassword());
        userLogeado.setFechaNacimiento(createUserDto.getFechaNacimiento());
        userLogeado.setLocalizacion(createUserDto.getLocalizacion());
        userLogeado.setNick(createUserDto.getNick());

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


    public ResponseEntity deleteUser(User user, UUID uuid) throws IOException {

        if (user.getRoles().equals(UserRole.ADMIN)) {


            String file = StringUtils.cleanPath(String.valueOf(user.getAvatar())).replace("http://localhost:8080/download/", "")
                    .replace("%20", " ");

            if (!file.contains("download")) {

                userEntityRepository.deleteById(uuid);
                return ResponseEntity.noContent().build();
            } else {
                Path path = storageService.load(file);
                String filename = StringUtils.cleanPath(String.valueOf(path)).replace("http://localhost:8080/download/", "")
                        .replace("%20", " ");
                Path pathFile = Paths.get(filename);
                storageService.deleteFile(pathFile);



                userEntityRepository.deleteById(uuid);
                return ResponseEntity.noContent().build();
            }
        } else {
            throw new DynamicException("El usuario no es ADMIN");
        }
    }


    public List<GetUserDto3> listUsers() {

        List<User> listUsers = userEntityRepository.findByRoles(UserRole.USER);

        List<GetUserDto3> userDto3List = listUsers.stream().map(u -> new GetUserDto3(u.getId(), u.getAvatar(), u.getEmail(), u.getLocalizacion(), u.getFechaNacimiento(), u.getNick(), u.getRoles())).toList();
        return userDto3List;


    }


}
