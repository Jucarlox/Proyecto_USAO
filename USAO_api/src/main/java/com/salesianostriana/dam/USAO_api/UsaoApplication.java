package com.salesianostriana.dam.USAO_api;

import com.salesianostriana.dam.USAO_api.config.StorageProperties;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;

@EnableConfigurationProperties(StorageProperties.class)
@SpringBootApplication
public class
UsaoApplication {

	public static void main(String[] args) {
		SpringApplication.run(UsaoApplication.class, args);
	}

}
