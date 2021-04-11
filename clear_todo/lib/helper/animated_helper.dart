import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class AnimatedHelper {
  static void runAnimateSpring(
      {@required double begin,
      @required double end,
      @required AnimationController controllerSpring,

      Function whenCompleteOrCancel}) {


    const spring = SpringDescription(
      damping: 20,
      mass: 1,
      stiffness: 100,
    );

    final simulation = SpringSimulation(spring, 0, 1, 10);

    controllerSpring?.animateWith(simulation)?.whenCompleteOrCancel(() {
      if (whenCompleteOrCancel != null) {
        whenCompleteOrCancel();
      }
    });
  }
}
