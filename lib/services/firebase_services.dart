import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _db = FirebaseFirestore.instance;

Future<List<Map<String, dynamic>>> getClientes() async {
  final snapshot = await _db.collection('Clientes').get();
  return snapshot.docs.map((doc) {
    final data = doc.data();
    data['ID_clientes'] = doc.id;  // asignar el id del doc para manejarlo
    return data;
  }).toList();
}

Future<void> addCliente(Map<String, dynamic> clienteData) async {
  await _db.collection('Clientes').add(clienteData);
}

Future<void> updateCliente(String id, Map<String, dynamic> clienteData) async {
  await _db.collection('Clientes').doc(id).update(clienteData);
}

Future<void> deleteCliente(String id) async {
  await _db.collection('Clientes').doc(id).delete();
}
