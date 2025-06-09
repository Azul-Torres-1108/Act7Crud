import 'package:flutter/material.dart';
import 'package:myapp/services/firebase_services.dart';
import 'add_cliente_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<void> _deleteCliente(String id, String nombre) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Quieres eliminar a "$nombre"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await deleteCliente(id);
      setState(() {}); // refrescar lista
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CRUD Clientes"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 177, 149, 255),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getClientes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay clientes registrados"));
          }

          final clientes = snapshot.data!;

          return ListView.builder(
            itemCount: clientes.length,
            itemBuilder: (context, index) {
              final cliente = clientes[index];
              final id = cliente['ID_clientes'] ?? cliente['id'] ?? '';
              final nombreCompleto = "${cliente['nombre'] ?? ''} ${cliente['apellido'] ?? ''}";

              return Dismissible(
                key: Key(id),
                direction: DismissDirection.endToStart, // Deslizar hacia la izquierda para eliminar
                background: Container(
                  color: Colors.redAccent,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  // Preguntar antes de eliminar
                  return await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirmar eliminación'),
                      content: Text('¿Quieres eliminar a "$nombreCompleto"?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Eliminar'),
                        ),
                      ],
                    ),
                  ) ?? false;
                },
                onDismissed: (direction) async {
                  await deleteCliente(id);
                  setState(() {}); // Refrescar lista después de eliminar
                },
                child: ListTile(
                  title: Text(nombreCompleto),
                  subtitle: Text(cliente['email'] ?? ''),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddClientePage(
                          id: id,
                          nombre: cliente['nombre'] ?? '',
                          apellido: cliente['apellido'] ?? '',
                          email: cliente['email'] ?? '',
                          telefono: cliente['telefono'] ?? '',
                          direccion: cliente['direccion'] ?? '',
                          fechaRegistro: cliente['fecha_registro'] ?? '',
                        ),
                      ),
                    ).then((_) => setState(() {}));
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add').then((_) => setState(() {}));
        },
        backgroundColor: const Color.fromARGB(255, 177, 149, 255),
        child: const Icon(Icons.add),
      ),
    );
  }
}
