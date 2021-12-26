extension StringExtension on String {
  String toFirstCapital() {
    if (this == "") return "";
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
