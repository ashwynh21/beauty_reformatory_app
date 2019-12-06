class _Exception implements Exception {

    final String message;

    const _Exception([this.message = '']);

    String toString() => message;
    String getMessage(){ return this.message;}
}
class ConnectionException extends _Exception {
    const ConnectionException(message): super('ConnectionException: $message');
}
class ValidationException extends _Exception {
    const ValidationException(message): super('ValidationException: $message');
}
class UnreachableException extends _Exception {
    const UnreachableException(message): super('UnreachableException: $message');
}
class AuthorizationException extends _Exception {
    const AuthorizationException(message): super('AuthorizationException: $message');
}
class ResponseException extends _Exception {
    const ResponseException(message): super('ResponseException: $message');
}
class ExternalException extends _Exception {
    const ExternalException(message): super('ExternalException: $message');
}
class UnknownException extends _Exception {
    const UnknownException(message): super('UnknownException: $message');
}