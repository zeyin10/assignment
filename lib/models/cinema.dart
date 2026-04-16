class MovieTicket {
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  MovieTicket({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
}

class Cinema {
  String id;
  String name;
  String address;
  String attributes;
  String imageUrl;
  String imageCredits;
  double distance;
  double rating;
  List<MovieTicket> items;

  Cinema(
    this.id,
    this.name,
    this.address,
    this.attributes,
    this.imageUrl,
    this.imageCredits,
    this.distance,
    this.rating,
    this.items);

  String getRatingAndDistance() {
    return '''Rating: ${rating.toStringAsFixed(1)} ★ | Distance: ${distance.toStringAsFixed(1)} miles''';
  }
}

List<Cinema> cinemas = [
  Cinema(
    '0',
    'Grand Lumière Cinema',
    '123 Film Blvd, Los Angeles, CA 90028',
    'IMAX, Dolby Atmos, 4DX',
    'assets/cinemas/grand_lumiere.webp',
    'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba',
    1.8,
    4.7,
    [
      MovieTicket(
        name: 'Interstellar (IMAX)',
        description:
            '''Experience Christopher Nolan\'s epic space odyssey in breathtaking IMAX. A team of explorers travel through a wormhole in space in an attempt to ensure humanity\'s survival.''',
        price: 22.99,
        imageUrl: 'https://images.unsplash.com/photo-1446776811953-b23d57bd21aa?w=800',
      ),
      MovieTicket(
        name: 'Dune: Part Two (Dolby)',
        description:
            '''Paul Atreides unites with Chani and the Fremen while seeking revenge against the conspirators who destroyed his family. Witness the epic saga in stunning Dolby Vision and Atmos.''',
        price: 19.99,
        imageUrl: 'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=800',
      ),
      MovieTicket(
        name: 'The Batman (Standard)',
        description:
            '''In his second year of fighting crime, Batman uncovers corruption in Gotham City that connects to his own family. A gripping neo-noir detective thriller.''',
        price: 14.99,
        imageUrl: 'https://images.unsplash.com/photo-1509347528160-9a9e33742cdb?w=800',
      ),
      MovieTicket(
        name: 'Oppenheimer (4DX)',
        description:
            '''The story of J. Robert Oppenheimer\'s role in the development of the atomic bomb during World War II. Feel every moment with immersive 4DX motion seats.''',
        price: 24.99,
        imageUrl: 'https://images.unsplash.com/photo-1518770660439-4636190af475?w=800',
      ),
    ],
  ),
  Cinema(
    '1',
    'Starlight Multiplex',
    '450 Hollywood Way, Burbank, CA 91505',
    'Premium, VIP Lounge, Bar',
    'assets/cinemas/starlight.jpg',
    'https://images.unsplash.com/photo-1517604931442-7e0c8ed2963c',
    3.2,
    4.5,
    [
      MovieTicket(
        name: 'Poor Things (VIP)',
        description:
            '''Bella Baxter is brought back to life by the brilliant and unorthodox scientist Dr. Godwin Baxter. A fantastical tale of discovery and liberation. Full VIP recliner experience.''',
        price: 29.99,
        imageUrl: 'https://images.unsplash.com/photo-1485846234645-a62644f84728?w=800',
      ),
      MovieTicket(
        name: 'Killers of the Flower Moon',
        description:
            '''Members of the Osage Nation are murdered under mysterious circumstances in the 1920s, sparking a major FBI investigation. Martin Scorsese\'s historical masterpiece.''',
        price: 17.99,
        imageUrl: 'https://images.unsplash.com/photo-1500099817043-86d46000d58f?w=800',
      ),
      MovieTicket(
        name: 'Past Lives (Standard)',
        description:
            '''Two childhood friends are separated after one of their families immigrates from South Korea. Decades later, they are reunited for one fateful week. A deeply moving love story.''',
        price: 13.99,
        imageUrl: 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=800',
      ),
    ],
  ),
  Cinema(
    '2',
    'The Reel House',
    '78 Indie Lane, Silver Lake, CA 90026',
    'Indie, Art House, Classics',
    'assets/cinemas/theRealHouse.jfif',
    'https://images.unsplash.com/photo-1616530940355-351fabd9524b',
    0.9,
    4.8,
    [
      MovieTicket(
        name: 'Anatomy of a Fall',
        description:
            '''A woman is suspected of her husband\'s death after his body is discovered near their chalet in the French Alps. Winner of the Palme d\'Or at Cannes 2023.''',
        price: 12.99,
        imageUrl: 'https://images.unsplash.com/photo-1560109947-543149eceb16?w=800',
      ),
      MovieTicket(
        name: 'Monster (Kore-eda)',
        description:
            '''After a single mother suspects her son\'s teacher of harassment, the story unfolds from multiple perspectives. A masterful exploration of truth directed by Hirokazu Kore-eda.''',
        price: 12.99,
        imageUrl: 'https://images.unsplash.com/photo-1478720568477-152d9b164e26?w=800',
      ),
      MovieTicket(
        name: 'The Zone of Interest',
        description:
            '''The commandant of Auschwitz and his wife strive to build a dream life for their family in a house next to the camp. Jonathan Glazer\'s haunting Holocaust drama.''',
        price: 12.99,
        imageUrl: 'https://images.unsplash.com/photo-1440404653325-ab127d49abc1?w=800',
      ),
    ],
  ),
  Cinema(
    '3',
    'Nova Cineplex',
    '2201 Century Park East, Century City, CA 90067',
    'Blockbusters, Luxury, RPX',
    'assets/cinemas/noveCinema.png',
    'https://images.unsplash.com/photo-1512070679279-8988d32161be',
    4.5,
    4.3,
    [
      MovieTicket(
        name: 'Avengers: Secret Wars (RPX)',
        description:
            '''Earth\'s mightiest heroes face their greatest challenge yet in this epic crossover event. Experience the action in immersive RPX premium large format.''',
        price: 21.99,
        imageUrl: 'https://images.unsplash.com/photo-1531259683007-016a7b628fc3?w=800',
      ),
      MovieTicket(
        name: 'Furiosa: Mad Max Saga',
        description:
            '''The origin story of the powerful warrior Furiosa before she teamed up with Mad Max. George Miller returns with another adrenaline-fueled masterpiece.''',
        price: 16.99,
        imageUrl: 'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=800',
      ),
      MovieTicket(
        name: 'Inside Out 2 (Family)',
        description:
            '''Riley enters adolescence and a new emotion — Anxiety — leads a takeover of Headquarters while Joy and the other emotions scramble to figure out how to work together. Family package available.''',
        price: 14.99,
        imageUrl: 'https://images.unsplash.com/photo-1560169897-fc0cdbdfa4d5?w=800',
      ),
    ],
  ),
];
