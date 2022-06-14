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


    @Operation(summary = "Crear un Producto")
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

    @Operation(summary = "Editar un Producto")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201",
                    description = "Se ha editado un Producto",
                    content = { @Content(mediaType = "application/json",
                            schema = @Schema(implementation = Producto.class))}),
            @ApiResponse(responseCode = "400",
                    description = "Error al editar un Producto",
                    content = @Content),
    })
    @PutMapping("/producto/{id}")
    public ResponseEntity<?> editPost(@RequestPart("file") MultipartFile file, @Valid @RequestPart("producto") CreateProductoDto createPostDto, @AuthenticationPrincipal User userPrincipal, @PathVariable Long id) throws IOException, VideoException {
        Producto saved = productoService.editProducto(createPostDto, file, userPrincipal, id);

        if (saved == null)
            return ResponseEntity.badRequest().build();
        else
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(productoDtoConverter.convertProductoToGetProductoDto(saved));
    }


    @Operation(summary = "Recoger un Producto por id")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha recogido un Producto por id",
                    content = { @Content(mediaType = "application/json",
                            schema = @Schema(implementation = Producto.class))}),
            @ApiResponse(responseCode = "400",
                    description = "Error al recoger un Producto por id",
                    content = @Content),
    })
    @GetMapping("/productos/{id}")
    public ResponseEntity<GetProductoDto> productoId( @AuthenticationPrincipal User userPrincipal, @PathVariable Long id) throws IOException, VideoException {
        GetProductoDto saved = productoService.getProductoId( userPrincipal, id);

        if (saved == null)
            return ResponseEntity.badRequest().build();
        else
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(saved);
    }

    @Operation(summary = "Borrar un Producto por id")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "204",
                    description = "Se ha borrado un Producto por id",
                    content = { @Content(mediaType = "application/json",
                            schema = @Schema(implementation = Producto.class))}),
            @ApiResponse(responseCode = "400",
                    description = "Error al borrar un Producto por id",
                    content = @Content),
    })
    @DeleteMapping("/producto/{id}")
    public ResponseEntity<?> deleteProducto(@AuthenticationPrincipal User userPrincipal, @PathVariable Long id) throws IOException {
        return productoService.deleteProducto(userPrincipal, id);
    }

    @Operation(summary = "Like a un Producto por id")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201",
                    description = "Se ha dado like a un Producto por id",
                    content = { @Content(mediaType = "application/json",
                            schema = @Schema(implementation = Producto.class))}),
            @ApiResponse(responseCode = "400",
                    description = "Error al dar like un Producto por id",
                    content = @Content),
    })
    @PostMapping("/producto/like/{id}")
    public ResponseEntity<List<GetProductoDto>> likeProducto (@AuthenticationPrincipal User userPrincipal, @PathVariable Long id){
        List<GetProductoDto> getProductoDtos = productoService.likeProducto(userPrincipal, id);

        if (getProductoDtos == null)
            return ResponseEntity.badRequest().build();
        else
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(getProductoDtos);
    }

    @Operation(summary = "Recoger las gangas")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha recogido las gangas",
                    content = { @Content(mediaType = "application/json",
                            schema = @Schema(implementation = Producto.class))}),
            @ApiResponse(responseCode = "400",
                    description = "Error al recoger las gangas",
                    content = @Content),
    })
    @GetMapping("/producto/gangas")
    public ResponseEntity<List<GetProductoDto>> getGangas (@AuthenticationPrincipal User userPrincipal){
        return ResponseEntity.status(HttpStatus.OK)
                .body(productoService.getGangas(userPrincipal));
    }

    @Operation(summary = "Recoger los productos favoritos")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha recogido los productos favoritos",
                    content = { @Content(mediaType = "application/json",
                            schema = @Schema(implementation = Producto.class))}),
            @ApiResponse(responseCode = "400",
                    description = "Error al recoger los productos favoritos",
                    content = @Content),
    })
    @GetMapping("/producto/like")
    public ResponseEntity<List<GetProductoDto>> getListLike (@AuthenticationPrincipal User userPrincipal){
        return ResponseEntity.status(HttpStatus.OK)
                .body(productoService.getListLike(userPrincipal));
    }


    @Operation(summary = "Dislike a un Producto por id")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "204",
                    description = "Se ha dado dislike a un Producto por id",
                    content = { @Content(mediaType = "application/json",
                            schema = @Schema(implementation = Producto.class))}),
            @ApiResponse(responseCode = "400",
                    description = "Error al dar dislike un Producto por id",
                    content = @Content),
    })
    @DeleteMapping("/producto/dislike/{id}")
    public ResponseEntity<?> dislikeProducto (@AuthenticationPrincipal User userPrincipal, @PathVariable Long id){
        return productoService.dislikeProducto(userPrincipal, id);
    }

    @Operation(summary = "Recoger los productos filtrados")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha recogido los productos filtrados",
                    content = { @Content(mediaType = "application/json",
                            schema = @Schema(implementation = Producto.class))}),
            @ApiResponse(responseCode = "400",
                    description = "Error al recoger los productos filtrados",
                    content = @Content),
    })
    @GetMapping("producto/filtro")
    public ResponseEntity<List<GetProductoDto>> getProductosFiltrado (@AuthenticationPrincipal User userPrincipal, @RequestParam String string){
        return ResponseEntity.status(HttpStatus.OK)
                .body(productoService.getProductosFiltrado(userPrincipal, string));
    }

    @Operation(summary = "Recoger los productos ajenos")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha recogido los productos ajenos",
                    content = { @Content(mediaType = "application/json",
                            schema = @Schema(implementation = Producto.class))}),
            @ApiResponse(responseCode = "400",
                    description = "Error al recoger los productos ajenos",
                    content = @Content),
    })
    @GetMapping("producto")
    public ResponseEntity<List<GetProductoDto>> getProductosAjenos (@AuthenticationPrincipal User userPrincipal){
        return ResponseEntity.status(HttpStatus.OK)
                .body(productoService.getProductosAjenos(userPrincipal));
    }

    @Operation(summary = "Recoger los productos de una cateforia")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha recogido los productos de una cateforia",
                    content = { @Content(mediaType = "application/json",
                            schema = @Schema(implementation = Producto.class))}),
            @ApiResponse(responseCode = "400",
                    description = "Error al recoger los productos de una cateforia",
                    content = @Content),
    })
    @GetMapping("producto/{categoria}")
    public ResponseEntity<List<GetProductoDto>> getProductosAjenos (@AuthenticationPrincipal User userPrincipal, @PathVariable String categoria){
        return ResponseEntity.status(HttpStatus.OK)
                .body(productoService.getProductosCategoria(userPrincipal,categoria));
    }

}
