/// Maps product line-of-business codes to Lucide PNGs in `assets/images/static/`.
/// Adjust case values to match your API contract when wiring this helper.
class ProductLobToProductImageConverter {
  ProductLobToProductImageConverter._();

  static String imageForLob(int? productLob) {
    switch (productLob) {
      case 1:
        return 'assets/images/static/leaf.png';
      case 2:
        return 'assets/images/static/tractor.png';
      case 3:
        return 'assets/images/static/map-pin.png';
      case 4:
        return 'assets/images/static/land-plot.png';
      case 5:
        return 'assets/images/static/piggy-bank.png';
      default:
        return 'assets/images/static/help-circle.png';
    }
  }
}
