package com.upeu.moviles.controller;

import java.util.List;



import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.upeu.moviles.entity.Producto;
import com.upeu.moviles.service.ProductoService;

@RestController
@RequestMapping("api/productos")
public class ProductoController {
	
	private final ProductoService productoService;

    public ProductoController(ProductoService productoService) {
        this.productoService = productoService;
    }

    @GetMapping
    public List<Producto> listar() {
        return productoService.listar();
    }

    @PostMapping
    public Producto crear(@RequestBody Producto producto) {
        return productoService.guardar(producto);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Producto> actualizar(@PathVariable Long id, @RequestBody Producto producto) {
        return productoService.obtener(id)
                .map(p -> {
                    p.setNombre(producto.getNombre());
                    p.setCodigo(producto.getCodigo());
                    p.setDescripcion(producto.getDescripcion());
                    p.setPrecio(producto.getPrecio());
                    p.setEstado(producto.getEstado());
                    return ResponseEntity.ok(productoService.guardar(p));
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public void eliminar(@PathVariable Long id) {
        productoService.eliminar(id);
    }
}
