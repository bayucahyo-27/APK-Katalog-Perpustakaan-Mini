import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: CatalogPage()),
  );
}

// 1. FUNGSI LOGIKA RATING
String kategoriRating(double rating) {
  if (rating >= 4.5) {
    return 'Sangat Baik';
  } else if (rating >= 3.5) {
    return 'Baik';
  } else {
    return 'Cukup';
  }
}

// 2. HALAMAN UTAMA (KATALOG)
class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  // Data 6 Buku (Minimal 6 sesuai Spesifikasi)
  final List<Map<String, dynamic>> books = [
    {
      'judul': 'Laskar Pelangi',
      'pengarang': 'Andrea Hirata',
      'tahunTerbit': 2005,
      'rating': 4.8,
      'tersedia': true,
      'genre': 'Drama',
      'catatanPeminjam': null,
    },
    {
      'judul': 'Bumi',
      'pengarang': 'Tere Liye',
      'tahunTerbit': 2014,
      'rating': 4.6,
      'tersedia': false,
      'genre': 'Petualangan',
      'catatanPeminjam': 'Dipinjam oleh Budi',
    },
    {
      'judul': 'Filosofi Teras',
      'pengarang': 'Henry Manampiring',
      'tahunTerbit': 2018,
      'rating': 4.7,
      'tersedia': true,
      'genre': 'Pengembangan Diri',
      'catatanPeminjam': null,
    },
    {
      'judul': 'Atomic Habits',
      'pengarang': 'James Clear',
      'tahunTerbit': 2018,
      'rating': 4.4,
      'tersedia': false,
      'genre': 'Pengembangan Diri',
      'catatanPeminjam': 'Dipinjam oleh Siti',
    },
    {
      'judul': 'Sebuah Seni untuk Bersikap Bodo Amat',
      'pengarang': 'Mark Manson',
      'tahunTerbit': 2016,
      'rating': 3.4,
      'tersedia': true,
      'genre': 'Pengembangan Diri',
      'catatanPeminjam': null,
    },
    {
      'judul': 'Hujan',
      'pengarang': 'Tere Liye',
      'tahunTerbit': 2016,
      'rating': 4.5,
      'tersedia': true,
      'genre': 'Fiksi',
      'catatanPeminjam': null,
    },
  ];

  String searchQuery = '';
  String selectedGenre = 'Semua';

  @override
  Widget build(BuildContext context) {
    // Penggunaan Set<String> untuk genre unik
    Set<String> uniqueGenres = books.map((b) => b['genre'] as String).toSet();

    // Memfilter buku berdasarkan Judul (.where) dan Genre
    List<Map<String, dynamic>> filteredBooks = books.where((b) {
      bool matchJudul = (b['judul'] as String).toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      bool matchGenre = selectedGenre == 'Semua' || b['genre'] == selectedGenre;
      return matchJudul && matchGenre;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Katalog Perpustakaan Mini')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TextField Pencarian (.where)
            TextField(
              decoration: const InputDecoration(
                labelText: 'Cari Judul Buku',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {
                setState(() {
                  searchQuery = val;
                });
              },
            ),
            const SizedBox(height: 12),

            // TAMPILAN WRAP OF CHIP UNTUK GENRE (Sesuai Soal)
            const Text(
              'Filter Genre:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8.0,
              children: ['Semua', ...uniqueGenres].map((genre) {
                final isSelected = selectedGenre == genre;
                return ChoiceChip(
                  label: Text(genre),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      selectedGenre = genre;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 12),

            // Daftar Buku (ListView.builder & Card)
            Expanded(
              child: ListView.builder(
                itemCount: filteredBooks.length,
                itemBuilder: (context, index) {
                  final book = filteredBooks[index];
                  final bool tersedia = book['tersedia'];

                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.book),
                      title: Text(book['judul']),
                      subtitle: Text(
                        '${book['pengarang']} (${book['tahunTerbit']})\nRating: ${book['rating']} - ${kategoriRating(book['rating'])}',
                      ),
                      // Badge Hijau / Merah menggunakan Ternary
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: tersedia ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          tersedia ? 'Tersedia' : 'Dipinjam',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPage(book: book),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 3. HALAMAN DETAIL BUKU (StatefulWidget sesuai spesifikasi)
class DetailPage extends StatefulWidget {
  final Map<String, dynamic> book;

  const DetailPage({super.key, required this.book});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    // Parameter Nullable String? catatanPeminjam
    String? catatanPeminjam = widget.book['catatanPeminjam'];

    return Scaffold(
      appBar: AppBar(title: Text(widget.book['judul'])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Judul: ${widget.book['judul']}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Pengarang: ${widget.book['pengarang']}'),
            Text('Tahun Terbit: ${widget.book['tahunTerbit']}'),
            Text('Genre: ${widget.book['genre']}'),
            Text(
              'Rating: ${widget.book['rating']} (${kategoriRating(widget.book['rating'])})',
            ),
            Text(
              'Status: ${widget.book['tersedia'] ? "Tersedia" : "Dipinjam"}',
            ),
            const Divider(height: 30),

            const Text(
              'Catatan Peminjam:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),

            // Menggunakan Operator ?? untuk Null Safety
            Text(catatanPeminjam ?? '(Tidak ada catatan)'),
          ],
        ),
      ),
    );
  }
}
