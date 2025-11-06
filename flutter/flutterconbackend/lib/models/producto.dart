class Producto {
  int? id;
  String codigo;
  String nombre;
  String descripcion;
  double precio;
  bool estado;

  Producto({
    this.id,
    required this.codigo,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.estado,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      codigo: json['codigo'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      precio: (json['precio'] as num).toDouble(),
      estado: json['estado'],
    );
  }

  // Método para convertir de Producto a JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'codigo': codigo,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'estado': estado,
    };
    
    if (id != null) {
      data['id'] = id;
    }
    
    return data;
  }
}
