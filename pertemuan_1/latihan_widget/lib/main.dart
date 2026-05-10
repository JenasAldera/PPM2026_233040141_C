// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Hello Flutter!',
//               style: TextStyle(
//                   fontSize: 50,
//                   fontWeight: FontWeight.w900,
//                   color: Colors.green
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'Ini teks biasa dengan ukuran mini',
//               style: TextStyle(fontSize: 14, color: Colors.deepPurple),
//             ),
//           ],
//         ),
//       ),
//     ),
//   ));
// }

// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: Scaffold(
//       body: Center(
//         child: Container(
//           width: 300,
//           height: 100,
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: Colors.blue,
//             borderRadius: BorderRadius.circular(100),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.blue.withValues(alpha: 0.3),
//                 blurRadius: 50,
//                 offset: const Offset(0, 10),
//               ),
//             ],
//               border: Border.all(color: Colors.black, width: 4)
//           ),
//           child: const Center(
//             child: Text(
//               'Box',
//               style: TextStyle(color: Colors.white, fontSize: 24),
//             ),
//           ),
//         ),
//       ),
//     ),
//   ));
// }

// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: Latihan3(),
//   ));
// }
//
// class Latihan3 extends StatelessWidget {
//   const Latihan3({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Latihan Row & Column'),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Container(width: 60, height: 60, color: Colors.red),
//             Container(width: 60, height: 60, color: Colors.green),
//             Container(width: 60, height: 60, color: Colors.blue),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Latihan4(),
  ));
}

class Latihan4 extends StatelessWidget {
  const Latihan4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan Icon & Row'),
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.yellow,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.home, size: 50, color: Colors.blue),
              SizedBox(width: 24),
              Icon(Icons.search, size: 32, color: Colors.green),
              SizedBox(width: 24),
              Icon(Icons.settings, size: 32, color: Colors.pink),
              SizedBox(width: 24),
              Icon(Icons.shopping_cart, size: 32, color: Colors.orange),
            ],
          ),
        ),
      ),
    );
  }
}