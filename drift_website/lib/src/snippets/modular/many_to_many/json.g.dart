// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShoppingCartEntries _$ShoppingCartEntriesFromJson(Map<String, dynamic> json) =>
    ShoppingCartEntries(
      items: (json['items'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$ShoppingCartEntriesToJson(
  ShoppingCartEntries instance,
) => <String, dynamic>{'items': instance.items};
