import 'package:chriki2/features/real_estate/logic/cubit/real_estate_cubit.dart';
import 'package:chriki2/features/real_estate/logic/cubit/real_estate_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('invest adds the amount and an investor to the project', () {
    final cubit = RealEstateCubit()
      ..loadProjects()
      ..loadCrowdfundingProjects();
    final before = (cubit.state as CrowdfundingLoaded).projects.first;

    cubit.invest(before.id, 2000000);

    final after = (cubit.state as CrowdfundingLoaded).projects.firstWhere(
      (p) => p.id == before.id,
    );
    expect(after.currentFunding, before.currentFunding + 2000000);
    expect(after.investorsCount, before.investorsCount + 1);
    cubit.close();
  });

  test('invest keeps the detail view on the detail state', () {
    final cubit = RealEstateCubit()
      ..loadProjects()
      ..loadProjectDetail('re1');
    final before = (cubit.state as RealEstateProjectDetailLoaded).project;

    cubit.invest('re1', 1000000);

    final after = (cubit.state as RealEstateProjectDetailLoaded).project;
    expect(after.remainingFunding, before.remainingFunding - 1000000);
    cubit.close();
  });
}
