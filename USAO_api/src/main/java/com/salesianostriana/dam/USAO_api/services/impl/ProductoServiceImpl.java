package com.salesianostriana.dam.USAO_api.services.impl;

import com.salesianostriana.dam.USAO_api.dto.producto.CreateProductoDto;
import com.salesianostriana.dam.USAO_api.errores.excepciones.UnsupportedMediaType;
import com.salesianostriana.dam.USAO_api.models.Producto;
import com.salesianostriana.dam.USAO_api.repository.ProductoRepository;
import com.salesianostriana.dam.USAO_api.services.StorageService;
import com.salesianostriana.dam.USAO_api.users.model.User;
import io.github.techgnious.exception.VideoException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;


@Service
@RequiredArgsConstructor
public class ProductoServiceImpl {

    private final ProductoRepository productoRepository;
    private final StorageService storageService;

    public Producto saveProducto(CreateProductoDto newProducto, MultipartFile file, User user) throws IOException, VideoException {
        String filenameOriginal = storageService.original(file);

        String videoExtension = "mp4";

        String extension = StringUtils.getFilenameExtension(StringUtils.cleanPath(file.getOriginalFilename()));
        List<String> imagenExtension = Arrays.asList("png", "gif", "jpg", "svg");
        String filenamePublicacion;

        if (imagenExtension.contains(extension)) {
            filenamePublicacion = storageService.escalado(file, 1024);

        } else{

            throw new UnsupportedMediaType(imagenExtension);
        }


        String uriPublicacion = ServletUriComponentsBuilder.fromCurrentContextPath()
                .path("/download/")
                .path(filenamePublicacion)
                .toUriString()
                .replace("10.0.2.2", "localhost");

        String uriOriginal = ServletUriComponentsBuilder.fromCurrentContextPath()
                .path("/download/")
                .path(filenameOriginal)
                .toUriString()
                .replace("10.0.2.2", "localhost");

        Producto producto = Producto.builder()
                .nombre(newProducto.getNombre())
                .descripcion(newProducto.getDescripcion())
                .fileOriginal(uriOriginal)
                .fileScale(uriPublicacion)
                .propietario(user)
                .build();
        return productoRepository.save(producto);
    }
}
