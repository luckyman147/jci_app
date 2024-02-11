import 'package:dio/dio.dart';
import 'package:jci_app/core/config/services/store.dart';

class DioInterceptor extends Interceptor{
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler)async {
    // TODO: implement onRequest
    final tokens =await Store.GetTokens();
    if (tokens !=null && tokens .isNotEmpty){
      options.headers['Authorization'] = 'Bearer ${tokens[1]}';
    }
    options.headers['Content-Type'] = 'application/json';
    super.onRequest(options, handler);
  }
}