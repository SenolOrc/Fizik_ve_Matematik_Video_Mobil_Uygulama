class QuizValidators {
  String? cannotNull(String? value) {
    if (value == null || value.isEmpty) {
      return 'Bu alanı lütfen doldurun.';
    }
    return null;
  }
}
