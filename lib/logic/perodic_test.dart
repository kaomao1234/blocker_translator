import 'dart:async';
main() {
  const oneSec = Duration(milliseconds: 200);
  print("${1/30}");
  Timer.periodic(oneSec, (Timer t) => print('hi!'));
}