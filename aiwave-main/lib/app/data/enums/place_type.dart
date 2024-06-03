import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum PlaceType {
  museums,
  // mountains,
  // parks,
  historical,
  // natural,
  leisure,
  adventure,
  cultural,
  heritage,
  // nature,
  religious,
  environment,
  medical,
  beach,
  naturereserves,
  other;

  // Convert enum value to a string key
  String toKey() => toString().split('.').last;

  // Create an enum value from a string key
  static PlaceType fromKey(String? key) {
    return PlaceType.values.firstWhere(
      (type) => type.toKey() == key,
      orElse: () => PlaceType.other,
    );
  }

  // Get the corresponding FontAwesome icon for the enum value
  IconData get icon {
    switch (this) {
      case PlaceType.museums:
        return FontAwesomeIcons.buildingColumns;
      // case PlaceType.mountains:
      //   return FontAwesomeIcons.mountain;
      // case PlaceType.parks:
      //   return FontAwesomeIcons.tree;
      case PlaceType.historical:
        return FontAwesomeIcons.landmark;
      // case PlaceType.natural:
      //   return FontAwesomeIcons.leaf;
      case PlaceType.leisure:
        return FontAwesomeIcons.book;
      case PlaceType.adventure:
        return FontAwesomeIcons.personHiking;
      case PlaceType.cultural:
        return FontAwesomeIcons.masksTheater;
      case PlaceType.heritage:
        return FontAwesomeIcons.monument;
      // case PlaceType.nature:
      //   return FontAwesomeIcons.water;
      case PlaceType.religious:
        return FontAwesomeIcons.church;
      case PlaceType.environment:
        return FontAwesomeIcons.earthAmericas;
      case PlaceType.medical:
        return FontAwesomeIcons.hospital;
      case PlaceType.beach:
        return FontAwesomeIcons.umbrellaBeach;
      case PlaceType.naturereserves:
        return FontAwesomeIcons.spa;
      // Add more cases for other enum values if needed
      default:
        return Icons.more_horiz;
    }
  }
}
