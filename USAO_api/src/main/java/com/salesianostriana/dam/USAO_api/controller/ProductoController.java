package com.salesianostriana.dam.USAO_api.controller;

import com.salesianostriana.dam.USAO_api.dto.producto.CreateProductoDto;
import com.salesianostriana.dam.USAO_api.dto.producto.GetProductoDto;
import com.salesianostriana.dam.USAO_api.dto.producto.ProductoDtoConverter;
import com.salesianostriana.dam.USAO_api.models.Producto;
import com.salesianostriana.dam.USAO_api.services.impl.ProductoServiceImpl;
import com.salesianostriana.dam.USAO_api.users.dto.CreateUserDto;
import com.salesianostriana.dam.USAO_api.users.model.User;
import io.github.techgnious.exception.VideoException;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.validation.Valid;
import java.io.IOException;
import java.util.List;

@RestController
@RequiredArgsConstructor
@CrossOrigin("http://localhost:4200")
public class ProductoController {


    //asdasd
    private final ProductoServiceImpl productoService;
    private final ProductoDtoConverter productoDtoConverter;


    @Operation(summary = "Crea un Producto")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201",
                    description = "Se ha creado un Producto",
                    content = { @Content(mediaType = "application/json",
                            schema = @Schema(implementation = Producto.class))}),
            @ApiResponse(responseCode = "400",
                    description = "Error al crear un Producto",
                    content = @Content),
    })

    @PostMapping("/producto")
    public ResponseEntity<GetProductoDto> nuevoProducto(@RequestPart("file") MultipartFile file, @Valid @RequestPart("producto") CreateProductoDto productoDto , @AuthenticationPrincipal User userPrincipal) throws IOException, VideoException {
        Producto saved = productoService.saveProducto(productoDto, file, userPrincipal);
        if (saved == null)
            return ResponseEntity.badRequest().build();
        else
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(productoDtoConverter.convertProductoToGetProductoDto(saved));
    }

    @PutMapping("/producto/{id}")
    public ResponseEntity<?> editPost(@RequestPart("file") MultipartFile file, @Valid @RequestPart("producto") CreateProductoDto createPostDto, @AuthenticationPrincipal User userPrincipal, @PathVariable Long id) throws IOException, VideoException {
        Producto saved = productoService.editProducto(createPostDto, file, userPrincipal, id);

        if (saved == null)
            return ResponseEntity.badRequest().build();
        else
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(productoDtoConverter.convertProductoToGetProductoDto(saved));
    }

    @GetMapping("/productos/{id}")
    public ResponseEntity<GetProductoDto> productoId( @AuthenticationPrincipal User userPrincipal, @PathVariable Long id) throws IOException, VideoException {
        GetProductoDto saved = productoService.getProductoId( userPrincipal, id);

        if (saved == null)
            return ResponseEntity.badRequest().build();
        else
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(saved);
    }

    @DeleteMapping("/producto/{id}")
    public ResponseEntity<?> deleteProducto(@AuthenticationPrincipal User userPrincipal, @PathVariable Long id) throws IOException {
        return productoService.deleteProducto(userPrincipal, id);
    }


    @PostMapping("/producto/like/{id}")
    public ResponseEntity<List<GetProductoDto>> likeProducto (@AuthenticationPrincipal User userPrincipal, @PathVariable Long id){
        List<GetProductoDto> getProductoDtos = productoService.likeProducto(userPrincipal, id);

        if (getProductoDtos == null)
            return ResponseEntity.badRequest().build();
        else
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(getProductoDtos);
    }


    @GetMapping("/producto/gangas")
    public ResponseEntity<List<GetProductoDto>> getGangas (@AuthenticationPrincipal User userPrincipal){
        return ResponseEntity.status(HttpStatus.OK)
                .body(productoService.getGangas(userPrincipal));
    }


    @GetMapping("/producto/like")
    public ResponseEntity<List<GetProductoDto>> getListLike (@AuthenticationPrincipal User userPrincipal){
        return ResponseEntity.status(HttpStatus.OK)
                .body(productoService.getListLike(userPrincipal));
    }



    @DeleteMapping("/producto/dislike/{id}")
    public ResponseEntity<?> dislikeProducto (@AuthenticationPrincipal User userPrincipal, @PathVariable Long id){
        return productoService.dislikeProducto(userPrincipal, id);
    }


    @GetMapping("producto/filtro")
    public ResponseEntity<List<GetProductoDto>> getProductosFiltrado (@AuthenticationPrincipal User userPrincipal, @RequestParam String string){
        return ResponseEntity.status(HttpStatus.OK)
                .body(productoService.getProductosFiltrado(userPrincipal, string));
    }

    @GetMapping("producto")
    public ResponseEntity<List<GetProductoDto>> getProductosAjenos (@AuthenticationPrincipal User userPrincipal){
        return ResponseEntity.status(HttpStatus.OK)
                .body(productoService.getProductosAjenos(userPrincipal));
    }

    @GetMapping("producto/{categoria}")
    public ResponseEntity<List<GetProductoDto>> getProductosAjenos (@AuthenticationPrincipal User userPrincipal, @PathVariable String categoria){
        return ResponseEntity.status(HttpStatus.OK)
                .body(productoService.getProductosCategoria(userPrincipal,categoria));
    }

}
