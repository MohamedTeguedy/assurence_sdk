/// Nettoie les caractères mal encodés en français
String cleanFrenchText(String input) {
  return input
      // Lettres minuscules
      .replaceAll('Ã©', 'é')
      .replaceAll('Ã¨', 'è')
      .replaceAll('Ãª', 'ê')
      .replaceAll('Ã«', 'ë')
      .replaceAll('Ã¹', 'ù')
      .replaceAll('Ã»', 'û')
      .replaceAll('Ã¢', 'â')
      .replaceAll('Ã¤', 'ä')
      .replaceAll('Ã®', 'î')
      .replaceAll('Ã¯', 'ï')
      .replaceAll('Ã´', 'ô')
      .replaceAll('Ã¶', 'ö')
      .replaceAll('Ã§', 'ç')

      // Lettres majuscules
      .replaceAll('Ã‰', 'É')
      .replaceAll('Ãˆ', 'È')
      .replaceAll('ÃŠ', 'Ê')
      .replaceAll('Ã‹', 'Ë')
      .replaceAll('Ã™', 'Ù')
      .replaceAll('Ã›', 'Û')
      .replaceAll('Ã‚', 'Â')
      .replaceAll('Ã„', 'Ä')
      .replaceAll('ÃŽ', 'Î')
      .replaceAll('ÃŒ', 'Ì')
      .replaceAll('Ã’', 'Ô')
      .replaceAll('Ã–', 'Ö')
      .replaceAll('Ã‡', 'Ç')

      // Caractères spéciaux
      .replaceAll('Â°', '°') // Degré
      .replaceAll('Ã€', 'À') // À majuscule
      .replaceAll('Ãœ', 'Ü') // Ü majuscule
      .replaceAll('Å’', 'Œ') // Œ ligature
      .replaceAll('Å“', 'œ') // œ ligature
      .replaceAll('â€“', '–') // Tiret moyen
      .replaceAll('â€”', '—') // Tiret long
      .replaceAll('â€™', "'") // Apostrophe courbe
      .replaceAll('â€œ', '"') // Guillemet gauche
      .replaceAll('â€', '"') // Guillemet droit
      .replaceAll('â€¢', '•') // Puce
      .replaceAll('â€¦', '…'); // Points de suspension
}

/// Extension pour utilisation facile sur n'importe quelle String
extension FrenchTextCleaner on String {
  String cleanFrench() => cleanFrenchText(this);
}
