import 'package:flutter/gestures.dart';

class AllowMultipleScaleRecognizer extends ScaleGestureRecognizer {
  // bool alwaysAccept=false;
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
  // @override
  // void resolve(GestureDisposition disposition) {
  //   if(alwaysAccept) {
  //     super.resolve(GestureDisposition.accepted);
  //   } else {
  //     super.resolve(GestureDisposition.rejected);
  //   }
  // }
}