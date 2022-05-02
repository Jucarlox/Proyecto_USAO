package com.salesianostriana.dam.USAO_api.models;

import com.salesianostriana.dam.USAO_api.users.model.User;
import lombok.*;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;


@NamedEntityGraph(
        name = "grafo-producto-propietario",
        attributeNodes = {
                @NamedAttributeNode("propietario")
        }
)



@Entity
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Builder
public class Producto {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    private String nombre;

    private String descripcion;

    private double precio;

    private String categoria;

    private String fileOriginal;

    private String fileScale;

    @ManyToOne(fetch = FetchType.EAGER)
    private User propietario;

    @PreRemove
    public void borrarProducto(){
        propietario.setProductosLike(null);
    }


}
