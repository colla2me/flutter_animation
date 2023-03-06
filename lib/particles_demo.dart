import 'dart:math';

import 'package:flutter/material.dart';
import 'widgets/pimp_my_button.dart';

Color intToColor(int col) {
  col = col % 5;
  if (col == 0) return Colors.red;
  if (col == 1) return Colors.green;
  if (col == 2) return Colors.orange;
  if (col == 3) return Colors.blue;
  if (col == 4) return Colors.pink;
  if (col == 5) return Colors.brown;
  return Colors.black;
}

class ParticlesDemoPage extends StatelessWidget {
  const ParticlesDemoPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: PimpedButton(
                        particle: ParticlesDemo(),
                        pimpedWidgetBuilder: (context, controller) {
                          return FloatingActionButton(
                            onPressed: () {
                              controller.forward(from: 0.0);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: PimpedButton(
                        particle: RectangleDemoParticle(),
                        pimpedWidgetBuilder: (context, controller) {
                          return TextButton(
                            onPressed: () {
                              controller.forward(from: 0.0);
                              // controller.repeat();
                            },
                            child: const Text("Special button"),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: PimpedButton(
                        particle: Rectangle2DemoParticle(),
                        pimpedWidgetBuilder: (context, controller) {
                          return MaterialButton(
                            onPressed: () {
                              controller.forward(from: 0.0);
                            },
                            child: const Text("Special button"),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            PimpedButton(
              particle: ListTileDemoParticle(),
              pimpedWidgetBuilder: (context, controller) {
                return ListTile(
                  title: const Text("ListTile"),
                  subtitle: const Text("Some nice subtitle"),
                  trailing: const Icon(Icons.add),
                  onTap: () {
                    controller.forward(from: 0.0);
                  },
                );
              },
            ),
            Center(
              child: PimpedButton(
                particle: Rectangle2DemoParticle(),
                pimpedWidgetBuilder: (context, controller) {
                  return IconButton(
                    icon: const Icon(Icons.favorite_border),
                    color: Colors.indigo,
                    onPressed: () {
                      controller.forward(from: 0.0);
                    },
                  );
                },
              ),
            ),
            Expanded(
              child: Center(
                child: PimpedButton(
                  particle: Rectangle3DemoParticle(),
                  pimpedWidgetBuilder: (context, controller) {
                    return TextButton(
                      onPressed: () {
                        controller.forward(from: 0.0);
                      },
                      child: const Text("Rectangles"),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ParticlesDemo extends Particle {
  @override
  void paint(Canvas canvas, Size size, progress, seed) {
    Random random = Random(seed);
    int randomMirrorOffset = random.nextInt(8) + 1;
    CompositeParticle(children: [
      Firework(),
      CircleMirror(
        numberOfParticles: 6,
        child: AnimatedPositionedParticle(
          begin: const Offset(0.0, 20.0),
          end: const Offset(0.0, 60.0),
          child: FadingRect(width: 5.0, height: 15.0, color: Colors.pink),
        ),
        initialRotation: -pi / randomMirrorOffset,
      ),
      CircleMirror.builder(
        numberOfParticles: 6,
        particleBuilder: (index) {
          return IntervalParticle(
            child: AnimatedPositionedParticle(
              begin: const Offset(0.0, 30.0),
              end: const Offset(0.0, 50.0),
              child: FadingTriangle(
                baseSize: 6.0 + random.nextDouble() * 4.0,
                heightToBaseFactor: 1.0 + random.nextDouble(),
                variation: random.nextDouble(),
                color: Colors.green,
              ),
            ),
            interval: const Interval(0.0, 0.8),
          );
        },
        initialRotation: -pi / randomMirrorOffset + 8,
      ),
    ]).paint(canvas, size, progress, seed);
  }
}

class RectangleDemoParticle extends Particle {
  @override
  void paint(Canvas canvas, Size size, progress, seed) {
    Random random = Random(seed);
    int randomMirrorOffset = random.nextInt(8) + 1;
    CompositeParticle(children: [
      Firework(),
      RectangleMirror.builder(
        numberOfParticles: 13,
        particleBuilder: (value) {
          return AnimatedPositionedParticle(
            begin: const Offset(0.0, -10.0),
            end: const Offset(0.0, -60.0),
            child: FadingRect(
              width: 5.0,
              height: 15.0,
              color: intToColor(value),
            ),
          );
        },
        initialDistance: -pi / randomMirrorOffset,
      ),
      CircleMirror.builder(
        numberOfParticles: 6,
        particleBuilder: (index) {
          return IntervalParticle(
            child: AnimatedPositionedParticle(
              begin: const Offset(0.0, 30.0),
              end: Offset(0.0, 50.0 + (7.5 - 15 * random.nextDouble())),
              child: FadingTriangle(
                  baseSize: 6.0 + random.nextDouble() * 4.0,
                  heightToBaseFactor: 1.0 + random.nextDouble(),
                  variation: random.nextDouble(),
                  color: Colors.green),
            ),
            interval: const Interval(0.0, 0.8),
          );
        },
        initialRotation: -pi / randomMirrorOffset + 8,
      ),
    ]).paint(canvas, size, progress, seed);
  }
}

class Rectangle2DemoParticle extends Particle {
  @override
  void paint(Canvas canvas, Size size, progress, seed) {
    Random random = Random(seed);
    int randomMirrorOffset = random.nextInt(8) + 1;
    CompositeParticle(children: [
      Firework(),
      RectangleMirror.builder(
          numberOfParticles: 6,
          particleBuilder: (value) {
            return AnimatedPositionedParticle(
              begin: const Offset(0.0, -10.0),
              end: const Offset(0.0, -60.0),
              child: FadingRect(
                width: 5.0,
                height: 15.0,
                color: intToColor(value),
              ),
            );
          },
          initialDistance: -pi / randomMirrorOffset),
    ]).paint(canvas, size, progress, seed);
  }
}

class Rectangle3DemoParticle extends Particle {
  @override
  void paint(Canvas canvas, Size size, progress, seed) {
    Random random = Random(seed);
    int randomMirrorOffset = random.nextInt(8) + 1;
    CompositeParticle(children: [
      Firework(),
      RectangleMirror.builder(
          numberOfParticles: 6,
          particleBuilder: (value) {
            return AnimatedPositionedParticle(
                begin: const Offset(0.0, -10.0),
                end: const Offset(0.0, -50.0),
                child: RotationParticle(
                  rotation: random.nextDouble() * (2 * pi),
                  child: FadingTriangle(
                    baseSize: 12.0 + random.nextDouble(),
                    heightToBaseFactor: 0.8 + random.nextDouble(),
                    variation: random.nextDouble(),
                    color: intToColor(value),
                  ),
                ));
          },
          initialDistance: -pi / randomMirrorOffset),
      RectangleMirror.builder(
          numberOfParticles: 8,
          particleBuilder: (value) {
            return AnimatedPositionedParticle(
                begin: const Offset(0.0, -10.0),
                end: const Offset(0.0, -30.0),
                child: RotationParticle(
                  rotation: random.nextDouble() * (2 * pi),
                  child: FadingTriangle(
                    baseSize: 12.0 + random.nextDouble(),
                    heightToBaseFactor: 0.8 + random.nextDouble(),
                    variation: random.nextDouble(),
                    color: intToColor(value),
                  ),
                ));
          },
          initialDistance: 80.0),
    ]).paint(canvas, size, progress, seed);
  }

  double randomOffset(Random random, int range) {
    return range / 2 - random.nextInt(range);
  }
}

class ListTileDemoParticle extends Particle {
  @override
  void paint(Canvas canvas, Size size, progress, seed) {
    CompositeParticle(children: [
      Firework(),
      Firework(),
      Firework(),
      RectangleMirror.builder(
          numberOfParticles: 8,
          particleBuilder: (value) {
            return AnimatedPositionedParticle(
              begin: const Offset(0.0, -30.0),
              end: const Offset(0.0, -80.0),
              child: FadingRect(
                width: 5.0,
                height: 15.0,
                color: intToColor(value),
              ),
            );
          },
          initialDistance: 0.0),
      RectangleMirror.builder(
          numberOfParticles: 5,
          particleBuilder: (value) {
            return AnimatedPositionedParticle(
              begin: const Offset(0.0, -25.0),
              end: const Offset(0.0, -60.0),
              child: FadingRect(
                width: 5.0,
                height: 15.0,
                color: intToColor(value),
              ),
            );
          },
          initialDistance: 30.0),
      RectangleMirror.builder(
          numberOfParticles: 8,
          particleBuilder: (value) {
            return AnimatedPositionedParticle(
              begin: const Offset(0.0, -40.0),
              end: const Offset(0.0, -100.0),
              child: FadingRect(
                width: 5.0,
                height: 15.0,
                color: intToColor(value),
              ),
            );
          },
          initialDistance: 80.0),
    ]).paint(canvas, size, progress, seed);
  }
}
