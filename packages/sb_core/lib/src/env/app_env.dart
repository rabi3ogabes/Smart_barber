/// Build flavour and API location, injected with `--dart-define-from-file=env/<flavor>.json`.
enum Flavor { dev, staging, prod }

/// Environment of the running build. Created once at start-up with [AppEnv.fromDefines].
class AppEnv {
  /// Creates an environment.
  const new({required this.flavor, required this.apiBaseUrl});

  /// Reads the compile-time defines and validates them; a bad prod build fails at start-up.
  factory fromDefines() {
    const flavorName = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
    const apiBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://10.0.2.2:8000/api/v1');
    final flavor = Flavor.values.firstWhere((f) => f.name == flavorName, orElse: () => Flavor.dev);

    return AppEnv(flavor: flavor, apiBaseUrl: apiBaseUrl)..validate();
  }

  /// The only host a production build may talk to.
  static const productionApiHost = 'api.smartbarber.app';

  /// Build flavour.
  final Flavor flavor;

  /// Base URL including `/api/v1`.
  final String apiBaseUrl;

  /// Whether this is a production build.
  bool get isProduction => flavor == Flavor.prod;

  /// Never ship a test API URL (flutter.md, Flavors): prod must be https on the prod host.
  void validate() {
    final uri = Uri.tryParse(apiBaseUrl);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      throw StateError('API_BASE_URL is not a valid URL: $apiBaseUrl');
    }
    if (isProduction && (uri.scheme != 'https' || uri.host != productionApiHost)) {
      throw StateError('Production builds must use https://$productionApiHost (got $apiBaseUrl).');
    }
  }
}
