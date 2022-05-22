package com.salesianostriana.dam.USAO_api.users.model;

import com.salesianostriana.dam.USAO_api.models.Producto;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.GenericGenerator;
import org.hibernate.annotations.NaturalId;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import javax.persistence.*;
import java.time.LocalDate;
import java.util.*;


@Entity
@EntityListeners(AuditingEntityListener.class)
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User implements UserDetails {
    @Id
    @GeneratedValue(generator = "UUID")
    @GenericGenerator(
            name = "UUID",
            strategy = "org.hibernate.id.UUIDGenerator",
            parameters = {
                    @org.hibernate.annotations.Parameter(
                            name = "uuid_gen_strategy_class",
                            value = "org.hibernate.id.uuid.CustomVersionOneStrategy"
                    )
            }
    )
    @Column(name = "id", updatable = false, nullable = false)
    private UUID id;

    @NaturalId
    @Column(unique = true, updatable = false)

    private String email;
    private String password;
    private String nick;
    private LocalDate fechaNacimiento;

    @Enumerated(EnumType.STRING)
    private UserRole roles;

    private String avatar;

    private String localizacion;

    @Builder.Default
    @OneToMany(mappedBy = "propietario")
    private List<Producto> productoList = new ArrayList<>();

    @Builder.Default
    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(name = "like_table", joinColumns = @JoinColumn(name = "user_id"), inverseJoinColumns = @JoinColumn(name = "producto_id"))
    private List<Producto> productosLike = new ArrayList<>();


    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return List.of(new SimpleGrantedAuthority("ROLE_" + roles.name()));
    }


    @Override
    public String getUsername() {
        return email;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }

    public void Like(Producto b) {
        productosLike.add(b);
        b.getUsuariosLike().add(this);
    }

    public void removeLike(Producto b) {
        productosLike.remove(b);
        b.getUsuariosLike().remove(this);
    }







}