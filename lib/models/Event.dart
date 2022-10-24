class Event {
  final DateTime start;
  final String player;
  final int numberOfPlayers;
  final String playingType;
  final int duration;
  final String place;
  final String info;

  const Event(
      {required this.start,
      required this.player,
      required this.numberOfPlayers,
      required this.playingType,
      required this.duration,
      required this.place,
      required this.info});
}
