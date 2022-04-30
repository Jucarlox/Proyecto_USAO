package com.salesianostriana.dam.USAO_api.repository;

import com.salesianostriana.dam.USAO_api.models.Producto;
import com.salesianostriana.dam.USAO_api.users.model.User;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface ProductoRepository extends JpaRepository<Producto, Long> {



    @EntityGraph(value = "grafo-producto-propietario", type = EntityGraph.EntityGraphType.LOAD)
    List<Producto> findByPropietario(User user);
}
