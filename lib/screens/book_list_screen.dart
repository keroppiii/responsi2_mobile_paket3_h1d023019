import 'package:flutter/material.dart';
import 'package:responsi_2_mobile_paket_3_h1d023019/models/book_model.dart';
import 'package:responsi_2_mobile_paket_3_h1d023019/services/api_service.dart';
import 'package:responsi_2_mobile_paket_3_h1d023019/utils/shared_prefs.dart';
import 'add_book_screen.dart';
import 'edit_book_screen.dart';
import '../theme/app_theme.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  List<Book> _books = [];
  bool _isLoading = true;
  String? _errorMessage;
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadTokenAndBooks();
  }

  void _loadTokenAndBooks() async {
    final token = await SharedPrefs.getToken();
    if (token == null) {
      setState(() {
        _errorMessage = 'Token tidak ditemukan';
        _isLoading = false;
      });
      return;
    }

    _token = token;
    await _loadBooks();
  }

  Future<void> _loadBooks() async {
    if (_token == null) return;

    setState(() => _isLoading = true);

    try {
      final books = await ApiService.getBooks(_token!);
      setState(() {
        _books = books;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat data';
        _isLoading = false;
      });
    }
  }

  void _deleteBook(int id) async {
    if (_token == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah Anda yakin ingin menghapus buku ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await ApiService.deleteBook(_token!, id);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Buku berhasil dihapus')),
        );
        await _loadBooks();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghapus buku')),
        );
      }
    }
  }

  void _showBookDetails(Book book) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              book.judul,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryBrown,
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            _buildDetailRow('Penulis', book.penulis),
            _buildDetailRow('Penerbit', book.penerbit),
            _buildDetailRow('Harga', 'Rp ${book.harga.toStringAsFixed(0)}'),
            _buildDetailRow('Jumlah Stok', book.jumlah.toString()),
            _buildDetailRow('Volume', book.volume.toString()),
            _buildDetailRow('Tanggal Masuk', book.tanggalMasuk),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('TUTUP'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditBookScreen(book: book),
                        ),
                      ).then((_) => _loadBooks());
                    },
                    child: const Text('EDIT'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          const Text(': '),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Inventaris Buku fatiMart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _books.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.menu_book,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Belum ada buku',
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          const Text('Tekan + untuk menambahkan buku'),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadBooks,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: _books.length,
                        itemBuilder: (context, index) {
                          final book = _books[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: ListTile(
                              leading: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryBrown.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.book,
                                  color: AppTheme.primaryBrown,
                                ),
                              ),
                              title: Text(
                                book.judul,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Penulis: ${book.penulis}'),
                                  Text(
                                    'Rp ${book.harga.toStringAsFixed(0)} • Stok: ${book.jumlah}',
                                  ),
                                ],
                              ),
                              trailing: PopupMenuButton(
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'detail',
                                    child: Row(
                                      children: [
                                        Icon(Icons.info, size: 20),
                                        SizedBox(width: 8),
                                        Text('Detail'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit, size: 20),
                                        SizedBox(width: 8),
                                        Text('Edit'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete, size: 20,
                                            color: Colors.red),
                                        SizedBox(width: 8),
                                        Text('Hapus', style: TextStyle(color: Colors.red)),
                                      ],
                                    ),
                                  ),
                                ],
                                onSelected: (value) {
                                  if (value == 'detail') {
                                    _showBookDetails(book);
                                  } else if (value == 'edit') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditBookScreen(book: book),
                                      ),
                                    ).then((_) => _loadBooks());
                                  } else if (value == 'delete') {
                                    _deleteBook(book.id!);
                                  }
                                },
                              ),
                              onTap: () => _showBookDetails(book),
                            ),
                          );
                        },
                      ),
                    ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryBrown,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddBookScreen()),
          ).then((_) => _loadBooks());
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}