String cleanFrenchText(String input) {
  return input
      .replaceAll('Ã©', 'é')
      .replaceAll('Ã¨', 'è')
      .replaceAll('Ãª', 'ê')
      .replaceAll('Ã¹', 'ù')
      .replaceAll('Ã¢', 'â')
      .replaceAll('Ã®', 'î')
      .replaceAll('Ã´', 'ô')
      .replaceAll('Ã§', 'ç')
      .replaceAll('Ãª', 'ê');
}
