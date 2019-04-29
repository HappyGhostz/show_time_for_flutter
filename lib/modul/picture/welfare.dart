/**
 * @author zcp
 * @date 2019/4/29
 * @Description
 */
import 'package:json_annotation/json_annotation.dart';

part 'welfare.g.dart';


@JsonSerializable()
class Welfare {

  @JsonKey(name: 'error')
  bool error;

  @JsonKey(name: 'results')
  List<Results> results;

  Welfare(this.error,this.results,);

  factory Welfare.fromJson(Map<String, dynamic> srcJson) => _$WelfareFromJson(srcJson);

}


@JsonSerializable()
class Results {

  @JsonKey(name: '_id')
  String id;

  @JsonKey(name: 'createdAt')
  String createdAt;

  @JsonKey(name: 'desc')
  String desc;

  @JsonKey(name: 'publishedAt')
  String publishedAt;

  @JsonKey(name: 'source')
  String source;

  @JsonKey(name: 'type')
  String type;

  @JsonKey(name: 'url')
  String url;

  @JsonKey(name: 'used')
  bool used;

  @JsonKey(name: 'who')
  String who;

  Results(this.id,this.createdAt,this.desc,this.publishedAt,this.source,this.type,this.url,this.used,this.who,);

  factory Results.fromJson(Map<String, dynamic> srcJson) => _$ResultsFromJson(srcJson);

}


