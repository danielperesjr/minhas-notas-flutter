import 'package:flutter/material.dart';
import 'package:minhas_notas/helper/AnotacaoHelper.dart';
import 'package:minhas_notas/model/Anotacao.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  var _db = AnotacaoHelper();

  void _showAddScreen(){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Adicionar anotação"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Título",
                    hintText: "Digite o título"
                  ),
                ),
                TextField(
                  controller: _descriptionController,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: "Descrição",
                      hintText: "Digite a descrição"
                  ),
                )
              ],
            ),
            actions: [
              MaterialButton(
                  onPressed: () => Navigator.pop(context),
                child: Text("Cancelar"),
              ),
              MaterialButton(
                onPressed: (){
                  _saveNote();
                  Navigator.pop(context);
                },
                child: Text("Salvar"),
              )
            ],
          );
        }
    );
  }

  void _recoverNote() async{
    List recoveredNotes = await _db.recoverNote();
  }

  void _saveNote() async {
    String _title = _titleController.text;
    String _description = _descriptionController.text;
    Anotacao anotacao = Anotacao(_title, _description, DateTime.now().toString());
    int result = await _db.saveNote(anotacao);
    _titleController.clear();
    _descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas Notas"),
        backgroundColor: Colors.green,
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: (){
          _showAddScreen();
        },
      ),
    );
  }
}
