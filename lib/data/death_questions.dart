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
    questionText: 'Apa itu Polymorphism dalam OOP?',
    options: [
      'Penyembunyian data',
      'Pewarisan sifat',
      'Banyak bentuk',
      'Pembuatan objek'
    ],
    correctIndex: 2,
  ),
  Question(
    questionText: 'Manakah yang merupakan access modifier di Dart?',
    options: [
      'public',
      'private (_)',
      'protected',
      'internal'
    ],
    correctIndex: 1,
  ),
];
