String normalizeArabic(String text) {
  var value = text.toLowerCase().trim();

  // إزالة التشكيل.
  value = value.replaceAll(
    RegExp(r'[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06ED]'),
    '',
  );

  // ا = أ = إ = آ
  value = value.replaceAll('أ', 'ا').replaceAll('إ', 'ا').replaceAll('آ', 'ا');

  // ى = ي
  value = value.replaceAll('ى', 'ي');

  // ة = ه
  value = value.replaceAll('ة', 'ه');

  // توحيد الهمزات.
  value = value.replaceAll('ؤ', 'و').replaceAll('ئ', 'ي');

  // إزالة التطويل.
  value = value.replaceAll('ـ', '');

  // توحيد المسافات.
  value = value.replaceAll(RegExp(r'\s+'), ' ');

  return value;
}
