import 'dart:math';

import 'package:flutter/material.dart';
import '../widgets/particles.dart';

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

class Particle2DemoePage extends StatefulWidget {
  const Particle2DemoePage({super.key});

  @override
  State<Particle2DemoePage> createState() => _Particle2DemoePageState();
}

class _Particle2DemoePageState extends State<Particle2DemoePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Random random;
  late int seed;

  @override
  void initState() {
    super.initState();
    random = Random();
    seed = random.nextInt(100000000);
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    controller.addStatusListener((status) {
      if (status == AnimationStatus.forward ||
          status == AnimationStatus.reverse) {
        seed = random.nextInt(10000000);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: AnimatedParticle(
          controller: controller,
          particle: Particle2Demo(),
          seed: seed,
          child: FloatingActionButton(
            onPressed: () {
              controller.forward(from: 0.0);
            },
          ),
        ),
      ),
    );
  }
}

class Particle2Demo extends Particle {
  @override
  void paint(Canvas canvas, Size size, progress, seed) {
    final sizeArr = <Size>[
      const Size(8, 8),
      const Size(12, 12),
      const Size(10, 10),
    ];
    final offsetAerr = <Offset>[
      const Offset(0, 30),
      const Offset(1, 20),
    ];
    CompositeParticle(children: [
      CircleParticles.builder(
        numberOfParticles: 1,
        particleBuilder: (index) {
          return AnimatedPositionedParticle(
            begin: const Offset(0.0, 20.0),
            end: const Offset(0.0, 60.0),
            child: FadingRect(
              width: sizeArr[index].width,
              height: sizeArr[index].height,
              color: Colors.orange,
            ),
          );
        },
        initialRotation: -pi * 3 / 4,
      ),
      CircleParticles.builder(
        numberOfParticles: 2,
        particleBuilder: (index) {
          return AnimatedPositionedParticle(
            begin: const Offset(0.0, 20.0),
            end: const Offset(0.0, 70.0),
            child: FadingRect(
              width: sizeArr[index + 1].width,
              height: sizeArr[index + 1].height,
              color: Colors.orange,
            ),
          );
        },
        initialRotation: -pi / 3,
      ),
      CircleParticles.builder(
        numberOfParticles: 1,
        particleBuilder: (index) {
          return AnimatedPositionedParticle(
            begin: const Offset(0.0, 20.0),
            end: const Offset(0.0, 60.0),
            child: FadingRect(
              width: sizeArr[index].width,
              height: sizeArr[index].height,
              color: Colors.orange,
            ),
          );
        },
        initialRotation: pi / 4,
      ),
      CircleParticles.builder(
        numberOfParticles: 2,
        particleBuilder: (index) {
          return AnimatedPositionedParticle(
            begin: const Offset(0.0, 20.0),
            end: const Offset(0.0, 70.0),
            child: FadingRect(
              width: sizeArr[index + 1].width,
              height: sizeArr[index + 1].height,
              color: Colors.orange,
            ),
          );
        },
        initialRotation: pi * 2 / 3,
      ),
      CircleParticles.builder(
        numberOfParticles: 2,
        radians: pi / 7,
        particleBuilder: (index) {
          return AnimatedPositionedParticle(
            begin: const Offset(0.0, 20.0),
            end: const Offset(0.0, 80.0),
            child: FadingLine(
              offset: offsetAerr[index],
              color: intToColor(index),
            ),
          );
        },
        initialRotation: -pi * 2 / 3,
      ),
      CircleParticles.builder(
        numberOfParticles: 2,
        radians: pi / 7,
        particleBuilder: (index) {
          return AnimatedPositionedParticle(
            begin: const Offset(0.0, 20.0),
            end: const Offset(0.0, 80.0),
            child: FadingLine(
              offset: offsetAerr[index],
              color: intToColor(index),
            ),
          );
        },
        initialRotation: pi / 3,
      ),
    ]).paint(canvas, size, progress, seed);
  }
}
