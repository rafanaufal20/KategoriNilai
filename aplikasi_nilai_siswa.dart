import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false; 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Kategori Nilai',
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: HomeScreen(
        onThemeChanged: (isDark) {
          setState(() {
            _isDarkMode = isDark; 
          });
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final Function(bool) onThemeChanged; 

  HomeScreen({required this.onThemeChanged});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<TextEditingController> _controllers = [];
  double _nilaiRataRata = 0;
  String _kategoriNilai = '';
  String _errorMessage = '';

  void _addNewField() {
    setState(() {
      _controllers.add(TextEditingController());
    });
  }

  void _calculateAverage() {
    setState(() {
      double total = 0;
      int count = 0;
      bool validInput = true;

      for (var controller in _controllers) {
        double? nilai = double.tryParse(controller.text);
        if (nilai != null && nilai >= 0 && nilai <= 100) {
          total += nilai;
          count++;
        } else {
          validInput = false;
          break;
        }
      }

      if (validInput && count > 0) {
        _nilaiRataRata = total / count;
        _kategoriNilai = _getKategoriNilai(_nilaiRataRata);
        _errorMessage = '';
      } else {
        _errorMessage = 'Masukkan nilai yang valid (0-100)';
        _kategoriNilai = '';
      }
    });
  }

  String _getKategoriNilai(double nilai) {
    if (nilai >= 85) return 'A';
    if (nilai >= 70) return 'B';
    if (nilai >= 55) return 'C';
    return 'D';
  }

  void _removeField(int index) {
    setState(() {
      _controllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aplikasi Kategori Nilai'),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () {
              widget.onThemeChanged(Theme.of(context).brightness == Brightness.dark);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _controllers.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controllers[index],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Nilai Siswa ${index + 1}',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () => _removeField(index),
                      ),
                    ],
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _addNewField,
              child: Text('Tambah Nilai'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _calculateAverage,
              child: Text('Hitung Rata-Rata'),
            ),
            SizedBox(height: 16),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            if (_kategoriNilai.isNotEmpty)
              Text(
                'Kategori Nilai: $_kategoriNilai',
                style: TextStyle(fontSize: 20),
              ),
            Text(
              'Nilai Rata-Rata: ${_nilaiRataRata.toStringAsFixed(2)}',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white 
                    : Colors.black, 
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
