import 'package:flutter/material.dart';

class RectangleModel {
  Rect rect;
  String name;
  bool isEditing;
  TextEditingController nameController = TextEditingController();

  RectangleModel(this.rect, this.name) : isEditing = false;
}
