import 'dart:math';

import 'package:flutter/material.dart';

typedef ParticleBuilder = Particle Function(int index);

abstract class Particle {
  void paint(Canvas canvas, Size size, double progress, int seed);
}

class AnimatedParticle extends AnimatedWidget {
  const AnimatedParticle({
    super.key,
    required this.particle,
    required this.seed,
    required AnimationController controller,
    this.child,
  }) : super(listenable: controller);

  final Particle particle;
  final int seed;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final controller = listenable as AnimationController;
    bool shouldPaint = false;
    if (controller.status == AnimationStatus.forward ||
        controller.status == AnimationStatus.reverse) {
      shouldPaint = true;
    }
    return CustomPaint(
      painter: _ParticlePainter(
        particle: particle,
        seed: seed,
        controller: controller,
        shouldPaint: shouldPaint,
      ),
      child: child,
    );
  }
}

/// Make given particles around a circle.
class CircleParticles extends Particle {
  final ParticleBuilder particleBuilder;

  final double initialRotation;

  final double radians;

  final int numberOfParticles;

  CircleParticles.builder({
    this.radians = pi / 5,
    required this.particleBuilder,
    required this.initialRotation,
    required this.numberOfParticles,
  });

  CircleParticles({
    this.radians = pi / 5,
    required Particle child,
    required this.initialRotation,
    required this.numberOfParticles,
  }) : particleBuilder = ((index) => child);

  @override
  void paint(Canvas canvas, Size size, double progress, seed) {
    canvas.save();
    canvas.rotate(initialRotation);
    for (int i = 0; i < numberOfParticles; i++) {
      particleBuilder(i).paint(canvas, size, progress, seed);
      canvas.rotate(radians);
    }
    canvas.restore();
  }
}

/// Animates a childs position based on a Tween<Offset>
class AnimatedPositionedParticle extends Particle {
  AnimatedPositionedParticle({
    Offset? begin,
    Offset? end,
    required this.child,
  }) : offsetTween = Tween<Offset>(begin: begin, end: end);

  final Particle child;

  final Tween<Offset> offsetTween;

  @override
  void paint(Canvas canvas, Size size, double progress, seed) {
    canvas.save();
    canvas.translate(
        offsetTween.lerp(progress).dx, offsetTween.lerp(progress).dy);
    child.paint(canvas, size, progress, seed);
    canvas.restore();
  }
}

class CompositeParticle extends Particle {
  final List<Particle> children;

  CompositeParticle({required this.children});

  @override
  void paint(Canvas canvas, Size size, double progress, seed) {
    for (Particle particle in children) {
      particle.paint(canvas, size, progress, seed);
    }
  }
}

class IntervalParticle extends Particle {
  final Interval interval;

  final Particle child;

  IntervalParticle({
    required this.child,
    required this.interval,
  });

  @override
  void paint(Canvas canvas, Size size, double progress, seed) {
    if (progress < interval.begin || progress > interval.end) return;
    child.paint(canvas, size, interval.transform(progress), seed);
  }
}

/// A rectangle which also fades out over time.
class FadingRect extends Particle {
  final Color color;
  final double width;
  final double height;

  FadingRect({
    required this.color,
    required this.width,
    required this.height,
  });

  @override
  void paint(Canvas canvas, Size size, double progress, seed) {
    canvas.drawRect(Rect.fromLTWH(0.0, 0.0, width, height),
        Paint()..color = color.withOpacity(1 - progress));
  }
}

/// A line which also fades out over time.
class FadingLine extends Particle {
  final Color color;

  /// The offset from the origin
  final Offset offset;

  FadingLine({
    required this.color,
    required this.offset,
  });

  @override
  void paint(Canvas canvas, Size size, double progress, seed) {
    canvas.drawLine(
      Offset.zero,
      offset,
      Paint()
        ..color = color.withOpacity(1 - progress)
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 6.0
        ..style = PaintingStyle.stroke,
    );
  }
}

/// Custom particle painter
class _ParticlePainter extends CustomPainter {
  _ParticlePainter({
    required this.particle,
    required this.seed,
    required this.controller,
    required this.shouldPaint,
  }) : super(repaint: controller);

  final Particle particle;
  final int seed;
  final AnimationController controller;
  final bool shouldPaint;

  @override
  void paint(Canvas canvas, Size size) {
    if (shouldPaint) {
      canvas.translate(size.width / 2, size.height / 2);
      particle.paint(canvas, size, controller.value, seed);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => shouldPaint;
}
