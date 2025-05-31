import 'package:flutter/material.dart';
import '../../../../shared/models/book.dart';
import '../../../../shared/utils/responsive.dart';
import '../../../../features/reading/presentation/pages/book_reader_page.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final bool isWishlisted;
  final VoidCallback onWishlistToggle;
  final VoidCallback onAddToCart;
  final VoidCallback? onPlayAudiobook;

  const BookCard({
    super.key,
    required this.book,
    required this.isWishlisted,
    required this.onWishlistToggle,
    required this.onAddToCart,
    this.onPlayAudiobook,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookReaderPage(book: book),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.book,
                            size: constraints.maxWidth * 0.4,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: Icon(
                            isWishlisted ? Icons.favorite : Icons.favorite_border,
                            color: isWishlisted ? Colors.red : Colors.grey,
                          ),
                          onPressed: onWishlistToggle,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        style: TextStyle(
                          fontSize: responsiveFont(context, 16),
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        book.author,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: responsiveFont(context, 13),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: responsiveFont(context, 15),
                                color: Colors.amber[700],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                book.rating.toString(),
                                style: TextStyle(
                                  fontSize: responsiveFont(context, 13),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '\$${book.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: responsiveFont(context, 15),
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.headphones),
                              label: Text(
                                'Play',
                                style: TextStyle(fontSize: responsiveFont(context, 13)),
                              ),
                              onPressed: onPlayAudiobook,
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size.zero,
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.shopping_cart),
                              label: Text(
                                'Add',
                                style: TextStyle(fontSize: responsiveFont(context, 13)),
                              ),
                              onPressed: onAddToCart,
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size.zero,
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
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
    );
  }
} 