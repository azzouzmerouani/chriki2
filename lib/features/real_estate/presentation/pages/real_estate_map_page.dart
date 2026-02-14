import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/strings_const.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../core/widgets/unsplash_image_widget.dart';
import '../../data/models/real_estate_model.dart';
import '../../logic/cubit/real_estate_cubit.dart';
import '../../logic/cubit/real_estate_state.dart';

class RealEstateMapPage extends StatelessWidget {
  const RealEstateMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RealEstateCubit()..loadProjects(),
      child: const _RealEstateMapView(),
    );
  }
}

class _RealEstateMapView extends StatefulWidget {
  const _RealEstateMapView();

  @override
  State<_RealEstateMapView> createState() => _RealEstateMapViewState();
}

class _RealEstateMapViewState extends State<_RealEstateMapView> {
  bool _showMap = true;

  String _typeLabel(RealEstateType type) {
    switch (type) {
      case RealEstateType.residential:
        return StringsConst.residential.tr();
      case RealEstateType.commercial:
        return StringsConst.commercial.tr();
      case RealEstateType.land:
        return StringsConst.land.tr();
      case RealEstateType.renovation:
        return StringsConst.renovation.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringsConst.realEstate.tr()),
        actions: [
          IconButton(
            icon: Icon(_showMap ? Iconsax.menu_1 : Iconsax.map),
            onPressed: () => setState(() => _showMap = !_showMap),
          ),
          IconButton(
            icon: const Icon(Iconsax.people),
            onPressed: () => context.go(AppRoutes.crowdfunding),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Iconsax.more),
            onSelected: (value) {
              switch (value) {
                case 'valuation':
                  context.go(AppRoutes.propertyValuation);
                  break;
                case 'experts':
                  context.go(AppRoutes.realEstateExperts);
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'valuation',
                child: Row(
                  children: [
                    const Icon(
                      Iconsax.calculator,
                      color: AppColors.textPrimary,
                    ),
                    SizedBox(width: 8.w),
                    Text(StringsConst.valueProperty.tr()),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'experts',
                child: Row(
                  children: [
                    const Icon(Iconsax.people, color: AppColors.textPrimary),
                    SizedBox(width: 8.w),
                    Text(StringsConst.expertServices.tr()),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<RealEstateCubit, RealEstateState>(
        builder: (context, state) {
          if (state is RealEstateLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is RealEstateLoaded) {
            return Column(
              children: [
                // Filter chips
                SizedBox(
                  height: 50.h,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: FilterChip(
                          label: Text(StringsConst.viewAll.tr()),
                          selected: state.activeFilter == null,
                          onSelected: (_) => context
                              .read<RealEstateCubit>()
                              .filterByType(null),
                          selectedColor: AppColors.primary.withValues(
                            alpha: 0.2,
                          ),
                        ),
                      ),
                      ...RealEstateType.values.map((t) {
                        return Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: FilterChip(
                            label: Text(_typeLabel(t)),
                            selected: state.activeFilter == t,
                            onSelected: (_) =>
                                context.read<RealEstateCubit>().filterByType(t),
                            selectedColor: AppColors.primary.withValues(
                              alpha: 0.2,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                Expanded(
                  child: _showMap
                      ? _MapView(projects: state.projects)
                      : _ListView(projects: state.projects),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _MapView extends StatelessWidget {
  final List<RealEstateProject> projects;

  const _MapView({required this.projects});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(25.0, 45.0),
        initialZoom: 4,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.sheriki.app',
        ),
        MarkerLayer(
          markers: projects.map((project) {
            return Marker(
              point: LatLng(project.latitude, project.longitude),
              width: 40,
              height: 40,
              child: GestureDetector(
                onTap: () =>
                    context.go(AppRoutes.projectDetailPath(project.id)),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(
                    Iconsax.building_3,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ListView extends StatelessWidget {
  final List<RealEstateProject> projects;

  const _ListView({required this.projects});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 16.h),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return _ProjectCard(project: project);
      },
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final RealEstateProject project;

  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    return SherikiCard(
      onTap: () => context.go(AppRoutes.projectDetailPath(project.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project image
          UnsplashImageWidget(
            keyword: _imageKeyword(project.type),
            size: 'small',
            height: 140.h,
            borderRadius: BorderRadius.circular(12.r),
            overlayGradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.3)],
            ),
          ),
          SizedBox(height: 12.h),
          // Header with type badge
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  _typeIcon(project.type),
                  color: AppColors.primary,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(project.title, style: AppTextStyles.labelLarge),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Icon(
                          Iconsax.location,
                          size: 14.sp,
                          color: AppColors.textHint,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            project.address,
                            style: AppTextStyles.caption,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (project.isCrowdfunding)
                SherikiStatusBadge(
                  text: StringsConst.crowdfunding.tr(),
                  color: AppColors.accent,
                ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            project.description,
            style: AppTextStyles.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 12.h),

          // Funding progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${project.fundingPercentage.toStringAsFixed(0)}% ${StringsConst.fundedPercentage.tr()}',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
              Text(
                '${(project.currentFunding / 1000000).toStringAsFixed(0)}M / ${(project.totalFunding / 1000000).toStringAsFixed(0)}M DZD',
                style: AppTextStyles.caption,
              ),
            ],
          ),
          SizedBox(height: 6.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: project.fundingPercentage / 100,
              backgroundColor: AppColors.divider,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              minHeight: 6.h,
            ),
          ),
          SizedBox(height: 12.h),

          // Bottom info
          Row(
            children: [
              _InfoTile(
                icon: Iconsax.people,
                value: '${project.investorsCount}',
                label: StringsConst.investorsCount.tr(),
              ),
              SizedBox(width: 16.w),
              _InfoTile(
                icon: Iconsax.dollar_circle,
                value:
                    '${(project.minInvestment / 1000000).toStringAsFixed(1)}M DZD',
                label: StringsConst.minInvestment.tr(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _typeIcon(RealEstateType type) {
    switch (type) {
      case RealEstateType.residential:
        return Iconsax.home;
      case RealEstateType.commercial:
        return Iconsax.building;
      case RealEstateType.land:
        return Iconsax.map_1;
      case RealEstateType.renovation:
        return Iconsax.setting_2;
    }
  }

  String _imageKeyword(RealEstateType type) {
    switch (type) {
      case RealEstateType.residential:
        return 'luxury residential apartment';
      case RealEstateType.commercial:
        return 'commercial office building';
      case RealEstateType.land:
        return 'land development aerial';
      case RealEstateType.renovation:
        return 'villa renovation architecture';
    }
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _InfoTile({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: AppColors.textSecondary),
        SizedBox(width: 4.w),
        Text('$value ', style: AppTextStyles.labelSmall),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}
