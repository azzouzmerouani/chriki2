/// Centralized route path constants for the application.
///
/// All route paths used in [GoRouter] and navigation calls
/// should reference this class to avoid hardcoded strings.
class AppRoutes {
  AppRoutes._();

  // ── Root ──────────────────────────────────────────────
  static const String home = '/';
  static const String onboarding = '/onboarding';
  // ── Entrepreneur ──────────────────────────────────────
  static const String entrepreneur = '/entrepreneur';
  static const String entrepreneurNew = '/entrepreneur/new';

  // ── Investor ──────────────────────────────────────────
  static const String investor = '/investor';
  static const String investorSummary = '/investor/summary';
  static const String investorDetail = '/investor/:id';

  // ── Real Estate ───────────────────────────────────────
  static const String realEstate = '/real-estate';
  static const String projectDetail = '/real-estate/project/:id';
  static const String crowdfunding = '/real-estate/crowdfunding';
  static const String propertyValuation = '/real-estate/valuation';
  static const String realEstateExperts = '/real-estate/experts';

  // ── Legal & Finance ───────────────────────────────────
  static const String legalFinance = '/legal-finance';
  static const String expertProfile = '/legal-finance/expert/:id';
  static const String bankingHub = '/legal-finance/banking';
  static const String applyFunding = '/legal-finance/apply-funding';
  static const String statusTracker = '/legal-finance/status-tracker';

  // ── Relative sub-paths (used inside nested GoRoute) ──
  static const String newSub = 'new';
  static const String summarySub = 'summary';
  static const String idSub = ':id';
  static const String projectIdSub = 'project/:id';
  static const String crowdfundingSub = 'crowdfunding';
  static const String valuationSub = 'valuation';
  static const String expertsSub = 'experts';
  static const String expertIdSub = 'expert/:id';
  static const String bankingSub = 'banking';
  static const String applyFundingSub = 'apply-funding';
  static const String statusTrackerSub = 'status-tracker';

  // ── Route names ───────────────────────────────────────
  static const String onboardingName = 'onboarding';
  static const String homeName = 'home';
  static const String entrepreneurName = 'entrepreneur';
  static const String entrepreneurNewName = 'entrepreneur-new';
  static const String investorName = 'investor';
  static const String investmentSummaryName = 'investment-summary';
  static const String investorDetailName = 'investor-detail';
  static const String realEstateName = 'real-estate';
  static const String projectDetailName = 'project-detail';
  static const String crowdfundingName = 'crowdfunding';
  static const String propertyValuationName = 'property-valuation';
  static const String realEstateExpertsName = 'real-estate-experts';
  static const String legalFinanceName = 'legal-finance';
  static const String expertProfileName = 'expert-profile';
  static const String bankingHubName = 'banking-hub';
  static const String applyFundingName = 'apply-funding';
  static const String statusTrackerName = 'status-tracker';

  // ── Helper methods for parameterized routes ───────────
  static String investorDetailPath(String id) => '/investor/$id';
  static String projectDetailPath(String id) => '/real-estate/project/$id';
  static String expertProfilePath(String id) => '/legal-finance/expert/$id';
}
