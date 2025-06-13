class LocationUtils {
  static double normalizeLatitude(double lat) {
    double wrapped = lat % 360;
    if (wrapped > 180) wrapped -= 360;
    if (wrapped < -180) wrapped += 360;
    if (wrapped > 90) return 180 - wrapped;
    if (wrapped < -90) return -180 - wrapped;
    return wrapped;
  }

  static double normalizeLongitude(double long) {
    double wrapped = long % 360;
    if (wrapped > 180) wrapped -= 360;
    if (wrapped < -180) wrapped += 360;
    return wrapped;
  }
}