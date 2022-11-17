import 'package:flutter/material.dart';
import 'package:minhas_notas/helper/AnotacaoHelper.dart';
import 'package:minhas_notas/model/Anotacao.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  var _db = AnotacaoHelper();
  List<Anotacao> _notes = <Anotacao>[];


  void _showAddScreen({Anotacao? note}){

    String textSaveUpdate = "";
    if(note == null){
      _titleController.clear();
      _descriptionController.clear();
      textSaveUpdate = "Salvar";
    }else {
      _titleController.text = note.titulo!;
      _descriptionController.text = note.descricao!;
      textSaveUpdate = "Atualizar";
    }

    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("$textSaveUpdate anotação"),
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
                  _saveUpdateNote(selectedNote: note);
                  Navigator.pop(context);
                },
                child: Text(textSaveUpdate),
              )
            ],
          );
        }
    );
  }

  void _recoverNote() async{
    List recoveredNotes = await _db.recoverNote();

    List<Anotacao> tempList = <Anotacao>[];
    for(var item in recoveredNotes){
      Anotacao anotacao = Anotacao.fromMap(item);
      tempList.add(anotacao);
    }

    setState(() {
      _notes = tempList;
    });

  }

  void _saveUpdateNote({Anotacao? selectedNote}) async {

    String title = _titleController.text;
    String description = _descriptionController.text;

    if(selectedNote == null){
      Anotacao note = Anotacao(title, description, DateTime.now().toString());
      int result = await _db.saveNote(note);
    }else{
      selectedNote.titulo     = title;
      selectedNote.descricao  = description;
      selectedNote.dtanotacao = DateTime.now().toString();
      int result = await _db.updateNote(selectedNote);
    }

    _titleController.clear();
    _descriptionController.clear();

    _recoverNote();
  }

  void _deleteNote(int id) async {
    await _db.deleteNote(id);
    _recoverNote();
  }

   String _dateFormat(String date){
    initializeDateFormatting("pt_BR");
    var formater = DateFormat("dd/MM/yyyy HH:mm:ss");

    DateTime convertDate = DateTime.parse(date);
    String formatDate = formater.format(convertDate);

    return formatDate;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recoverNote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas Notas"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                itemCount: _notes.length,
                  itemBuilder: (context, index){
                  final note = _notes[index];
                    return Card(
                      child: ListTile(
                        title: Text(note.titulo!),
                        subtitle: Text("${_dateFormat(note.dtanotacao!)} - ${note.descricao}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: (){
                                _showAddScreen(note: note);
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 16),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                _deleteNote(note.id!);
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 0),
                                child: Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
              )
          )
        ],
      ),
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
