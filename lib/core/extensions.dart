extension StringExtensions on String {
  String capitalizeFirstLetter() {
    if (isEmpty) return this; // Si la cadena está vacía, retornarla sin cambios
    return this[0].toUpperCase() + substring(1);
  }
}
