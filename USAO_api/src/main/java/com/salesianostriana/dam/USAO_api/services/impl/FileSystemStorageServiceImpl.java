package com.salesianostriana.dam.USAO_api.services.impl;

import com.salesianostriana.dam.USAO_api.config.StorageProperties;
import com.salesianostriana.dam.USAO_api.errores.excepciones.FileNotFoundException;
import com.salesianostriana.dam.USAO_api.errores.excepciones.StorageException;
import com.salesianostriana.dam.USAO_api.services.StorageService;

import com.salesianostriana.dam.USAO_api.utils.MediaTypeUrlResource;


import io.github.techgnious.IVCompressor;
import io.github.techgnious.dto.IVAudioAttributes;
import io.github.techgnious.dto.IVSize;
import io.github.techgnious.dto.IVVideoAttributes;
import io.github.techgnious.dto.VideoFormats;
import io.github.techgnious.exception.VideoException;
import org.imgscalr.Scalr;
import org.springframework.stereotype.Service;
import org.springframework.util.FileSystemUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.PostConstruct;
import javax.imageio.ImageIO;

import org.springframework.core.io.Resource;

import java.awt.image.BufferedImage;
import java.io.*;
import java.net.MalformedURLException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.stream.Stream;

@Service
public class FileSystemStorageServiceImpl implements StorageService {

    private final Path rootLocation;

    public static BufferedImage simpleImageResizer(BufferedImage bufferedImage, int targetWisth) {
        return Scalr.resize(bufferedImage, targetWisth);
    }

    public FileSystemStorageServiceImpl(StorageProperties storageProperties) {
        this.rootLocation = Paths.get(storageProperties.getLocation());
    }

    @PostConstruct
    @Override
    public void init() {
        try {
            Files.createDirectories(rootLocation);
        } catch (IOException e) {
            throw new StorageException("Could not initialize storage location", e);
        }
    }

    @Override
    public String original(MultipartFile file) {
        String filename = StringUtils.cleanPath(file.getOriginalFilename());
        String newFilename = "";


        try {

            if (file.isEmpty())
                throw new StorageException("El fichero subido está vacío");

            newFilename = filename;
            while (Files.exists(rootLocation.resolve(newFilename))) {

                String extension = StringUtils.getFilenameExtension(newFilename);
                String name = newFilename.replace("." + extension, "");

                String suffix = Long.toString(System.currentTimeMillis());
                suffix = suffix.substring(suffix.length() - 6);

                newFilename = name + "_" + suffix + "." + extension;
            }
            try (InputStream inputStream = file.getInputStream()) {
                Files.copy(inputStream, rootLocation.resolve(newFilename),
                        StandardCopyOption.REPLACE_EXISTING);
            }
        } catch (IOException ex) {
            throw new StorageException("Error en el almacenamiento del fichero: " + newFilename, ex);
        }

        return newFilename;

    }

    @Override
    public String escalado(MultipartFile file, int size) throws IOException {
        String filename = StringUtils.cleanPath(file.getOriginalFilename());

        String extension = StringUtils.getFilenameExtension(filename);
        String name = filename.replace("." + extension, "");

        BufferedImage img = ImageIO.read(file.getInputStream());

        BufferedImage escaleImg = simpleImageResizer(img, size);

        ByteArrayOutputStream baos = new ByteArrayOutputStream();

        ImageIO.write(escaleImg, extension, baos);

        InputStream inputStream2 = new ByteArrayInputStream(baos.toByteArray());

        try {
            if (file.isEmpty())
                throw new StorageException("El fichero subido está vacío");


            while (Files.exists(rootLocation.resolve(filename))) {
                String suffix = Long.toString(System.currentTimeMillis());
                suffix = suffix.substring(suffix.length() - 6);

                filename = name + "_" + suffix + "." + extension;
            }
            try (InputStream inputStream = inputStream2) {
                Files.copy(inputStream, rootLocation.resolve(filename),
                        StandardCopyOption.REPLACE_EXISTING);
            }

        } catch (IOException ex) {
            throw new StorageException("Error en el almacenamiento del fichero: " + filename, ex);
        }
        return filename;
    }

    @Override
    public String videoEscalado(MultipartFile file) throws IOException, VideoException {

        String filename = StringUtils.cleanPath(file.getOriginalFilename());
        String extension = StringUtils.getFilenameExtension(filename);
        String name = filename.replace("." + extension, "");

        IVCompressor compressor = new IVCompressor();
        IVSize customRes = new IVSize();
        customRes.setWidth(400);
        customRes.setHeight(300);
        IVAudioAttributes audioAttribute = new IVAudioAttributes();

        audioAttribute.setBitRate(64000);
        audioAttribute.setChannels(2);
        audioAttribute.setSamplingRate(44100);
        IVVideoAttributes videoAttribute = new IVVideoAttributes();

        videoAttribute.setBitRate(160000);

        videoAttribute.setFrameRate(15);
        videoAttribute.setSize(customRes);


        byte[] video = compressor.encodeVideoWithAttributes(file.getBytes(), VideoFormats.MP4, audioAttribute, videoAttribute);

        InputStream inputStreamEscalado = new ByteArrayInputStream(video);
        try {
            if (file.isEmpty())
                throw new StorageException("El fichero subido está vacío");


            while (Files.exists(rootLocation.resolve(filename))) {
                String suffix = Long.toString(System.currentTimeMillis());
                suffix = suffix.substring(suffix.length() - 6);

                filename = name + "_" + suffix + "." + extension;
            }
            try (InputStream inputStream = inputStreamEscalado) {
                Files.copy(inputStream, rootLocation.resolve(filename),
                        StandardCopyOption.REPLACE_EXISTING);
            }

        } catch (IOException ex) {
            throw new StorageException("Error en el almacenamiento del fichero: " + filename, ex);
        }

        return filename;

    }


    @Override
    public Stream<Path> loadAll() {
        try {
            return Files.walk(this.rootLocation, 1)
                    .filter(path -> !path.equals(this.rootLocation))
                    .map(this.rootLocation::relativize);
        } catch (IOException e) {
            throw new StorageException("Error al leer los ficheros almacenados", e);
        }
    }

    @Override
    public Path load(String filename) {
        return rootLocation.resolve(filename);
    }

    @Override
    public Resource loadAsResource(String filename) {

        try {
            Path file = load(filename);
            MediaTypeUrlResource resource = new MediaTypeUrlResource(file.toUri());
            if (resource.exists() || resource.isReadable()) {
                return resource;
            } else {
                throw new FileNotFoundException(
                        "Could not read file: " + filename);
            }
        } catch (MalformedURLException e) {
            throw new FileNotFoundException("Could not read file: " + filename, e);
        }
    }

    @Override
    public void deleteFile(Path filename) throws IOException {

        MediaTypeUrlResource mediaTypeUrlResource = new MediaTypeUrlResource(filename.toUri());
        try {
            if (mediaTypeUrlResource.exists() || mediaTypeUrlResource.isReadable()) {
                Files.delete(filename);
            } else {
                throw new FileNotFoundException(
                        "Could not read file: " + filename);
            }
        } catch (MalformedURLException e) {
            throw new FileNotFoundException("Could not read file: " + filename, e);
        }

    }

    @Override
    public void deleteAll() {
        FileSystemUtils.deleteRecursively(rootLocation.toFile());
    }


}
