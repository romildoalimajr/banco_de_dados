import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  _recuperarBancoDados() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "banco.db");

    var bd = await openDatabase(
      localBancoDados,
      version: 1,
      onCreate: (db, novaVersaoRecente) {
        String sql =
            "CREATE TABLE usuarios (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, idade INTEGER)";
        db.execute(sql);
      },
    );

    return bd;
    //print("aberto: " + bd.isOpen.toString());
  }

  _salvar() async {
    Database bd = await _recuperarBancoDados();
    Map<String, dynamic> dadosUsuario = {"nome": "Negro Ninja", "idade": 25};
    int id = await bd.insert("usuarios", dadosUsuario);
    print("salvo: $id");
  }

  _listarUsuarios() async {
    Database bd = await _recuperarBancoDados();
    String sql = "SELECT * FROM usuarios";

    List usuarios = await bd.rawQuery(sql);

    for (var usuario in usuarios) {
      print("item id: " +
          usuario['id'].toString() +
          " nome: " +
          usuario['nome'] +
          " idade: " +
          usuario['idade'].toString());
    }

    print("usuarios: " + usuarios.toString());
  }

  _recuperarUsuario(int id) async {
    Database bd = await _recuperarBancoDados();
    List usuarios = await bd.query("usuarios",
        columns: ["id", "nome", "idade"], where: "id = ? ", whereArgs: [id]);
    for (var usuario in usuarios) {
      print("item id: " +
          usuario['id'].toString() +
          " nome: " +
          usuario['nome'] +
          " idade: " +
          usuario['idade'].toString());
    }
  }

  _excluirUsuario(int id) async {
    Database bd = await _recuperarBancoDados();

    int retorno = await bd.delete(
      "usuarios",
      /* where: "id = ?",
      whereArgs: [id]*/
      where: "idade = ?",
      whereArgs: [28],
    );
    print("item quantidade removida: $retorno");
  }

  _atualizarUsuario(int id) async {
    Database bd = await _recuperarBancoDados();
    Map<String, dynamic> dadosUsuario = {"nome": "Romildo Alves", "idade": 29};

    int retorno = await bd
        .update("usuarios", dadosUsuario, where: "id = ?", whereArgs: [id]);
    print("item quantidade atualizada: $retorno");
  }

  @override
  Widget build(BuildContext context) {
    //_salvar();
    //_listarUsuarios();
    //_recuperarUsuario(5);
    //_excluirUsuario(2);
    //_atualizarUsuario(1);
    _listarUsuarios();

    return Scaffold();
  }
}
