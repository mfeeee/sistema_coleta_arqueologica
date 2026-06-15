import 'dart:async';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  FirebaseMessaging? _fcm;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  final StreamController<RemoteMessage> _onMessageController =
      StreamController<RemoteMessage>.broadcast();

  Stream<RemoteMessage> get onMessage => _onMessageController.stream;

  Future<void> initialize() async {
    try {
      _fcm = FirebaseMessaging.instance;

      // Solicitar permissão (necessário para iOS e Android 13+)
      final NotificationSettings settings = await _fcm!.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        log('Usuário concedeu permissão para notificações');
      }

      // Configurar notificações locais para foreground
      const initializationSettingsAndroid = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
      );
      await _localNotifications.initialize(settings: initializationSettings);

      // Foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        log('Recebeu mensagem no foreground: ${message.notification?.title}');
        _onMessageController.add(message);
      });

      // Background/Terminated messages
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );

      _initialized = true;
    } catch (e) {
      log('Falha ao inicializar NotificationService: $e');
      _initialized = false;
    }
  }

  Future<String?> getToken() async {
    if (!_initialized || _fcm == null) return null;
    try {
      return await _fcm!.getToken();
    } catch (e) {
      log('Erro ao obter token FCM: $e');
      return null;
    }
  }
}

// Handler para background (deve ser uma função top-level)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log('Handling a background message: ${message.messageId}');
}
