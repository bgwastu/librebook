enum BookCategory {
  General,
  Fiction,
}

BookCategory bookCategoryFromString(String bookCategory) {
  bookCategory = 'BookCategory.$bookCategory';
  return BookCategory.values
      .firstWhere((c) => c.toString() == bookCategory, orElse: () => null);
}
