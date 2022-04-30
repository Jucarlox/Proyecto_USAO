package com.salesianostriana.dam.USAO_api.users.dto;


import com.salesianostriana.dam.USAO_api.dto.producto.GetProductoDto;
import com.salesianostriana.dam.USAO_api.dto.producto.GetProductoDto2;
import com.salesianostriana.dam.USAO_api.models.Producto;
import com.salesianostriana.dam.USAO_api.users.model.User;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;

@RequiredArgsConstructor
@Component
public class UserDtoConverter {

    public GetUserDto3 convertUserEntityToGetUserDto(User user) {


        return GetUserDto3.builder()
                .id(user.getId())
                .avatar(user.getAvatar())
                .fechaNacimiento(user.getFechaNacimiento())
                .nick(user.getNick())
                .email(user.getEmail())
                .localizacion(user.getLocalizacion())
                .role(user.getRoles())
                .build();


    }

    public GetUserDto convertUserEntityToGetUserDto2(User user, List<Producto> productoList, List<Producto> productoListLike) {

        return GetUserDto.builder()
                .id(user.getId())
                .avatar(user.getAvatar())
                .fechaNacimiento(user.getFechaNacimiento())
                .nick(user.getNick())
                .email(user.getEmail())
                .role(user.getRoles())
                .productoList(productoList.stream().map(p -> new GetProductoDto(p.getId(), p.getNombre(), p.getDescripcion(), convertUserEntityToGetUserDto(p.getPropietario()), p.getFileScale())).toList())
                .productoListLike(productoListLike.stream().map(p -> new GetProductoDto(p.getId(), p.getNombre(), p.getDescripcion(), convertUserEntityToGetUserDto(p.getPropietario()), p.getFileScale())).toList())
                .build();


    }


    public GetUserDto2 convertUserEntityToGetUserDto7(User user) {


        return GetUserDto2.builder()
                .nick(user.getNick())
                .email(user.getEmail())
                .build();


    }


    public List<GetUserDto2> convertUserEntityToGetUserDto3(List<User> userList) {


        return userList.stream().map(p -> convertUserEntityToGetUserDto7(p)).toList();


    }

}
