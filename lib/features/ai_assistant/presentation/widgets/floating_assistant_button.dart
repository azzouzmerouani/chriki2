import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../pages/ai_assistant_page.dart';

/// Wraps the whole app and draws a draggable AI assistant bubble on top
/// of every screen.
///
/// The bubble gently floats, can be dragged anywhere, snaps to the nearest
/// side when released and opens the assistant chat when tapped. It is
/// hidden on onboarding and while the chat itself is open.
class FloatingAssistantButton extends StatefulWidget {
  final Widget child;

  const FloatingAssistantButton({super.key, required this.child});

  @override
  State<FloatingAssistantButton> createState() =>
      _FloatingAssistantButtonState();
}

class _FloatingAssistantButtonState extends State<FloatingAssistantButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat();

  /// Top-left position of the bubble; `null` until first layout.
  Offset? _position;
  bool _isDragging = false;

  double get _size => 58.w;
  double get _edgeMargin => 12.w;

  /// Leaves room for the bottom navigation bar.
  double get _bottomReserved => 90.h;

  @override
  void initState() {
    super.initState();
    AppRouter.router.routerDelegate.addListener(_onRouteChanged);
    AiAssistantPage.isOpen.addListener(_onRouteChanged);
  }

  @override
  void dispose() {
    AppRouter.router.routerDelegate.removeListener(_onRouteChanged);
    AiAssistantPage.isOpen.removeListener(_onRouteChanged);
    _floatController.dispose();
    super.dispose();
  }

  void _onRouteChanged() {
    if (mounted) setState(() {});
  }

  bool get _isOnOnboarding {
    final config = AppRouter.router.routerDelegate.currentConfiguration;
    return config.uri.path == AppRoutes.onboarding;
  }

  void _openChat() {
    if (AiAssistantPage.isOpen.value) return;
    AppRouter.router.push(AppRoutes.aiAssistant);
  }

  Offset _clamp(Offset position, Size screen, EdgeInsets padding) {
    final minX = _edgeMargin;
    final maxX = screen.width - _size - _edgeMargin;
    final minY = padding.top + _edgeMargin;
    final maxY = screen.height - padding.bottom - _size - _bottomReserved;
    return Offset(
      position.dx.clamp(minX, math.max(minX, maxX)),
      position.dy.clamp(minY, math.max(minY, maxY)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screen = media.size;
    final padding = media.padding;

    final hidden = AiAssistantPage.isOpen.value || _isOnOnboarding;
    final position = _clamp(
      _position ??
          Offset(screen.width - _size - _edgeMargin, screen.height * 0.65),
      screen,
      padding,
    );

    return Stack(
      children: [
        widget.child,
        AnimatedPositioned(
          duration: _isDragging
              ? Duration.zero
              : const Duration(milliseconds: 350),
          curve: Curves.easeOutBack,
          left: position.dx,
          top: position.dy,
          child: IgnorePointer(
            ignoring: hidden,
            child: AnimatedScale(
              scale: hidden ? 0 : 1,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              child: GestureDetector(
                onTap: _openChat,
                onPanStart: (_) => setState(() => _isDragging = true),
                onPanUpdate: (details) => setState(() {
                  _position = _clamp(position + details.delta, screen, padding);
                }),
                onPanEnd: (_) => setState(() {
                  _isDragging = false;
                  final snapLeft = position.dx + _size / 2 < screen.width / 2;
                  _position = _clamp(
                    Offset(
                      snapLeft
                          ? _edgeMargin
                          : screen.width - _size - _edgeMargin,
                      position.dy,
                    ),
                    screen,
                    padding,
                  );
                }),
                child: AnimatedBuilder(
                  animation: _floatController,
                  builder: (context, child) {
                    final wave = math.sin(_floatController.value * 2 * math.pi);
                    return Transform.translate(
                      offset: Offset(0, _isDragging ? 0 : wave * 5),
                      child: child,
                    );
                  },
                  child: _Bubble(size: _size, isDragging: _isDragging),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Bubble extends StatelessWidget {
  final double size;
  final bool isDragging;

  const _Bubble({required this.size, required this.isDragging});

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isDragging ? 1.1 : 1,
      duration: const Duration(milliseconds: 150),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: AppColors.surface, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: isDragging ? 20 : 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Iconsax.message_programming,
              color: AppColors.textOnPrimary,
              size: size * 0.45,
            ),
            PositionedDirectional(
              top: size * 0.12,
              end: size * 0.12,
              child: Container(
                width: size * 0.18,
                height: size * 0.18,
                decoration: BoxDecoration(
                  color: AppColors.secondaryLight,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.surface, width: 1.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
