class Anotacao {
  late int id;
  late String titulo;
  late String descricao;
  late String dtanotacao;

  Anotacao(this.titulo, this.descricao, this.dtanotacao);

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