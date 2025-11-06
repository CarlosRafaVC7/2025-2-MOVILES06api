import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../services/producto_service.dart';

class ProductoFormPage extends StatefulWidget {
  final Producto? producto;

  const ProductoFormPage({super.key, this.producto});

  @override
  State<ProductoFormPage> createState() => _ProductoFormPageState();
}

class _ProductoFormPageState extends State<ProductoFormPage> {
  final _formKey = GlobalKey<FormState>();
  final ProductoService _productoService = ProductoService();

  late TextEditingController _codigoController;
  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  late TextEditingController _precioController;
  bool _estado = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _codigoController = TextEditingController(text: widget.producto?.codigo ?? '');
    _nombreController = TextEditingController(text: widget.producto?.nombre ?? '');
    _descripcionController = TextEditingController(text: widget.producto?.descripcion ?? '');
    _precioController = TextEditingController(text: widget.producto?.precio.toString() ?? '');
    _estado = widget.producto?.estado ?? true;
  }

  @override
  void dispose() {
    _codigoController.dispose();
    _nombreController.dispose();
    _descripcionController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  Future<void> _guardarProducto() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final producto = Producto(
        id: widget.producto?.id,
        codigo: _codigoController.text,
        nombre: _nombreController.text,
        descripcion: _descripcionController.text,
        precio: double.parse(_precioController.text),
        estado: _estado,
      );

      if (widget.producto == null) {
        await _productoService.createProducto(producto);
        _mostrarMensaje('Producto creado exitosamente');
      } else {
        await _productoService.updateProducto(widget.producto!.id!, producto);
        _mostrarMensaje('Producto actualizado exitosamente');
      }

      Navigator.pop(context, true);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _mostrarError('Error al guardar producto: $e');
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
    final isEditing = widget.producto != null;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isEditing ? Icons.edit_note_rounded : Icons.add_business_rounded),
            const SizedBox(width: 8),
            Text(isEditing ? 'Editar Producto' : 'Nuevo Producto'),
          ],
        ),
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
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Código
                    TextFormField(
                      controller: _codigoController,
                      decoration: InputDecoration(
                        labelText: 'Código del Producto',
                        hintText: 'Ej: PROD-001',
                        prefixIcon: const Icon(Icons.qr_code_scanner_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el código';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Nombre
                    TextFormField(
                      controller: _nombreController,
                      decoration: InputDecoration(
                        labelText: 'Nombre del Producto',
                        hintText: 'Ej: Peluche de Unicornio',
                        prefixIcon: const Icon(Icons.shopping_bag_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el nombre';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Descripción (sin icono)
                    TextFormField(
                      controller: _descripcionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Descripción',
                        hintText: 'Describe las características del producto',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese la descripción';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Precio (sin icono de moneda, solo prefijo)
                    TextFormField(
                      controller: _precioController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Precio (Soles)',
                        hintText: '0.00',
                        prefixText: 'S/ ',
                        prefixStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el precio';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Por favor ingrese un precio válido';
                        }
                        if (double.parse(value) <= 0) {
                          return 'El precio debe ser mayor a 0';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Estado
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _estado ? Colors.green[50]! : Colors.red[50]!,
                            _estado ? Colors.green[100]! : Colors.red[100]!,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _estado ? Colors.green[300]! : Colors.red[300]!,
                          width: 1.5,
                        ),
                      ),
                      child: SwitchListTile(
                        title: const Text(
                          'Estado del Producto',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          _estado ? '✓ Disponible para venta' : '✗ No disponible',
                          style: TextStyle(
                            color: _estado ? Colors.green[800] : Colors.red[800],
                          ),
                        ),
                        value: _estado,
                        activeColor: Colors.green[700],
                        secondary: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _estado ? Colors.green[100] : Colors.red[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            _estado ? Icons.check_circle_rounded : Icons.cancel_rounded,
                            color: _estado ? Colors.green[700] : Colors.red[700],
                            size: 28,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _estado = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Botón Guardar
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.secondary,
                            Theme.of(context).colorScheme.secondary.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _guardarProducto,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isEditing ? Icons.save_rounded : Icons.add_circle_rounded,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isEditing ? 'Actualizar Producto' : 'Guardar Producto',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Botón Cancelar
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: Colors.grey[400]!,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.close_rounded,
                            color: Colors.grey[700],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Cancelar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
