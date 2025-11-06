package com.upeu.moviles.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.upeu.moviles.entity.Producto;

public interface ProductoRepository extends JpaRepository<Producto, Long>{

}
