import '../models/question.dart';

final List<Question> deathQuestions = [
  Question(
    questionText: 'Apa yang dimaksud dengan OOP?',
    options: [
      'Object Oriented Programming',
      'Object Oriented Protocol',
      'Object Oriented Process',
      'Object Oriented Package'
    ],
    correctIndex: 0,
  ),
  Question(
    questionText: 'Manakah yang bukan prinsip OOP?',
    options: [
      'Inheritance',
      'Encapsulation',
      'Serialization',
      'Polymorphism'
    ],
    correctIndex: 2,
  ),
  Question(
    questionText: 'Apa fungsi constructor dalam class?',
    options: [
      'Menghapus objek',
      'Membuat objek baru',
      'Mengubah objek',
      'Menyalin objek'
    ],
    correctIndex: 1,
  ),
  Question(
    questionText: 'Apa itu private variable dalam OOP?',
    options: [
      'Variable yang bisa diakses dari mana saja',
      'Variable yang hanya bisa diakses dalam class',
      'Variable yang tidak bisa diubah',
      'Variable yang tidak memiliki nilai'
    ],
    correctIndex: 1,
  ),
  Question(
    questionText: 'Apa kegunaan getter dalam OOP?',
    options: [
      'Mengubah nilai variable',
      'Membuat variable baru',
      'Mengambil nilai variable',
      'Menghapus variable'
    ],
    correctIndex: 2,
  ),
  Question(
    questionText: 'Manakah yang merupakan contoh polymorphism?',
    options: [
      'Class yang memiliki banyak method',
      'Method dengan nama sama tapi beda parameter',
      'Variable yang bisa menyimpan banyak nilai',
      'Class yang memiliki banyak variable'
    ],
    correctIndex: 1,
  ),
  Question(
    questionText: 'Apa fungsi extends dalam OOP?',
    options: [
      'Membuat class baru',
      'Menghubungkan dua class',
      'Menurunkan sifat class induk ke class anak',
      'Mengcopy class yang sudah ada'
    ],
    correctIndex: 2,
  ),
  Question(
    questionText: 'Apa itu abstract class?',
    options: [
      'Class yang tidak bisa dibuat objectnya',
      'Class yang tidak memiliki method',
      'Class yang tidak memiliki variable',
      'Class yang tidak memiliki constructor'
    ],
    correctIndex: 0,
  ),
  Question(
    questionText: 'Bagaimana cara mengakses variable private?',
    options: [
      'Langsung memanggil variablenya',
      'Menggunakan getter/setter',
      'Tidak bisa diakses',
      'Mengubah menjadi public'
    ],
    correctIndex: 1,
  ),
  Question(
    questionText: 'Apa itu interface dalam OOP?',
    options: [
      'Blueprint untuk class',
      'Class yang memiliki method abstract',
      'Class yang tidak bisa diwariskan',
      'Class yang tidak memiliki property'
    ],
    correctIndex: 0,
  ),
  Question(
    questionText: 'Manakah yang merupakan access modifier?',
    options: [
      'static, final, const',
      'public, private, protected',
      'int, string, bool',
      'class, interface, enum'
    ],
    correctIndex: 1,
  ),
  Question(
    questionText: 'Apa itu overriding method?',
    options: [
      'Membuat method baru',
      'Menghapus method lama',
      'Menulis ulang method dari class induk',
      'Menggabungkan dua method'
    ],
    correctIndex: 2,
  ),
  Question(
    questionText: 'Apa fungsi super dalam constructor?',
    options: [
      'Memanggil constructor class induk',
      'Membuat constructor baru',
      'Menghapus constructor lama',
      'Mengubah parameter constructor'
    ],
    correctIndex: 0,
  ),
  Question(
    questionText: 'Apa itu singleton pattern?',
    options: [
      'Class yang memiliki banyak instance',
      'Class yang tidak memiliki instance',
      'Class yang hanya memiliki satu instance',
      'Class yang bisa dibuat instance berulang'
    ],
    correctIndex: 2,
  ),
  Question(
    questionText: 'Apa keuntungan menggunakan OOP?',
    options: [
      'Kode lebih sulit dibaca',
      'Program berjalan lebih lambat',
      'Membutuhkan memori lebih besar',
      'Kode lebih mudah dikelola dan digunakan ulang'
    ],
    correctIndex: 3,
  ),
];
