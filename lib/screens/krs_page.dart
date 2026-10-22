import 'package:flutter/material.dart';
import '../models/course.dart';
import '../widgets/course_card.dart';

class KrsPage extends StatefulWidget {
  const KrsPage({super.key});

  @override
  State<KrsPage> createState() => _KrsPageState();
}

class _KrsPageState extends State<KrsPage> {
  // Variabel state lokal halaman KRS
  final Set<String> selectedCourseCodes = <String>{};
  String searchQuery = '';
  bool isSubmitted = false;

  void _toggleCourse(String code) {
    if (isSubmitted) return;
    setState(() {
      if (selectedCourseCodes.contains(code)) {
        selectedCourseCodes.remove(code);
      } else {
        selectedCourseCodes.add(code);
      }
    });
  }

  void _showSubmitConfirmationDialog(int totalSks) {
    final selectedCourses = dummyCourses
        .where((course) => selectedCourseCodes.contains(course.code))
        .toList();

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.assignment_turned_in_rounded,
                color: Color(0xFF1565C0),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Konfirmasi Kirim KRS',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Apakah Anda yakin ingin mengirim dan mengunci Kartu Rencana Studi (KRS) ini?',
                style: TextStyle(fontSize: 14, color: Color(0xFF334155)),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ringkasan Pilihan:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.blueGrey.shade800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '• Jumlah Mata Kuliah: ${selectedCourses.length} MK',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '• Total Beban Studi: $totalSks / 24 SKS',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1565C0),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Setelah dikirim, pilihan mata kuliah akan dikunci dan tidak dapat diubah kembali.',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                setState(() {
                  isSubmitted = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Ya, Kirim'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter daftar mata kuliah berdasarkan kata kunci pencarian
    final List<Course> filteredCourses = dummyCourses.where((course) {
      final query = searchQuery.trim().toLowerCase();
      if (query.isEmpty) return true;
      return course.code.toLowerCase().contains(query) ||
          course.name.toLowerCase().contains(query);
    }).toList();

    // Hitung total SKS dari mata kuliah yang dipilih
    final int totalSks = dummyCourses
        .where((course) => selectedCourseCodes.contains(course.code))
        .fold(0, (sum, course) => sum + course.sks);

    // Cek apakah melebihi batas maksimal 24 SKS
    final bool isOverLimit = totalSks > 24;

    final bool canSubmit = !isSubmitted && totalSks >= 1 && !isOverLimit;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sistem KRS Online Sederhana',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Semester Ganjil • Prodi Informatika (Maks. 24 SKS)',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFFBBDEFB),
              ),
            ),
          ],
        ),
        actions: [
          if (isSubmitted)
            Container(
              margin: const EdgeInsets.only(right: 16, top: 10, bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_rounded, size: 14, color: Colors.white),
                  SizedBox(width: 4),
                  Text(
                    'Terkunci',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Kolom Pencarian Instan (Live Search)
          Container(
            color: const Color(0xFF0D47A1),
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Cari kode atau nama mata kuliah (misal: IF501, Citra)...',
                hintStyle: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF94A3B8),
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Color(0xFF1565C0),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Spanduk Status KRS Terkirim & Terkunci
          if (isSubmitted)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF4CAF50)),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.verified_rounded,
                    color: Color(0xFF2E7D32),
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'KRS Terkirim & Terkunci — Pilihan mata kuliah telah difinalisasi dan tidak dapat diubah lagi.',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1B5E20),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Spanduk Peringatan Melebihi Batas 24 SKS
          if (isOverLimit)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFEF5350), width: 1.5),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Color(0xFFC62828),
                    size: 22,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Peringatan: Total SKS melebihi batas maksimal 24 SKS!',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFB71C1C),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Subheader Informasi Daftar Mata Kuliah
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Daftar Mata Kuliah Tersedia (${filteredCourses.length})',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF475569),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Terpilih: ${selectedCourseCodes.length} MK',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1565C0),
                  ),
                ),
              ],
            ),
          ),

          // Daftar Mata Kuliah menggunakan ListView.builder
          Expanded(
            child: filteredCourses.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 48,
                          color: Colors.blueGrey.shade300,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Mata kuliah dengan kata kunci "$searchQuery" tidak ditemukan.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 4, bottom: 12),
                    itemCount: filteredCourses.length,
                    itemBuilder: (context, index) {
                      final course = filteredCourses[index];
                      final isSelected =
                          selectedCourseCodes.contains(course.code);
                      return CourseCard(
                        course: course,
                        isSelected: isSelected,
                        isLocked: isSubmitted,
                        onTap: () => _toggleCourse(course.code),
                      );
                    },
                  ),
          ),

          // Panel Ringkasan SKS & Tombol Kirim KRS di Bagian Bawah
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Total Beban Studi Terpilih',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                '$totalSks/24 SKS',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: isOverLimit
                                      ? const Color(0xFFC62828)
                                      : const Color(0xFF0F172A),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: isOverLimit
                                      ? const Color(0xFFFFEBEE)
                                      : (isSubmitted
                                          ? const Color(0xFFE8F5E9)
                                          : const Color(0xFFE3F2FD)),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  isOverLimit
                                      ? 'Melebihi Batas'
                                      : (isSubmitted
                                          ? 'Terkirim'
                                          : '${selectedCourseCodes.length} MK'),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: isOverLimit
                                        ? const Color(0xFFC62828)
                                        : (isSubmitted
                                            ? const Color(0xFF2E7D32)
                                            : const Color(0xFF1565C0)),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: canSubmit
                        ? () => _showSubmitConfirmationDialog(totalSks)
                        : null,
                    icon: Icon(
                      isSubmitted
                          ? Icons.lock_rounded
                          : Icons.send_rounded,
                      size: 18,
                    ),
                    label: Text(
                      isSubmitted ? 'KRS Terkunci' : 'Kirim KRS',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1565C0),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFFE2E8F0),
                      disabledForegroundColor: const Color(0xFF94A3B8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
