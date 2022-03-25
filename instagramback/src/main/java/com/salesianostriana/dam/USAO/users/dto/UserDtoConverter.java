package com.salesianostriana.dam.USAO.users.dto;


import com.salesianostriana.dam.USAO.users.model.User;
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
                .estado(user.getPrivacity())
                .build();


    }

    /*public GetUserDto convertUserEntityToGetUserDto2(User user, List<Post> postList) {

        return GetUserDto.builder()
                .id(user.getId())
                .avatar(user.getAvatar())
                .fechaNacimiento(user.getFechaNacimiento())
                .nick(user.getNick())
                .email(user.getEmail())
                .estado(user.getPrivacity())
                .postList(postList.stream().map(p -> new GetPostDto(p.getId(), p.getTitle(), p.getDescripcion(), p.getFileScale(), p.getPrivacity(), convertUserEntityToGetUserDto(p.getUser()))).toList())
                .build();


    }*/


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
