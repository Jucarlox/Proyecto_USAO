package com.salesianostriana.dam.USAO_api.users.repository;


import com.salesianostriana.dam.USAO_api.users.model.User;
import com.salesianostriana.dam.USAO_api.users.model.UserRole;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface UserEntityRepository extends JpaRepository<User, UUID> {

    Optional<User> findFirstByEmail(String email);

    Optional<User> findById(UUID id);

    Optional<User> findByNick(String nick);

    List<User> findByRoles(UserRole roles);



    boolean existsByNick(String nick);

    boolean existsByEmail(String email);




}
