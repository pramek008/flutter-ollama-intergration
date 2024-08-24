// import '../env.dart';

class Endpoints {
  Endpoints._();

  // base url
  // static String baseDevUrl = Env.devUrl;
  // static String baseProdUrl = Env.prodUrl;

  static const int receiveTimeout = 15000;
  static const int connectionTimeout = 30000;

  // Auth
  static const String login = '/api/v1/auth/signin';
  // static const String login = '/auth/login';
  static const String register = '/api/v1/auth/register';
}
