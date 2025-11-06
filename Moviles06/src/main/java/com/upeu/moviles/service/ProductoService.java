package com.upeu.moviles.service;

import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import com.upeu.moviles.entity.Producto;
import com.upeu.moviles.repository.ProductoRepository;

@Service
public class ProductoService {
	
	private final ProductoRepository productoRepository;

    public ProductoService(ProductoRepository productoRepository) {
        this.productoRepository = productoRepository;
    }

    public List<Producto> listar() {
        return productoRepository.findAll();
    }

    public Optional<Producto> obtener(Long id) {
        return productoRepository.findById(id);
    }

    public Producto guardar(Producto producto) {
        return productoRepository.save(producto);
    }

    public void eliminar(Long id) {
        productoRepository.deleteById(id);
    }
}
