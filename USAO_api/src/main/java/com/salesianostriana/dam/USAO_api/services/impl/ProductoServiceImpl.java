package com.salesianostriana.dam.USAO_api.services.impl;

import com.salesianostriana.dam.USAO_api.dto.producto.CreateProductoDto;
import com.salesianostriana.dam.USAO_api.dto.producto.GetProductoDto;
import com.salesianostriana.dam.USAO_api.dto.producto.ProductoDtoConverter;
import com.salesianostriana.dam.USAO_api.errores.excepciones.DynamicException;
import com.salesianostriana.dam.USAO_api.errores.excepciones.SingleEntityNotFoundException;
import com.salesianostriana.dam.USAO_api.errores.excepciones.UnsupportedMediaType;
import com.salesianostriana.dam.USAO_api.models.Producto;
import com.salesianostriana.dam.USAO_api.repository.ProductoRepository;
import com.salesianostriana.dam.USAO_api.services.StorageService;
import com.salesianostriana.dam.USAO_api.users.dto.GetUserDto3;
import com.salesianostriana.dam.USAO_api.users.dto.UserDtoConverter;
import com.salesianostriana.dam.USAO_api.users.model.User;
import com.salesianostriana.dam.USAO_api.users.repository.UserEntityRepository;
import io.github.techgnious.exception.VideoException;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;


@Service
@RequiredArgsConstructor
public class ProductoServiceImpl {

