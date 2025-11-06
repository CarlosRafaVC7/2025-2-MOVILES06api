import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../services/producto_service.dart';
import 'producto_form_page.dart';

class ProductosPage extends StatefulWidget {
  const ProductosPage({super.key});

  @override
  State<ProductosPage> createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage> {
  final ProductoService _productoService = ProductoService();
  List<Producto> _productos = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  Future<void> _cargarProductos() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final productos = await _productoService.getProductos();
      setState(() {
        _productos = productos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _mostrarError('Error al cargar productos: $e');
    }
  }

  Future<void> _eliminarProducto(int id) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Está seguro de eliminar este producto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      try {
        await _productoService.deleteProducto(id);
        _mostrarMensaje('Producto eliminado exitosamente');
        _cargarProductos();
      } catch (e) {
        _mostrarError('Error al eliminar producto: $e');
      }
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          IconButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductoFormPage(),
                ),
              );
              if (result == true) {
                _cargarProductos();
              }
            },
            icon: const Icon(Icons.add_circle_rounded),
            iconSize: 28,
            tooltip: 'Agregar Producto',
          ),
          const SizedBox(width: 8),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _productos.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inventory_2_rounded,
                        size: 100,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No hay productos registrados',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Toca el botón + para agregar uno',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _cargarProductos,
                  color: Theme.of(context).colorScheme.secondary,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _productos.length,
                    itemBuilder: (context, index) {
                      final producto = _productos[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductoFormPage(
                                    producto: producto,
                                  ),
                                ),
                              );
                              if (result == true) {
                                _cargarProductos();
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Header con icono, nombre y estado
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Theme.of(context).colorScheme.secondary,
                                              Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          Icons.shopping_bag_rounded,
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              producto.nombre,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.qr_code_2_rounded,
                                                  size: 16,
                                                  color: Colors.grey[600],
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  producto.codigo,
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: producto.estado
                                              ? Colors.green[50]
                                              : Colors.red[50],
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: producto.estado
                                                ? Colors.green[300]!
                                                : Colors.red[300]!,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              producto.estado
                                                  ? Icons.check_circle_rounded
                                                  : Icons.cancel_rounded,
                                              size: 16,
                                              color: producto.estado
                                                  ? Colors.green[700]
                                                  : Colors.red[700],
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              producto.estado ? 'Activo' : 'Inactivo',
                                              style: TextStyle(
                                                color: producto.estado
                                                    ? Colors.green[700]
                                                    : Colors.red[700],
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  // Descripción
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      producto.descripcion,
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  // Footer con precio y acciones
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Theme.of(context).colorScheme.primary,
                                              Theme.of(context).colorScheme.primary.withOpacity(0.8),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          'S/ ${producto.precio.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Material(
                                            color: Colors.blue[50],
                                            borderRadius: BorderRadius.circular(10),
                                            child: InkWell(
                                              borderRadius: BorderRadius.circular(10),
                                              onTap: () async {
                                                final result = await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => ProductoFormPage(
                                                      producto: producto,
                                                    ),
                                                  ),
                                                );
                                                if (result == true) {
                                                  _cargarProductos();
                                                }
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(10),
                                                child: Icon(
                                                  Icons.edit_rounded,
                                                  color: Colors.blue[700],
                                                  size: 22,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Material(
                                            color: Colors.red[50],
                                            borderRadius: BorderRadius.circular(10),
                                            child: InkWell(
                                              borderRadius: BorderRadius.circular(10),
                                              onTap: () => _eliminarProducto(producto.id!),
                                              child: Padding(
                                                padding: const EdgeInsets.all(10),
                                                child: Icon(
                                                  Icons.delete_rounded,
                                                  color: Colors.red[700],
                                                  size: 22,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
