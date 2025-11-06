import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/producto.dart';

class ProductoService {
  final String baseUrl = 'http://10.0.2.2:8080/api/productos';

  Future<List<Producto>> getProductos() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Producto.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar productos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<Producto> createProducto(Producto producto) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(producto.toJson()),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Producto.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al crear producto: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<Producto> updateProducto(int id, Producto producto) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(producto.toJson()),
      );
      
      if (response.statusCode == 200) {
        return Producto.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al actualizar producto: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<void> deleteProducto(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Error al eliminar producto: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
