package com.salesianostriana.dam.USAO_api.controller;

import com.salesianostriana.dam.USAO_api.services.StorageService;
import com.salesianostriana.dam.USAO_api.utils.MediaTypeUrlResource;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@CrossOrigin("http://localhost:4200")
public class FileController {

    private final StorageService storageService;


    @Operation(summary = "Recoger imagen")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha recogido la imagen",
                    content = { @Content(mediaType = "application/json")}),
            @ApiResponse(responseCode = "400",
                    description = "Error al recoger la imagen",
                    content = @Content),
    })
    @GetMapping("/download/{filename:.+}")
    public ResponseEntity<Resource> getFile(@PathVariable String filename) {
        MediaTypeUrlResource resource = (MediaTypeUrlResource) storageService.loadAsResource(filename);


        return ResponseEntity.status(HttpStatus.OK)
                .header("content-type", resource.getType())
                .body(resource);


    }

}
