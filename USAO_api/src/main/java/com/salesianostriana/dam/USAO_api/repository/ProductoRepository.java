package com.salesianostriana.dam.USAO_api.repository;

import com.salesianostriana.dam.USAO_api.models.Producto;
import com.salesianostriana.dam.USAO_api.users.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface ProductoRepository extends JpaRepository<Producto, Long> {

    List<Producto> findByPropietario(User user);
}
