import 'package:flutter/material.dart';
import 'package:sistema_coleta_arqueologica/core/theme/app_colors.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Controladores de tela
  int _indiceAtual = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: theme.primaryColor),
      ),
      body: Center(child: Text('Conteúdo da aba $_indiceAtual')),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        onTap: (index) {
          setState(() {
            _indiceAtual = index;
          });
        },

        selectedItemColor: AppColors.primaryLight, 
  
        unselectedItemColor: Colors.grey, 
        
        selectedLabelStyle: const TextStyle(
          fontSize: 12, 
          fontWeight: FontWeight.bold,
        ),
        
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
        ),
        
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Coletas'),
          BottomNavigationBarItem(icon: Icon(Icons.sync), label: 'Sincronizar'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),    
    );
  }
}