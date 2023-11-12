// ignore_for_file: file_names

titleCase(String text) {
  if (text.length <= 3) {
    return text.toUpperCase();
  }
  return text
      .split(' ')
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join(' ');
}
