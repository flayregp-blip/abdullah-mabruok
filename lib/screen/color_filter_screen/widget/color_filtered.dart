const List<double> defaultFilter = [
  1, 0, 0, 0, 0, // Red
  0, 1, 0, 0, 0, // Green
  0, 0, 1, 0, 0, // Blue
  0, 0, 0, 1, 0 // Alpha
];

const List<Filters> filters = [
  Filters([
    1, 0, 0, 0, 0, // Red
    0, 1, 0, 0, 0, // Green
    0, 0, 1, 0, 0, // Blue
    0, 0, 0, 1, 0 // Alpha
  ], 'Normal'),
  Filters([1.0, 0.2, 0, 0, 0, 0.2, 1.0, 0.2, 0, 0, 0, 0.2, 1.0, 0, 0, 0, 0, 0, 1, 0], 'Vintage'),
  Filters([1.2, 0.1, 0, 0, 0, 0.1, 1.1, 0.1, 0, 0, 0, 0.1, 1.0, 0, 0, 0, 0, 0, 1, 0], 'Warm'),
  Filters([0.8, 0, 0, 0, 0, 0, 0.8, 0.1, 0, 0, 0.1, 0.1, 1.2, 0, 0, 0, 0, 0, 1, 0], 'Cool'),
  Filters([0.33, 0.33, 0.33, 0, 0, 0.33, 0.33, 0.33, 0, 0, 0.33, 0.33, 0.33, 0, 0, 0, 0, 0, 1, 0],
      'Grayscale'),
  // Low Saturation
  Filters([0.5, 0.25, 0.25, 0, 0, 0.25, 0.5, 0.25, 0, 0, 0.25, 0.25, 0.5, 0, 0, 0, 0, 0, 1, 0],
      'Low Saturation'),
  // Night Vision
  Filters(
      [0.1, 0.4, 0, 0, 0, 0.3, 1.0, 0.3, 0, 0, 0, 0.4, 0.1, 0, 0, 0, 0, 0, 1, 0], 'Night Vision'),
  // Vintage Purple
  Filters([0.6, 0.2, 0.8, 0, 0, 0.3, 0.3, 0.5, 0, 0, 0.3, 0.1, 0.6, 0, 0, 0, 0, 0, 1, 0],
      'Vintage Purple'),
  // Cool Tone
  Filters([0.9, 0.1, 0, 0, 0, 0.1, 0.9, 0.1, 0, 0, 0, 0.1, 1.1, 0, 0, 0, 0, 0, 1, 0], 'Cool Tone'),
  // Warm Tone
  Filters(
      [1.2, 0.2, 0.1, 0, 0, 0.2, 1.1, 0.1, 0, 0, 0.1, 0.1, 0.9, 0, 0, 0, 0, 0, 1, 0], 'Warm Tone'),
  // Shadow Boost
  Filters([1.0, 0, 0, 0, -50, 0, 1.0, 0, 0, -50, 0, 0, 1.0, 0, -50, 0, 0, 0, 1, 0], 'Shadow Boost'),
  // Faded
  Filters([1.0, 0.2, 0.2, 0, -30, 0.2, 1.0, 0.2, 0, -30, 0.2, 0.2, 1.0, 0, -30, 0, 0, 0, 1, 0],
      'Faded'),
  // Green Boost
  Filters(
      [1.0, 0.1, 0, 0, 0, 0.1, 1.5, 0.1, 0, 0, 0, 0.1, 1.0, 0, 0, 0, 0, 0, 1, 0], 'Green Boost'),
];

class Filters {
  final List<double> colorFilter;
  final String filterName;

  const Filters(this.colorFilter, this.filterName);
}
