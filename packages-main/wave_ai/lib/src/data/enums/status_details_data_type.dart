
enum StatusDetailsDataType{
  json,
  srt,
  tsv,
  txt, 
  vtt;

  String toKey() => name.toLowerCase();

  static StatusDetailsDataType fromKey(String key){
    return StatusDetailsDataType.values.firstWhere((element) => element.toKey() == key.toLowerCase());
  }

}