import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Perpustakaan',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BukuListScreen(),
    );
  }
}

// Model Buku
class Buku {
  int id;
  String judul;
  String deskripsi;
  int stok;
  String fotoBuku;
  String penerbit;
  String pengarang;

  Buku({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.stok,
    required this.fotoBuku,
    required this.penerbit,
    required this.pengarang,
  });
}

class BukuListScreen extends StatefulWidget {
  @override
  _BukuListScreenState createState() => _BukuListScreenState();
}

class _BukuListScreenState extends State<BukuListScreen> {
  // Data Buku yang disimpan dalam array (List)
  List<Buku> bukuList = [
    Buku(
      id: 1,
      judul: "Flutter for Beginners",
      deskripsi: "Buku tentang belajar Flutter.",
      stok: 10,
      fotoBuku: "https://via.placeholder.com/150",
      penerbit: "Gramedia",
      pengarang: "John Doe",
    ),
    Buku(
      id: 2,
      judul: "Dart Essentials",
      deskripsi: "Buku pengenalan bahasa Dart.",
      stok: 5,
      fotoBuku: "https://via.placeholder.com/150",
      penerbit: "Erlangga",
      pengarang: "Jane Doe",
    ),
  ];

  // Fungsi untuk menambah buku
  void _addBuku(Buku buku) {
    setState(() {
      bukuList.add(buku);
    });
  }

  // Fungsi untuk mengedit buku
  void _editBuku(Buku updatedBuku) {
    setState(() {
      int index = bukuList.indexWhere((buku) => buku.id == updatedBuku.id);
      if (index != -1) {
        bukuList[index] = updatedBuku;
      }
    });
  }

  // Fungsi untuk menghapus buku
  void _deleteBuku(int id) {
    setState(() {
      bukuList.removeWhere((buku) => buku.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRUD Perpustakaan'),
      ),
      body: ListView.builder(
        itemCount: bukuList.length,
        itemBuilder: (context, index) {
          final buku = bukuList[index];
          return ListTile(
            leading: Image.network(buku.fotoBuku, width: 50, height: 50),
            title: Text(buku.judul),
            subtitle: Text("Stok: ${buku.stok}, Pengarang: ${buku.pengarang}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Edit buku
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditBukuScreen(
                          buku: buku,
                          onSave: (updatedBuku) {
                            _editBuku(updatedBuku);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteBuku(buku.id);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddBukuScreen(
                onSave: (buku) {
                  _addBuku(buku);
                  Navigator.pop(context);
                },
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddBukuScreen extends StatefulWidget {
  final Function(Buku) onSave;

  AddBukuScreen({required this.onSave});

  @override
  _AddBukuScreenState createState() => _AddBukuScreenState();
}

class _AddBukuScreenState extends State<AddBukuScreen> {
  final _judulController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _stokController = TextEditingController();
  final _fotoBukuController = TextEditingController();
  final _penerbitController = TextEditingController();
  final _pengarangController = TextEditingController();

  // Fungsi untuk menyimpan buku
  void _saveBuku() {
    final newBuku = Buku(
      id: DateTime.now().millisecondsSinceEpoch,
      judul: _judulController.text,
      deskripsi: _deskripsiController.text,
      stok: int.tryParse(_stokController.text) ?? 0,
      fotoBuku: _fotoBukuController.text,
      penerbit: _penerbitController.text,
      pengarang: _pengarangController.text,
    );
    widget.onSave(newBuku);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Buku')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _judulController, decoration: InputDecoration(labelText: 'Judul Buku')),
            TextField(controller: _deskripsiController, decoration: InputDecoration(labelText: 'Deskripsi Buku')),
            TextField(controller: _stokController, decoration: InputDecoration(labelText: 'Stok Buku'), keyboardType: TextInputType.number),
            TextField(controller: _fotoBukuController, decoration: InputDecoration(labelText: 'URL Foto Buku')),
            TextField(controller: _penerbitController, decoration: InputDecoration(labelText: 'Penerbit')),
            TextField(controller: _pengarangController, decoration: InputDecoration(labelText: 'Pengarang')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveBuku,
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditBukuScreen extends StatefulWidget {
  final Buku buku;
  final Function(Buku) onSave;

  EditBukuScreen({required this.buku, required this.onSave});

  @override
  _EditBukuScreenState createState() => _EditBukuScreenState();
}

class _EditBukuScreenState extends State<EditBukuScreen> {
  late TextEditingController _judulController;
  late TextEditingController _deskripsiController;
  late TextEditingController _stokController;
  late TextEditingController _fotoBukuController;
  late TextEditingController _penerbitController;
  late TextEditingController _pengarangController;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.buku.judul);
    _deskripsiController = TextEditingController(text: widget.buku.deskripsi);
    _stokController = TextEditingController(text: widget.buku.stok.toString());
    _fotoBukuController = TextEditingController(text: widget.buku.fotoBuku);
    _penerbitController = TextEditingController(text: widget.buku.penerbit);
    _pengarangController = TextEditingController(text: widget.buku.pengarang);
  }

  // Fungsi untuk menyimpan perubahan buku
  void _saveEdit() {
    final updatedBuku = Buku(
      id: widget.buku.id,
      judul: _judulController.text,
      deskripsi: _deskripsiController.text,
      stok: int.tryParse(_stokController.text) ?? 0,
      fotoBuku: _fotoBukuController.text,
      penerbit: _penerbitController.text,
      pengarang: _pengarangController.text,
    );
    widget.onSave(updatedBuku);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Buku')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _judulController, decoration: InputDecoration(labelText: 'Judul Buku')),
            TextField(controller: _deskripsiController, decoration: InputDecoration(labelText: 'Deskripsi Buku')),
            TextField(controller: _stokController, decoration: InputDecoration(labelText: 'Stok Buku'), keyboardType: TextInputType.number),
            TextField(controller: _fotoBukuController, decoration: InputDecoration(labelText: 'URL Foto Buku')),
            TextField(controller: _penerbitController, decoration: InputDecoration(labelText: 'Penerbit')),
            TextField(controller: _pengarangController, decoration: InputDecoration(labelText: 'Pengarang')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveEdit,
              child: Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}




