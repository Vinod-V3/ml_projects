class AppConfig {
  static final AppConfig instance = AppConfig._internal();
  AppConfig._internal();

  Map<String, dynamic> _config = {};
  bool _initialized = false;

  void initialize(Map<String, dynamic> config) {
    if (_initialized) return;
    _config = Map<String, dynamic>.from(config);
    _initialized = true;
  }

  dynamic get(String key) => _config[key];
  Map<String, dynamic> get all => _config;

  String? get baseUrl => _config['baseUrl'] as String?;
  String? get token => _config['token'] as String?;
  String? get cookie => _config['cookie'] as String?;
  
  Map<String, dynamic>? get profileData {
    final data = _config['profileData'];
    return data is Map<String, dynamic> ? data : null;
  }

  void update(String key, dynamic value) {
    _config[key] = value;
  }

  void merge(Map<String, dynamic> newConfig) {
    _config.addAll(newConfig);
  }
}