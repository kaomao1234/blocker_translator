class RectangleModel {
  late double left, top, width, height;
  RectangleModel(
      {required this.height,
      required this.width,
      required this.left,
      required this.top});

  Map<String, double> toJson() {
    return {"left": left, "top": top, "height": height, "width": width};
  }

  List<double> toList() {
    return [left, top, height, width];
  }
}
