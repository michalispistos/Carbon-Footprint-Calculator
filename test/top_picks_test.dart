import 'package:flutter_test/flutter_test.dart';
import 'package:carbon_footprint_calculator/utils/top_picks.dart';

String mockTopPicksResponse = '[{"id":"test-id","name":"Test-Name",'
    '"slug":"test-name","image":"test-image-url","ethicalLabel":"test-ethical-label",'
    '"ethicalRating":0,"price":0}]';

void main() {
  test('JSON is parsed correctly to a valid Top Picks object', () {
    List<TopPicks> topPicks = parseTopPicks(mockTopPicksResponse);
    TopPicks topPick = topPicks[0];
    expect(topPick.id, "test-id");
    expect(topPick.name, "Test-Name");
    expect(topPick.slug, "test-name");
    expect(topPick.imageUrl, "test-image-url");
    expect(topPick.ethicalLabel, "test-ethical-label");
    expect(topPick.ethicalRating, 0);
    expect(topPick.price, 0);
  });
}