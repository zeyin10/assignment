/// Centralized Hero tag helpers for shared-element transitions.
abstract final class HeroTags {
  static String cinemaImage(String cinemaId) => 'cinema-image-$cinemaId';

  static String ticketImage(String cinemaId, String ticketName) =>
      'ticket-$cinemaId-${ticketName.hashCode}';
}
