/**
 * @author zcp
 * @date 2019/4/25
 * @Description
 */
import 'package:json_annotation/json_annotation.dart';

part 'auto_complete.g.dart';


@JsonSerializable()
class AutoComplete {

  @JsonKey(name: 'keywords')
  List<String> keywords;

  @JsonKey(name: 'ok')
  bool ok;

  AutoComplete(this.keywords,this.ok,);

  factory AutoComplete.fromJson(Map<String, dynamic> srcJson) => _$AutoCompleteFromJson(srcJson);

}