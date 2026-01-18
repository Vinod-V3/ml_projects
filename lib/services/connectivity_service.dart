import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:ml_projects/services/toast_service.dart';

class ConnectivityService {
  static final ConnectivityService instance = ConnectivityService._internal();
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  
  final _connectivityController = StreamController<bool>.broadcast();
  bool _isOnline = true;
  bool _isInitialized = false;

  Stream<bool> get connectivityStream => _connectivityController.stream;

  bool get isOnline => _isOnline;

  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('ConnectivityService already initialized');
      return;
    }

    final result = await _connectivity.checkConnectivity();
    _updateConnectivityStatus(result, showToast: false);

    _subscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> result) {
        _updateConnectivityStatus(result, showToast: true);
      },
    );

    _isInitialized = true;
    debugPrint('ConnectivityService initialized. Initial status: ${_isOnline ? "Online" : "Offline"}');
  }

  void _updateConnectivityStatus(List<ConnectivityResult> result, {required bool showToast}) {
    final wasOnline = _isOnline;
    
    _isOnline = result.any((r) => 
      r == ConnectivityResult.mobile || 
      r == ConnectivityResult.wifi || 
      r == ConnectivityResult.ethernet ||
      r == ConnectivityResult.vpn
    );

    if (wasOnline != _isOnline) {
      _connectivityController.add(_isOnline);
      
      if (showToast) {
        if (_isOnline) {
          ToastService.showSuccess('You are online');
        } else {
          ToastService.showError('You are offline');
        }
      }

      debugPrint('Connectivity changed: ${_isOnline ? "Online" : "Offline"}');
    }
  }

  void dispose() {
    _subscription?.cancel();
    _connectivityController.close();
    _isInitialized = false;
    debugPrint('ConnectivityService disposed');
  }
}
