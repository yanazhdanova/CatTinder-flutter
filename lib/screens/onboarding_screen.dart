import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onFinish;

  const OnboardingScreen({super.key, required this.onFinish});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  final List<_OnboardingStep> _steps = const [
    _OnboardingStep(
      title: 'Свайпы как в Tinder',
      subtitle: 'Свайп вправо — лайк ❤️\nСвайп влево — дизлайк ✖️',
      icon: Icons.swipe,
    ),
    _OnboardingStep(
      title: 'Детали породы',
      subtitle: 'Тап по карточке — откроются описание и темперамент.',
      icon: Icons.info_outline,
    ),
    _OnboardingStep(
      title: 'Список пород',
      subtitle: 'Во вкладке "Породы" — полный список и характеристики ⭐️',
      icon: Icons.list_alt,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_index >= _steps.length - 1) {
      widget.onFinish();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  void _skip() => widget.onFinish();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLast = _index == _steps.length - 1;

    return Scaffold(
      body: Stack(
        children: [

          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    scheme.secondary.withOpacity(0.55),
                    scheme.secondary.withOpacity(0.25),
                    Colors.white,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: -120,
            left: -80,
            child: _GlowBlob(color: scheme.primary.withOpacity(0.25), size: 260),
          ),
          Positioned(
            bottom: -140,
            right: -90,
            child: _GlowBlob(color: scheme.primary.withOpacity(0.20), size: 300),
          ),


          SafeArea(
            child: Stack(
              children: [
                // Pages
                PageView.builder(
                  controller: _controller,
                  itemCount: _steps.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (context, i) {
                    final step = _steps[i];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20, 26, 20, 148),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 8),
                          _TopBadge(text: 'CatTinder Pro', color: scheme.primary),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              _IconChip(icon: step.icon, color: scheme.primary),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  step.title,
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Text(
                            step.subtitle,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),


                Positioned.fill(
                  child: IgnorePointer(
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, _) {
                        final page = _safePage(_controller);
                        final frac = (page % 1).clamp(0.0, 1.0);

                        final screenWidth = MediaQuery.of(context).size.width;
                        final catWidth = 210.0;
                        final dx = lerpDouble(-1.5 * catWidth, screenWidth, frac) ?? 0.0;
                        final baseY = MediaQuery.of(context).size.height * 0.45;
                        final bounce = math.sin(frac * math.pi) * -80;
                        final scale = lerpDouble(0.9, 1.1, frac) ?? 1.0;
                        final rot = lerpDouble(-0.25, 0.25, frac) ?? 0.0;

                        return Align(
                          alignment: Alignment.topCenter,
                          child: Transform.translate(
                            offset: Offset(dx, baseY + bounce),
                            child: Transform.rotate(
                              angle: rot,
                              child: Transform.scale(
                                scale: scale,
                                child: _CatSticker(
                                  primary: scheme.primary,
                                  imagePath: 'assets/onboarding_cat.png',
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),


                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _Dots(count: _steps.length, index: _index),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          TextButton(
                            onPressed: _skip,
                            child: const Text('Пропустить'),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: _next,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: scheme.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(isLast ? 'Начать' : 'Далее'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _safePage(PageController c) {
    final p = c.hasClients ? (c.page ?? c.initialPage.toDouble()) : 0.0;
    if (p.isNaN || p.isInfinite) return 0.0;
    return p;
  }
}

class _OnboardingStep {
  final String title;
  final String subtitle;
  final IconData icon;

  const _OnboardingStep({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class _Dots extends StatelessWidget {
  final int count;
  final int index;

  const _Dots({required this.count, required this.index});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: active ? 22 : 8,
          decoration: BoxDecoration(
            color: active ? scheme.primary : scheme.primary.withOpacity(0.25),
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }),
    );
  }
}

class _TopBadge extends StatelessWidget {
  final String text;
  final Color color;

  const _TopBadge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _IconChip extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _IconChip({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: color),
    );
  }
}

class _GlowBlob extends StatelessWidget {
  final Color color;
  final double size;

  const _GlowBlob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 70,
            spreadRadius: 20,
          ),
        ],
      ),
    );
  }
}

class _CatSticker extends StatelessWidget {
  final Color primary;
  final String imagePath;

  const _CatSticker({required this.primary, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      width: 210,
      fit: BoxFit.contain,
    );
  }
}