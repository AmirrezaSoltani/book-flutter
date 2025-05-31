import 'package:flutter/material.dart';
import '../../../../shared/models/book.dart';
import '../../../../shared/utils/responsive.dart';
import '../widgets/book_card.dart';

class WishlistPage extends StatelessWidget {
  final List<Book> wishlist;
  final Function(Book) onRemoveFromWishlist;
  final Function(Book) onAddToCart;
  final Function(Book)? onPlayAudiobook;

  const WishlistPage({
    super.key,
    required this.wishlist,
    required this.onRemoveFromWishlist,
    required this.onAddToCart,
    this.onPlayAudiobook,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: const Text('Wishlist'),
            actions: [
              IconButton(
                icon: const Icon(Icons.sort),
                onPressed: () {
                  // TODO: Implement sorting options
                },
              ),
            ],
          ),
          if (wishlist.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Your wishlist is empty',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Add books to your wishlist to see them here',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.65,
                  mainAxisExtent: 300,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final book = wishlist[index];
                    return BookCard(
                      book: book,
                      isWishlisted: true,
                      onWishlistToggle: () => onRemoveFromWishlist(book),
                      onAddToCart: () => onAddToCart(book),
                      onPlayAudiobook: onPlayAudiobook != null
                          ? () => onPlayAudiobook!(book)
                          : null,
                    );
                  },
                  childCount: wishlist.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
} 