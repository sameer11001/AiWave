// ignore_for_file: constant_identifier_names

/// Enum representing different language options.
enum Language {
  auto('auto'),
  arabic('ar'),
  spanish('es'),
  bulgarian('bg'),
  chinese('zh'),
  hongkong('zh_hant'),
  croatian('hr'),
  czech('cs'),
  english('en'),
  dutch('nl'),
  french('fr'),
  finnish('fi'),
  german('de'),
  greek('el'),
  hindi('hi'),
  hungarian('hu'),
  indonesian('id'),
  italian('it'),
  japanese('ja'),
  korean('ko'),
  malaysian('ms'),
  norwegian('no'),
  polish('pl'),
  portuguese('pt'),
  russian('ru'),
  swedish('sv'),
  thailand('th'),
  turkish('tr'),
  ukrainian('uk'),
  vietnamese('vi'),
  danish('da');

  const Language(this.code);
  final String code;

  String toKey() => name.toString();

  static Language fromKey(String key) {
    return Language.values.firstWhere(
      (element) => element.toKey() == key,
      orElse: () => Language.auto,
    );
  }

}
