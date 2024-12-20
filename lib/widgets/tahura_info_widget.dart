import 'package:flutter/material.dart';

class TahuraInfoWidget extends StatelessWidget {
  const TahuraInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width * 0.9, // Lebar 90% layar
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start, // Rata kiri
          children: const [
            SizedBox(height: 16.0),
            Text(
              'Taman Hutan Raya Ir H Djuanda',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.0), // Jarak antar teks
            Text(
              'Buka Setiap Hari 08.00-16.00 WIB\nKomplek Taman Hutan Raya Ir. H. Djuanda No.99 Dago Pakar, Bandung 40198',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