    private final ProductoRepository productoRepository;
    private final UserEntityRepository userEntityRepository;
    private final StorageService storageService;
    private final ProductoDtoConverter productoDtoConverter;
    private final UserDtoConverter userDtoConverter;

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
                .categoria(newProducto.getCategoria())
                .precio(newProducto.getPrecio())
                .fileOriginal(uriOriginal)
                .fileScale(uriPublicacion)
                .propietario(user)
                .build();
        return productoRepository.save(producto);
    }


    public Producto editProducto(CreateProductoDto newPost, MultipartFile file, User user, Long id) throws IOException, VideoException {


        Optional<Producto> producto = productoRepository.findById(id);

        if (producto.isEmpty()) {
            throw new SingleEntityNotFoundException(id.toString(), Producto.class);
        } else {
            if(producto.get().getPropietario().getNick().equals(user.getNick())){
                producto.get().setDescripcion(newPost.getDescripcion());
                producto.get().setNombre(newPost.getNombre());



                String videoExtension = "mp4";
                String extension = StringUtils.getFilenameExtension(StringUtils.cleanPath(file.getOriginalFilename()));
                List<String> allExtension = Arrays.asList("png", "gif", "jpg", "svg", "mp4");

                if (!allExtension.contains(extension)) {
                    throw new UnsupportedMediaType(allExtension);
                } else {
                    String scale = StringUtils.cleanPath(String.valueOf(producto.get().getFileScale())).replace("http://localhost:8080/download/", "")
                            .replace("%20", " ");
                    Path path = storageService.load(scale);
                    String filename = StringUtils.cleanPath(String.valueOf(path)).replace("http://localhost:8080/download/", "")
                            .replace("%20", " ");
                    Path pathScalse = Paths.get(filename);
                    storageService.deleteFile(pathScalse);


                    String original = StringUtils.cleanPath(String.valueOf(producto.get().getFileOriginal())).replace("http://localhost:8080/download/", "")
                            .replace("%20", " ");
                    Path path2 = storageService.load(original);
                    String filename2 = StringUtils.cleanPath(String.valueOf(path2)).replace("http://localhost:8080/download/", "")
                            .replace("%20", " ");
                    Path pathOriginal = Paths.get(filename2);
                    storageService.deleteFile(pathOriginal);


                    String filenameOriginal = storageService.original(file);
                    String filenamePublicacion;
                    if (!videoExtension.contains(extension)) {
                        filenamePublicacion = storageService.escalado(file, 1024);

                    } else {
                        filenamePublicacion = storageService.videoEscalado(file);
                    }

                    String uriPublicacion = ServletUriComponentsBuilder.fromCurrentContextPath()
                            .path("/download/")
                            .path(filenamePublicacion)
                            .toUriString();

                    String uriOriginal = ServletUriComponentsBuilder.fromCurrentContextPath()
                            .path("/download/")
                            .path(filenameOriginal)
                            .toUriString();

                    producto.get().setFileOriginal(uriOriginal);
                    producto.get().setFileScale(uriPublicacion);

                }
            }else {
                throw new DynamicException("No eres propietario de este post");
            }

            return productoRepository.save(producto.get());
        }
    }


    public ResponseEntity deleteProducto(User user, Long id) throws IOException {
        Optional<Producto> producto = productoRepository.findById(id);
        if (producto.isEmpty()) {
            throw new SingleEntityNotFoundException(id.toString(), Producto.class);
        } else {
            if(producto.get().getPropietario().getNick().equals(user.getNick())){
                String scale = StringUtils.cleanPath(String.valueOf(producto.get().getFileScale())).replace("https://usao-back.herokuapp.com/download/", "")
                        .replace("%20", " ");
                Path path = storageService.load(scale);
                String filename = StringUtils.cleanPath(String.valueOf(path)).replace("https://usao-back.herokuapp.com/download/", "")
                        .replace("%20", " ");
                Path pathScalse = Paths.get(filename);
                storageService.deleteFile(pathScalse);


                String original = StringUtils.cleanPath(String.valueOf(producto.get().getFileOriginal())).replace("https://usao-back.herokuapp.com/download/", "")
                        .replace("%20", " ");
                Path path2 = storageService.load(original);
                String filename2 = StringUtils.cleanPath(String.valueOf(path2)).replace("https://usao-back.herokuapp.com/download/", "")
                        .replace("%20", " ");
                Path pathOriginal = Paths.get(filename2);
                storageService.deleteFile(pathOriginal);




                productoRepository.deleteById(id);

                return ResponseEntity.noContent().build();
            }else {
                throw new DynamicException("No eres propietario de este post");
            }


        }
    }


    public List<GetProductoDto> likeProducto(User user, Long id){

        Optional<Producto> producto = productoRepository.findById(id);

        if(producto.isPresent()){
            user.getProductosLike().add(producto.get());
            userEntityRepository.save(user);




            List<GetProductoDto> getProductoDtos = user.getProductosLike().stream().map(p -> new GetProductoDto(p.getId(), p.getNombre(), p.getDescripcion(), p.getCategoria(), p.getPrecio(), userDtoConverter.convertUserEntityToGetUserDto(p.getPropietario()), p.getFileScale())).toList();
            return getProductoDtos;



        }else{
            throw new SingleEntityNotFoundException(id.toString(), Producto.class);
        }
    }


    public List<GetProductoDto> getGangas(User user){



            List<Producto> listGangas= new ArrayList<>();


            listGangas.addAll(productoRepository.busquedaGangas("coches", user.getId()));
            listGangas.addAll(productoRepository.busquedaGangas("motos", user.getId()));
            listGangas.addAll(productoRepository.busquedaGangas("moda", user.getId()));
            listGangas.addAll(productoRepository.busquedaGangas("inmobiliaria", user.getId()));
            listGangas.addAll(productoRepository.busquedaGangas("informatica y electronica", user.getId()));
            listGangas.addAll(productoRepository.busquedaGangas("deporte", user.getId()));




            List<GetProductoDto> getProductoDtos = listGangas.stream().map(p -> new GetProductoDto(p.getId(), p.getNombre(), p.getDescripcion(), p.getCategoria(), p.getPrecio(), userDtoConverter.convertUserEntityToGetUserDto(p.getPropietario()), p.getFileScale())).toList();

            return getProductoDtos;



    }




}
