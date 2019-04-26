/**
 * @author zcp
 * @date 2019/4/26
 * @Description
 */
import 'package:json_annotation/json_annotation.dart';

part 'hot_key.g.dart';


@JsonSerializable()
class HotKeyWord {

  @JsonKey(name: 'hotWords')
  List<String> hotWords;

  @JsonKey(name: 'ok')
  bool ok;

  HotKeyWord(this.hotWords,this.ok,);

  factory HotKeyWord.fromJson(Map<String, dynamic> srcJson) => _$HotKeyWordFromJson(srcJson);

}