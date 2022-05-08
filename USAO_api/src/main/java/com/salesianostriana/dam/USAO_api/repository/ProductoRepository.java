package com.salesianostriana.dam.USAO_api.repository;

import com.salesianostriana.dam.USAO_api.models.Producto;
import com.salesianostriana.dam.USAO_api.users.model.User;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.UUID;

public interface ProductoRepository extends JpaRepository<Producto, Long> {



    @EntityGraph(value = "grafo-producto-propietario", type = EntityGraph.EntityGraphType.LOAD)
    List<Producto> findByPropietario(User user);

    @Query(value = """
            SELECT * FROM Producto p
            WHERE p.categoria = :param
            AND p.propietario_id != :param2
            ORDER BY p.precio ASC
            LIMIT 3
            """, nativeQuery = true)
    List<Producto> busquedaGangas(@Param("param") String categoria, @Param("param2") UUID uuid);

}
