extension IntExtension on int {
  bool isDayBetween(int from, int to) {
    List<int> days = [1, 2, 3, 4, 5, 6, 7];
    // log('Days $days');
    List<int> sub = from > to ? days.sublist(days.indexOf(from)) : [];
    // log('Days $sub');
    days.removeWhere((element) => sub.contains(element));
    // log('Days $days');
    days.insertAll(0, sub);
    // log('Days $days');
    int start = days.indexOf(from);
    int end = days.indexOf(to);
    List<int> activeDays = days.sublist(start, end + 1);
    // log('Days $activeDays');

    return activeDays.contains(this);
  }
}
