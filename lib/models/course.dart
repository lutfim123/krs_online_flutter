class Course {
  final String code;
  final String name;
  final int sks;
  final String lecturer;

  const Course({
    required this.code,
    required this.name,
    required this.sks,
    required this.lecturer,
  });
}

const List<Course> dummyCourses = [
  Course(
    code: 'IF501',
    name: 'Pemrograman Perangkat Bergerak',
    sks: 3,
    lecturer: 'Dr. Budi Santoso, S.Kom., M.Kom.',
  ),
  Course(
    code: 'IF502',
    name: 'Pemrograman Web Lanjut',
    sks: 3,
    lecturer: 'Siti Aminah, S.T., M.Cs.',
  ),
  Course(
    code: 'IF503',
    name: 'Pengolahan Citra Digital',
    sks: 3,
    lecturer: 'Hendra Wijaya, S.Kom., M.T.',
  ),
  Course(
    code: 'IF504',
    name: 'Penambangan Data (Data Mining)',
    sks: 3,
    lecturer: 'Dr. Rina Kartika, S.Si., M.Kom.',
  ),
  Course(
    code: 'IF505',
    name: 'Teori Graf dan Otomata',
    sks: 3,
    lecturer: 'Ahmad Fauzi, S.Kom., M.Sc.',
  ),
  Course(
    code: 'IF506',
    name: 'Rekayasa Perangkat Lunak',
    sks: 3,
    lecturer: 'Dewi Lestari, S.Kom., M.M.S.I.',
  ),
  Course(
    code: 'IF507',
    name: 'Keamanan Jaringan Komputer',
    sks: 3,
    lecturer: 'Pratama Putra, S.T., M.Kom.',
  ),
  Course(
    code: 'IF508',
    name: 'Metodologi Penelitian Informatika',
    sks: 2,
    lecturer: 'Prof. Dr. Ir. Wahyu Hidayat, M.T.',
  ),
  Course(
    code: 'IF509',
    name: 'Etika Profesi Teknologi Informasi',
    sks: 2,
    lecturer: 'Nurul Huda, S.Kom., M.Hum.',
  ),
];
