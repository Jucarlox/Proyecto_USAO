package com.salesianostriana.dam.USAO_api.controller;

import com.salesianostriana.dam.USAO_api.dto.producto.CreateProductoDto;
import com.salesianostriana.dam.USAO_api.dto.producto.GetProductoDto;
import com.salesianostriana.dam.USAO_api.dto.producto.ProductoDtoConverter;
import com.salesianostriana.dam.USAO_api.models.Producto;
import com.salesianostriana.dam.USAO_api.services.impl.ProductoServiceImpl;
import com.salesianostriana.dam.USAO_api.users.dto.CreateUserDto;
import com.salesianostriana.dam.USAO_api.users.model.User;
import io.github.techgnious.exception.VideoException;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import javax.validation.Valid;
import java.io.IOException;

@RestController
@RequiredArgsConstructor
@CrossOrigin("http://localhost:4200")
public class ProductoController {

    private final ProductoServiceImpl productoService;
    private final ProductoDtoConverter productoDtoConverter;

    @PostMapping("/producto")
    public ResponseEntity<GetProductoDto> nuevoProducto(@RequestPart("file") MultipartFile file, @Valid @RequestPart("producto") CreateProductoDto productoDto , @AuthenticationPrincipal User userPrincipal) throws IOException, VideoException {
        Producto saved = productoService.saveProducto(productoDto, file, userPrincipal);
        if (saved == null)
            return ResponseEntity.badRequest().build();
        else
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(productoDtoConverter.convertProductoToGetPostDto(saved));
    }
}
