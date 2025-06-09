import 'package:flutter/material.dart';
import 'package:myapp/services/firebase_services.dart';

class AddClientePage extends StatefulWidget {
  final String? id;
  final String? nombre;
  final String? apellido;
  final String? email;
  final String? telefono;
  final String? direccion;
  final String? fechaRegistro;

  const AddClientePage({
    super.key,
    this.id,
    this.nombre,
    this.apellido,
    this.email,
    this.telefono,
    this.direccion,
    this.fechaRegistro,
  });

  @override
  State<AddClientePage> createState() => _AddClientePageState();
}

class _AddClientePageState extends State<AddClientePage> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  late TextEditingController nombreController;
  late TextEditingController apellidoController;
  late TextEditingController emailController;
  late TextEditingController telefonoController;
  late TextEditingController direccionController;
  late TextEditingController fechaRegistroController;

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController(text: widget.nombre ?? '');
    apellidoController = TextEditingController(text: widget.apellido ?? '');
    emailController = TextEditingController(text: widget.email ?? '');
    telefonoController = TextEditingController(text: widget.telefono ?? '');
    direccionController = TextEditingController(text: widget.direccion ?? '');
    fechaRegistroController = TextEditingController(text: widget.fechaRegistro ?? '');
  }

  @override
  void dispose() {
    nombreController.dispose();
    apellidoController.dispose();
    emailController.dispose();
    telefonoController.dispose();
    direccionController.dispose();
    fechaRegistroController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final clienteData = {
      "nombre": nombreController.text.trim(),
      "apellido": apellidoController.text.trim(),
      "email": emailController.text.trim(),
      "telefono": telefonoController.text.trim(),
      "direccion": direccionController.text.trim(),
      "fecha_registro": fechaRegistroController.text.trim(),
    };

    if (widget.id != null && widget.id!.isNotEmpty) {
      await updateCliente(widget.id!, clienteData);
    } else {
      await addCliente(clienteData);
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.id != null && widget.id!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Editar Cliente" : "Agregar Cliente"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 177, 149, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Ingrese un nombre' : null,
              ),
              TextFormField(
                controller: apellidoController,
                decoration: const InputDecoration(labelText: 'Apellido'),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Ingrese un apellido' : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Ingrese un email';
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(value.trim())) return 'Ingrese un email válido';
                  return null;
                },
              ),
              TextFormField(
                controller: telefonoController,
                decoration: const InputDecoration(labelText: 'Teléfono'),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Ingrese un teléfono' : null,
              ),
              TextFormField(
                controller: direccionController,
                decoration: const InputDecoration(labelText: 'Dirección'),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Ingrese una dirección' : null,
              ),
              TextFormField(
                controller: fechaRegistroController,
                decoration: const InputDecoration(labelText: 'Fecha de Registro'),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Ingrese una fecha' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(isEditing ? "Actualizar" : "Guardar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
