import 'package:flutter/material.dart';
import '../../../../shared/models/book.dart';

class MyLibraryPage extends StatelessWidget {
  const MyLibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample books data - In a real app, this would come from a database or API
    final List<Book> myBooks = [
      Book(
        id: '1',
        title: 'The Great Gatsby',
        author: 'F. Scott Fitzgerald',
        coverAsset: 'assets/images/books/great_gatsby.jpg',
        description: 'A story of the fabulously wealthy Jay Gatsby and his love for the beautiful Daisy Buchanan.',
        price: 9.99,
        rating: 4.5,
        categories: ['Fiction', 'Classic'],
        coverUrl: 'https://example.com/great_gatsby.jpg',
      ),
      Book(
        id: '2',
        title: 'To Kill a Mockingbird',
        author: 'Harper Lee',
        coverAsset: 'assets/images/books/mockingbird.jpg',
        description: 'The story of racial injustice and the loss of innocence in the American South.',
        price: 12.99,
        rating: 4.8,
        categories: ['Fiction', 'Classic'],
        coverUrl: 'https://example.com/mockingbird.jpg',
      ),
      Book(
        id: '3',
        title: '1984',
        author: 'George Orwell',
        coverAsset: 'assets/images/books/1984.jpg',
        description: 'A dystopian social science fiction novel and cautionary tale.',
        price: 10.99,
        rating: 4.6,
        categories: ['Science Fiction', 'Dystopian'],
        coverUrl: 'https://example.com/1984.jpg',
      ),
      Book(
        id: '4',
        title: 'Pride and Prejudice',
        author: 'Jane Austen',
        coverAsset: 'assets/images/books/pride_prejudice.jpg',
        description: 'A romantic novel of manners.',
        price: 8.99,
        rating: 4.7,
        categories: ['Romance', 'Classic'],
        coverUrl: 'https://example.com/pride_prejudice.jpg',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Library'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              // TODO: Implement sorting functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Reading Progress Section
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Row(
              children: [
                const Icon(Icons.trending_up, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reading Progress',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'You\'ve read 12 books this month',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to reading stats
                  },
                  child: const Text('View Stats'),
                ),
              ],
            ),
          ),
          
          // Books Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: myBooks.length,
              itemBuilder: (context, index) {
                final book = myBooks[index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      // TODO: Navigate to book details
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Book Cover
                              Image.asset(
                                book.coverAsset ?? 'assets/images/profile_placeholder.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: Icon(Icons.book, size: 50, color: Colors.grey),
                                    ),
                                  );
                                },
                              ),
                              // Reading Progress Overlay
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  color: Colors.black54,
                                  child: LinearProgressIndicator(
                                    value: 0.7, // TODO: Get actual progress
                                    backgroundColor: Colors.grey[800],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                book.title,
                                style: Theme.of(context).textTheme.titleMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                book.author,
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 16,
                                    color: Colors.amber[700],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    book.rating.toString(),
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 