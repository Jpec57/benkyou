import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';

class TinderCardAnimations
{
  static Animation<Alignment> backCardAlignmentAnim(AnimationController parent, List<Alignment> cardsAlign)
  {
    return AlignmentTween
      (
        begin: cardsAlign[0],
        end: cardsAlign[1]
    ).animate
      (
        CurvedAnimation
          (
            parent: parent,
            curve: Interval(0.4, 0.7, curve: Curves.easeIn)
        )
    );
  }

  static Animation<Size> backCardSizeAnim(AnimationController parent, List<Size> cardsSize)
  {
    return SizeTween
      (
        begin: cardsSize[1],
        end: cardsSize[0]
    ).animate
      (
        CurvedAnimation
          (
            parent: parent,
            curve: Interval(0.4, 0.7, curve: Curves.easeIn)
        )
    );
  }

  static Animation<Alignment> frontCardDisappearAlignmentAnim(AnimationController parent, Alignment beginAlign)
  {
    return AlignmentTween
      (
        begin: beginAlign,
        end: Alignment(beginAlign.x > 0 ? beginAlign.x + 40.0 : beginAlign.x - 40.0, 0.0) // Has swiped to the left or right?
    ).animate
      (
        CurvedAnimation
          (
            parent: parent,
            curve: Interval(0.0, 0.5, curve: Curves.easeIn)
        )
    );
  }
}