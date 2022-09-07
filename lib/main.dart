import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

   _carregarBaseDados() async {
      
    final caminho = await getDatabasesPath();
    final ficheirodb = join(caminho, 'base.db');
   
    var dbcriada = await openDatabase(
      ficheirodb,
      version: 1,
      onCreate: (db, versiondb){
        String sql = "CREATE TABLE pessoa (id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, sexo TEXT, idade INTEGER)";
        db.execute(sql);
      }
    );
    return dbcriada;
   //print("Base dados foi criada: ${dbcriada.isOpen}");

   }

   _inserirDados() async {
      Database db = await _carregarBaseDados();

      Map<String, dynamic> dados = {
        "nome": "Miguel Manuel",
        "sexo": "M",
        "idade": 60
      };

      int id = await db.insert('pessoa', dados);
      print("Id da pessoa criada: "+id.toString());

   }

   _listarDados() async {
     Database db = await _carregarBaseDados();
     
     String sql = "SELECT * FROM pessoa";
     List lista = await db.rawQuery(sql);

     for(var dadosList in lista){
        print("ID: "+dadosList['id'].toString()+
              "  NOME: "+dadosList['nome']+
              "  SEXO: "+dadosList['sexo']+
              "  IDADE: "+dadosList['idade'].toString()
              );
     }

   }

   _listarDadosId(int id) async {
      Database db = await _carregarBaseDados();

     List lista = await db.query(
       'pessoa', 
       where: 'id = ?',
       whereArgs: [id]
     );

    for(var dadosList in lista){
        print("ID: "+dadosList['id'].toString()+
              "  NOME: "+dadosList['nome']+
              "  SEXO: "+dadosList['sexo']+
              "  IDADE: "+dadosList['idade'].toString()
              );
     }
      
   }

   _atualizarDados(int id) async {
    Database db = await _carregarBaseDados();

    Map<String, dynamic> lista ={
      'nome': 'Dádiva Manuel',
      'sexo': 'F',
      'idade': 6,
      
    };

    db.update(
      'pessoa', 
      lista,
      where: 'id = ?',
      whereArgs: [id]
      );
     

   }

   _deleteDados(int id) async {
     Database db = await _carregarBaseDados();
      
    int count = await db.delete(
       'pessoa',
       where: 'id = ?',
       whereArgs: [id]
       );

       print("A pessoa com id ${count.toString()} foi eliminado com sucesso!!");
   }

  @override
  Widget build(BuildContext context) {
    //_carregarBaseDados();
    //_inserirDados();
    //_listarDados();
    //_listarDadosId(7);
    //_atualizarDados(7);
    //_listarDadosId(7);
    _deleteDados(4);
    _listarDados();
    return Container();
  }
}

