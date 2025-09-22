import 'dart:io';
import 'package:dio/dio.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        err = DeadlineExceededException(err.requestOptions);
        break;
      case DioExceptionType.badResponse:
        switch (err.response?.statusCode) {
          case 400:
            err = BadRequestException(err.requestOptions, err.response);
            break;
          case 401:
            err = UnauthorizedException(err.requestOptions, err.response);
            break;
          case 403:
            err = ForbiddenException(err.requestOptions, err.response);
            break;
          case 404:
            err = NotFoundException(err.requestOptions, err.response);
            break;
          case 409:
            err = ConflictException(err.requestOptions, err.response);
            break;
          case 500:
            err = InternalServerErrorException(err.requestOptions, err.response);
            break;
        }
        break;
      case DioExceptionType.cancel:
        break;
      case DioExceptionType.unknown:
        err = NoInternetConnectionException(err.requestOptions, err.error);
        break;
      case DioExceptionType.badCertificate:
        err = BadCertificateException(err.requestOptions);
        break;
      case DioExceptionType.connectionError:
        err = NoInternetConnectionException(err.requestOptions, err.error);
        break;
    }
    return handler.next(err);
  }
}

class BadRequestException extends DioException {
  BadRequestException(RequestOptions r, Response? response)
      : super(requestOptions: r, response: response);

  @override
  String toString() {
    return 'Invalid request';
  }
}

class InternalServerErrorException extends DioException {
  InternalServerErrorException(RequestOptions r, Response? response)
      : super(requestOptions: r, response: response);

  @override
  String toString() {
    return 'Server error, please try again later';
  }
}

class ConflictException extends DioException {
  ConflictException(RequestOptions r, Response? response)
      : super(request<boltAction type="file" filePath="lib/core/network/interceptors/error_interceptor.dart">
  ConflictException(RequestOptions r, Response? response)
      : super(requestOptions: r, response: response);

  @override
  String toString() {
    return 'Conflict occurred';
  }
}

class UnauthorizedException extends DioException {
  UnauthorizedException(RequestOptions r, Response? response)
      : super(requestOptions: r, response: response);

  @override
  String toString() {
    return 'Access denied';
  }
}

class NotFoundException extends DioException {
  NotFoundException(RequestOptions r, Response? response)
      : super(requestOptions: r, response: response);

  @override
  String toString() {
    return 'The requested resource does not exist';
  }
}

class ForbiddenException extends DioException {
  ForbiddenException(RequestOptions r, Response? response)
      : super(requestOptions: r, response: response);

  @override
  String toString() {
    return 'Access to this resource is forbidden';
  }
}

class DeadlineExceededException extends DioException {
  DeadlineExceededException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'The connection has timed out, please try again';
  }
}

class BadCertificateException extends DioException {
  BadCertificateException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Bad certificate';
  }
}

class NoInternetConnectionException extends DioException {
  NoInternetConnectionException(RequestOptions r, dynamic error) 
      : super(requestOptions: r, error: error);

  @override
  String toString() {
    return 'No internet connection';
  }
}
