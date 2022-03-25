package com.salesianostriana.dam.USAO.users.repository;


import com.salesianostriana.dam.USAO.users.model.User;
import com.salesianostriana.dam.USAO.users.model.UserRole;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

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
