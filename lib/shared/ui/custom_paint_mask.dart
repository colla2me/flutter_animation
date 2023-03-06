import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class RenderCustomPaintMask extends RenderProxyBox {
  CustomPainter painter;

  RenderCustomPaintMask({required this.painter});

  @override
  void paint(context, offset) {
    void paintContent(PaintingContext context, Offset offset) {
      // Paint foreground
      super.paint(context, offset);
    }

    void paintMask(PaintingContext context, Offset offset) {
      if (offset != Offset.zero) context.canvas.translate(offset.dx, offset.dy);

      painter.paint(context.canvas, size);
    }

    void paintEverything(PaintingContext context, Offset offset) {
      paintContent(context, offset);
      context.canvas
          .saveLayer(offset & size, Paint()..blendMode = BlendMode.dstIn);
      paintMask(context, offset);
      context.canvas.restore();
    }

    context.pushOpacity(offset, 255, paintEverything);
  }
}

/// This widget is used to mask `child` using `painter`
/// Anything rendered with `painter` acts as an alpha mask for child (child is transparent by default), the color of anything rendered with `painter` is ignored
///
/// See also:
///  - [CustomPainter](in the rendering library), for information on how to implement `painter`
class CustomPaintMask extends SingleChildRenderObjectWidget {
  final CustomPainter painter;

  const CustomPaintMask({
    super.key,
    super.child,
    required this.painter,
  });

  @override
  RenderObject createRenderObject(context) {
    return RenderCustomPaintMask(painter: painter);
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderCustomPaintMask renderObject) {
    renderObject.painter = painter;
  }
}
