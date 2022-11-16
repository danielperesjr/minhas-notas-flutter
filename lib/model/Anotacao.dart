class Anotacao {
  late int id;
  late String titulo;
  late String descricao;
  late String dtanotacao;

  Anotacao(this.titulo, this.descricao, this.dtanotacao);

  Anotacao.fromMap(Map map){
    this.id = map["id"];
    this.titulo = map["titulo"];
    this.descricao = map["descricao"];
    this.dtanotacao = map["dtanotacao"];

  }

  Map toMap(){
    Map<String, dynamic> map = {
      "titulo" : this.titulo,
      "descricao" : this.descricao,
      "dtanotacao" : this.dtanotacao
    };
    if(this.id != null){
      map["id"] = this.id;
    }
    return map;
  }

}