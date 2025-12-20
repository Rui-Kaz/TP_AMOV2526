import 'package:flutter/material.dart';

class IconMapper {
  static const Map<String, IconData> _iconMap = {
    'castle': Icons.castle,
    'museum': Icons.museum,
    'restaurant': Icons.restaurant,
    'travel_explore': Icons.travel_explore,
    'church': Icons.church,
    'park': Icons.park,
    'beach_access': Icons.beach_access,
    'nightlife': Icons.nightlife,
    'shopping_bag': Icons.shopping_bag,
    'local_cafe': Icons.local_cafe,
  };

  static IconData getIcon(String iconName) {
    return _iconMap[iconName] ?? Icons.travel_explore;
  }
}
