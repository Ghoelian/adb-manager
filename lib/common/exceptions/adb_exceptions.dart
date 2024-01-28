class DeviceBusyException implements Exception {
  String cause;

  DeviceBusyException(this.cause);
}
