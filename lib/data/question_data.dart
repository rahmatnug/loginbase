import '/models/question.dart';

final List<Question> sampleQuestions = [
  Question(
    questionText: 'Apa singkatan dari SQL?',
    options: [
      'Structured Query Language',
      'Simple Query Logic',
      'System Quality Level',
      'Sequential Query List',
    ],
    correctIndex: 0,
  ),
  Question(
    questionText: 'Flutter menggunakan bahasa pemrograman?',
    options: ['Java', 'Kotlin', 'Dart', 'Swift'],
    correctIndex: 2,
  ),
  Question(
    questionText: 'Apa fungsi dari ERD dalam database?',
    options: [
      'Mengatur tampilan UI',
      'Mendesain relasi antar entitas',
      'Menjalankan query SQL',
      'Menyimpan data pengguna',
    ],
    correctIndex: 1,
  ),
  Question(
    questionText: 'Manakah yang termasuk tipe data SQL?',
    options: ['VARCHAR', 'BOOLEAN', 'INTEGER', 'Semua benar'],
    correctIndex: 3,
  ),
  Question(
    questionText: 'Apa itu OOP dalam pemrograman?',
    options: [
      'Object Oriented Programming',
      'Object Oriented Process',
      'Object Oriented Protocol',
      'Object Oriented Package'
    ],
    correctIndex: 0,
  ),
  Question(
    questionText: 'Komponen utama dalam Flutter adalah?',
    options: [
      'Activities',
      'Fragments',
      'Widgets',
      'Views'
    ],
    correctIndex: 2,
  ),
];