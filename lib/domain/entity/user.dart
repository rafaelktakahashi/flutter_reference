import 'package:flutter_reference/domain/entity/address.dart';
import 'package:flutter_reference/domain/entity/playground_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part "user.freezed.dart";

/// A user for demonstrating the login demo. Our sample application doesn't
/// actually have any registered users (all instances of this class are mocks).
@freezed
class User with _$User implements PlaygroundEntity {
  const factory User({
    required String username,
    required UserRole userRole,
    required PersonName name,
    required Address address,
  }) = _User;

  const User._();

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError("Not supported");
  }

  @override
  String toString() {
    return "$username, ${name.fullRomanizedName()} (${userRole.name})";
  }
}

enum UserRole { admin, user }

// The following code is mostly just for fun and you can ignore it.
// Remember that names are more complicated than they seem.

abstract class PersonName {
  /// Given name of a person. You should prefer using `formattedForGreeting()`
  /// for most cases.
  String givenName();

  /// Full name of a person in its original script.
  String fullName();

  /// Name of a person, guaranteed to be written in latin latters.
  String fullRomanizedName();

  /// Get the name that this person goes by (how they should be addressed)
  String formattedForGreeting();
}

/// Name of a person in the UK, US and other English-speaking countries that use
/// a first name, a middle name and a surname. People in English-speaking
/// countries typically go by a nickname that's often, but not always based on
/// their first name.
///
/// First name: Daniel
/// Middle name: Keith
/// Surname: Campbell
/// Nickname: Dan
/// Full name: Daniel "Dan" Keith Campbell
/// Person goes by the name of Dan, or Mr. Campbell.
class PersonNameEnglish implements PersonName {
  final String firstName;
  final String middleName;
  final String surname;
  final String? nickname;
  const PersonNameEnglish(
      this.firstName, this.middleName, this.surname, this.nickname);

  @override
  String formattedForGreeting() => nickname ?? firstName;

  @override
  String fullName() => nickname != null
      ? "$firstName \"$nickname\" $middleName $surname"
      : "$firstName $middleName $surname";

  @override
  String fullRomanizedName() => fullName();

  @override
  String givenName() => firstName;
}

/// People in Brazil may have any number of names, typically two to four, but
/// formally no limit exists. The only limitation is that a person's surname
/// must be inherited from that person's ancestors.
///
/// Example:
/// First name: Thiago
/// Surnames: Souza de Andrade Reis
class PersonNameBrazil implements PersonName {
  final String firstName;
  final List<String> surnames;
  const PersonNameBrazil(this.firstName, this.surnames);

  @override
  String formattedForGreeting() => firstName;

  @override
  String fullName() => "$firstName ${surnames.join(' ')}";

  @override
  String fullRomanizedName() => fullName();

  @override
  String givenName() => firstName;
}

/// A person in Japan has two names: A (苗字 myōji or 姓 sei), followed by
/// a given name (名 mei).
/// There is no predetermined relation between the spelling of a name and its
/// pronounciation: the given name 新 can be read Arata, Shin, Hajime, or
/// possibly something else, and the given name Haruto can be spelled 悠人,
/// 悠斗, 大翔 or something else. You should always ask the person with the name.
///
/// The pronunciation (=reading) of a name is given in kana (the syllabary) and
/// Japanese software typically has separate input fields for the reading of a
/// name.
///
/// The full name of a person is written with the myouji (family name) first,
/// separated by a space. However, when writing it in latin letters, the mei
/// (given name) must come first.
///
/// Example:
/// Myouji (family name): 橋本 //=> reading: はしもと //=> romanized: Hashimoto
/// Mei (given name): 彩葉 //=> reading: あやは //=> romanized: Ayaha
/// Full name: 橋本 彩葉
/// Full name, romanized: Ayaha Hashimoto
class PersonNameJapan implements PersonName {
  final String myouji;
  final String mei;
  final String myoujiYomi;
  final String meiYomi;
  final String myoujiRomaji;
  final String meiRomaji;

  const PersonNameJapan(
    this.myouji,
    this.mei,
    this.myoujiYomi,
    this.meiYomi,
    this.myoujiRomaji,
    this.meiRomaji,
  );

  @override
  String formattedForGreeting() => "$myoujiさん";

  @override
  String fullName() => "$myouji $mei";

  @override
  String fullRomanizedName() => "$meiRomaji $myoujiRomaji";

  @override
  String givenName() => mei;
}

/// A person in China has a family name (姓氏 xìngshì) and a given name (名 míng).
/// Unlike in Japanese, Chinese people can easily read a Chinese person's name
/// without needing to ask for the pronunciation. The romanized pinyin is still
/// given separately, typically, because automatic transcription may get it
/// wrong due to names sometimes being read differently from the way the letters
/// are typically read in regular text.
///
/// The full name is the xingshi followed by the ming, without spaces. When
/// giving the name in latin script, the same order is followed, and a space
/// is added between the names.
///
/// Example:
/// Xingshi (family name): 张 //=> Romanized: Zhāng
/// Ming (given name): 秀英 //=> Romanized: Xiùyīng
/// Full name: 张秀英
/// Full name, romanized: Zhāng Xiùyīng
class PersonNameChina implements PersonName {
  final String xingshi;
  final String ming;
  final String xingshiPinyin;
  final String mingPinyin;

  const PersonNameChina(
      this.xingshi, this.ming, this.xingshiPinyin, this.mingPinyin);

  @override
  String formattedForGreeting() => xingshi;

  @override
  String fullName() => "$xingshi$ming";

  @override
  String fullRomanizedName() => "$xingshiPinyin $mingPinyin";

  @override
  String givenName() => ming;
}
