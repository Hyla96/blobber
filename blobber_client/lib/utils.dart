class Utils {
  static String stringToColour(String str) => str.hashCode.toUnsigned(0x1000000).toRadixString(16).padLeft(6, '0');
}
