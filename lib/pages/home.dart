import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spanish-Flutter'),
        centerTitle: true,
        backgroundColor: Colors.brown[800],
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        color: Colors.brown[900],
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () { Navigator.pushNamed(context, '/tests', arguments: { 'option': 1 }); },
                      fillColor: Colors.brown[700],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
                            child: Row(
                              children: [
                                Expanded(child: Image.asset('assets/english.png')),
                                const Expanded(child: Icon(Icons.arrow_right, size: 72,)),
                                Expanded(child: Image.asset('assets/spanish.png'))
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('ENG', style: TextStyle(color: Colors.brown[200], fontSize: 64)),
                              Text('ESP', style: TextStyle(color: Colors.brown[200], fontSize: 64)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () { Navigator.pushNamed(context, '/tests', arguments: { 'option': 2 }); },
                      fillColor: Colors.brown[700],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
                            child: Row(
                              children: [
                                Expanded(child: Image.asset('assets/spanish.png')),
                                const Expanded(child: Icon(Icons.arrow_right, size: 72,)),
                                Expanded(child: Image.asset('assets/english.png'))
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('ESP', style: TextStyle(color: Colors.brown[200], fontSize: 64)),
                              Text('ENG', style: TextStyle(color: Colors.brown[200], fontSize: 64)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () { Navigator.pushNamed(context, '/browser'); },
                      fillColor: Colors.brown[700],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
                            child: Row(
                              children: const [
                                Expanded(child: Icon(Icons.book, size: 72,)),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Learn', style: TextStyle(color: Colors.brown[200], fontSize: 64)),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
