import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Acts exactly like a `Stack` however the first child acts like an alpha mask when rendering the rest of the children
class RenderWidgetMask extends RenderStack {
  RenderWidgetMask({
    super.children,
    super.alignment,
    super.textDirection,
    super.fit,
  });

  @override
  void paintStack(context, offset) {
    // Early exit on no children
    if (firstChild == null || lastChild == null) return;

    void paintContent(PaintingContext context, Offset offset) {
      // Paint all but the first child
      RenderBox? child =
          (firstChild!.parentData as StackParentData).nextSibling;
      while (child != null) {
        final childParentData = child.parentData as StackParentData;
        context.paintChild(lastChild!, offset + childParentData.offset);
        child = childParentData.nextSibling;
      }
    }

    void paintMask(PaintingContext context, Offset offset) {
      if (firstChild == null) return;
      context.paintChild(firstChild!,
          offset + (firstChild?.parentData as StackParentData).offset);
    }

    void paintEverything(PaintingContext context, Offset offset) {
      paintContent(context, offset);
      context.canvas
          .saveLayer(offset & size, Paint()..blendMode = BlendMode.dstIn);
      paintMask(context, offset);
      context.canvas.restore();
    }

    // Force the foreground content to be composited onto this layer
    context.pushOpacity(offset, 255, paintEverything);
  }
}

/// Is a simple wrapper around the `Stack` widget that creates a custom stack based render object
class WidgetMask extends Stack {
  WidgetMask({
    super.key,
    super.alignment,
    super.textDirection,
    super.fit,
    required Widget maskChild,
    required Widget child,
  }) : super(children: [maskChild, child]);

  @override
  RenderStack createRenderObject(context) {
    return RenderWidgetMask(
      alignment: alignment,
      textDirection: textDirection ?? Directionality.of(context),
      fit: fit,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderWidgetMask renderObject) {
    renderObject
      ..alignment = alignment
      ..textDirection = textDirection ?? Directionality.of(context)
      ..fit = fit;
  }
}
