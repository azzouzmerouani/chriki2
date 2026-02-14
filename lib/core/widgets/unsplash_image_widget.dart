import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';

import '../services/unsplash_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// A widget that fetches and displays an Unsplash image by search keyword.
///
/// Shows a shimmer placeholder while loading, and a fallback icon on failure.
/// Provides proper Unsplash photographer attribution.
class UnsplashImageWidget extends StatefulWidget {
  /// The keyword to search for on Unsplash.
  final String keyword;

  /// Which image size to fetch (raw, full, regular, small, thumb).
  final String size;

  /// Index of the photo in search results to display.
  final int photoIndex;

  /// How the image should fit within its box.
  final BoxFit fit;

  /// Widget dimensions. Defaults to expand to parent.
  final double? width;
  final double? height;

  /// Border radius for clipping the image.
  final BorderRadius? borderRadius;

  /// Optional gradient overlay on top of the image.
  final Gradient? overlayGradient;

  /// Whether to show photographer attribution at the bottom.
  final bool showAttribution;

  /// Optional child widget overlaid on top of the image.
  final Widget? child;

  const UnsplashImageWidget({
    super.key,
    required this.keyword,
    this.size = 'small',
    this.photoIndex = 0,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
    this.overlayGradient,
    this.showAttribution = false,
    this.child,
  });

  @override
  State<UnsplashImageWidget> createState() => _UnsplashImageWidgetState();
}

class _UnsplashImageWidgetState extends State<UnsplashImageWidget> {
  String? _imageUrl;
  String? _photographerName;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchImage();
  }

  @override
  void didUpdateWidget(covariant UnsplashImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.keyword != widget.keyword ||
        oldWidget.photoIndex != widget.photoIndex) {
      _fetchImage();
    }
  }

  Future<void> _fetchImage() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    final photos = await UnsplashService.instance.searchPhotos(widget.keyword);
    if (!mounted) return;

    if (photos.isNotEmpty && widget.photoIndex < photos.length) {
      final photo = photos[widget.photoIndex];
      final urls = photo.urls;
      String url;
      switch (widget.size) {
        case 'raw':
          url = urls.raw;
        case 'full':
          url = urls.full;
        case 'regular':
          url = urls.regular;
        case 'thumb':
          url = urls.thumb;
        case 'small':
        default:
          url = urls.small;
      }
      setState(() {
        _imageUrl = url;
        _photographerName = photo.user.name;
        _isLoading = false;
      });
    } else {
      setState(() {
        _imageUrl = null;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = widget.borderRadius ?? BorderRadius.circular(12.r);

    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        width: widget.width ?? double.infinity,
        height: widget.height,
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return _buildShimmer();
    }

    if (_imageUrl == null || _imageUrl!.isEmpty) {
      return _buildPlaceholder();
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: _imageUrl!,
          fit: widget.fit,
          placeholder: (_, __) => _buildShimmer(),
          errorWidget: (_, __, ___) => _buildPlaceholder(),
        ),
        if (widget.overlayGradient != null)
          DecoratedBox(
            decoration: BoxDecoration(gradient: widget.overlayGradient),
          ),
        if (widget.showAttribution && _photographerName != null)
          Positioned(
            left: 6.w,
            bottom: 4.h,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                'Photo by $_photographerName on Unsplash',
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white,
                  fontSize: 8.sp,
                ),
              ),
            ),
          ),
        if (widget.child != null) widget.child!,
      ],
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.divider,
      highlightColor: AppColors.surface,
      child: Container(color: AppColors.divider),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.08),
      child: Center(
        child: Icon(Iconsax.image, size: 32.sp, color: AppColors.textHint),
      ),
    );
  }
}
