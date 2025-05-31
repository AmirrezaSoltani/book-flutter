import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../shared/models/book.dart';
import '../../../../features/reading/presentation/pages/book_reader_page.dart';
import '../../../../shared/utils/responsive.dart';

class BooksPage extends StatefulWidget {
  final void Function(Book book)? onPlayAudiobook;
  const BooksPage({super.key, this.onPlayAudiobook});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> with SingleTickerProviderStateMixin {
  String _selectedCategory = 'All';
  final List<Book> _wishlist = [];
  final List<Book> _cartItems = [];
  bool _showCart = false;
  bool _showWishlist = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final List<String> _categories = [
    'All',
    'Fiction',
    'Non-Fiction',
    'Children',
    'Biography',
    'Science',
    'Fantasy',
    'Mystery',
    'Romance',
    'Self-Help',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleWishlist(Book book) {
    setState(() {
      if (_wishlist.contains(book)) {
        _wishlist.remove(book);
      } else if (!_wishlist.any((b) => b.id == book.id)) {
        _wishlist.add(book);
        _animationController.forward().then((_) {
          _animationController.reverse();
        });
      }
    });
  }

  void _addToCart(Book book) {
    setState(() {
      _cartItems.add(book);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${book.title} added to cart'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () {
            setState(() {
              _showCart = true;
            });
          },
        ),
      ),
    );
  }

  void _removeFromCart(Book book) {
    setState(() {
      _cartItems.remove(book);
    });
  }

  double get _cartTotal {
    return _cartItems.fold(0, (sum, book) => sum + book.price);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          // Swipe from left to right - Open Wishlist
          setState(() {
            _showWishlist = true;
            _showCart = false;
          });
        } else if (details.primaryVelocity! < 0) {
          // Swipe from right to left - Open Cart
          setState(() {
            _showCart = true;
            _showWishlist = false;
          });
        }
      },
      child: Stack(
        children: [
          Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  title: const Text('Book Store'),
                  actions: [
                    IconButton(
                      icon: Badge(
                        label: Text(_wishlist.length.toString()),
                        child: const Icon(Icons.favorite),
                      ),
                      onPressed: () {
                        setState(() {
                          _showWishlist = !_showWishlist;
                          if (_showWishlist) {
                            _showCart = false;
                          }
                        });
                      },
                    ),
                    IconButton(
                      icon: Badge(
                        label: Text(_cartItems.length.toString()),
                        child: const Icon(Icons.shopping_cart),
                      ),
                      onPressed: () {
                        setState(() {
                          _showCart = !_showCart;
                        });
                      },
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final isSelected = category == _selectedCategory;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(category),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
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
                      (context, index) => _buildBookCard(_getSampleBooks()[index]),
                      childCount: _getSampleBooks().length,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_showCart)
            Positioned(
              right: 0,
              top: 10,
              bottom: 0,
              width: MediaQuery.of(context).size.width * 0.85,
              child: Card(
                margin: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Shopping Cart',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                _showCart = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _cartItems.isEmpty
                          ? const Center(
                              child: Text('Your cart is empty'),
                            )
                          : ListView.builder(
                              itemCount: _cartItems.length,
                              itemBuilder: (context, index) {
                                final book = _cartItems[index];
                                return Dismissible(
                                  key: Key(book.id),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    color: Colors.red,
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 16),
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onDismissed: (direction) {
                                    _removeFromCart(book);
                                  },
                                  child: ListTile(
                                    leading: Image.asset(
                                      book.coverAsset ?? 'assets/images/profile_placeholder.png',
                                      width: 50,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    ),
                                    title: Text(book.title),
                                    subtitle: Text(book.author),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '\$${book.price.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline),
                                          onPressed: () => _removeFromCart(book),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    if (_cartItems.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '\$${_cartTotal.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  // TODO: Implement checkout
                                },
                                child: const Text('Checkout'),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          if (_showWishlist)
            Positioned(
              right: 0,
              top: 10,
              bottom: 0,
              width: MediaQuery.of(context).size.width * 0.85,
              child: Card(
                margin: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Wishlist',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                _showWishlist = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _wishlist.isEmpty
                          ? const Center(
                              child: Text('Your wishlist is empty'),
                            )
                          : ListView.builder(
                              itemCount: _wishlist.length,
                              itemBuilder: (context, index) {
                                final book = _wishlist[index];
                                return Dismissible(
                                  key: Key(book.id),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    color: Colors.red,
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 16),
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onDismissed: (direction) {
                                    _toggleWishlist(book);
                                  },
                                  child: ListTile(
                                    leading: Image.asset(
                                      book.coverAsset ?? 'assets/images/profile_placeholder.png',
                                      width: 50,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    ),
                                    title: Text(book.title),
                                    subtitle: Text(book.author),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '\$${book.price.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        IconButton(
                                          icon: const Icon(Icons.shopping_cart),
                                          onPressed: () {
                                            _addToCart(book);
                                            _toggleWishlist(book);
                                          },
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
              ),
            ),
        ],
      ),
    );
  }

  List<Book> _getSampleBooks() {
    return [
      Book(
        id: '1',
        title: 'The Great Gatsby',
        author: 'F. Scott Fitzgerald',
        description: 'A story of the fabulously wealthy Jay Gatsby and his love for the beautiful Daisy Buchanan.',
        coverUrl: 'https://example.com/gatsby.jpg',
        price: 9.99,
        rating: 4.5,
        categories: ['Fiction', 'Classic'],
        coverAsset: 'assets/images/profile_placeholder.png',
        audioAsset: 'audio/sample_story.mp3',
      ),
      Book(
        id: '2',
        title: 'To Kill a Mockingbird',
        author: 'Harper Lee',
        description: 'The story of racial injustice and the loss of innocence in the American South.',
        coverUrl: 'https://example.com/mockingbird.jpg',
        price: 12.99,
        rating: 4.8,
        categories: ['Fiction', 'Classic'],
        coverAsset: 'assets/images/profile_placeholder.png',
        audioAsset: 'audio/sample_story.mp3',
      ),
      Book(
        id: '3',
        title: 'The Magic Garden',
        author: 'Kids Collection',
        description: 'A magical adventure in a garden full of talking flowers.',
        coverUrl: 'https://example.com/magic_garden.jpg',
        price: 14.99,
        rating: 4.9,
        categories: ['Children', 'Fiction'],
        coverAsset: 'assets/images/magic_garden.png',
        audioAsset: 'audio/sample_story.mp3',
      ),
      Book(
        id: '4',
        title: 'Space Adventure',
        author: 'Captain Star',
        description: 'Join Captain Star on an exciting journey through space.',
        coverUrl: 'https://example.com/space.jpg',
        price: 11.99,
        rating: 4.7,
        categories: ['Children', 'Science'],
        coverAsset: 'assets/images/space_adventure.png',
        audioAsset: 'audio/sample_story.mp3',
      ),
    ];
  }

  Widget _buildBookCard(Book book) {
    final isWishlisted = _wishlist.any((b) => b.id == book.id);
    
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
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: IconButton(
                            icon: Icon(
                              isWishlisted ? Icons.favorite : Icons.favorite_border,
                              color: isWishlisted ? Colors.red : Colors.white,
                              size: 28,
                            ),
                            onPressed: () => _toggleWishlist(book),
                          ),
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
                          fontSize: responsiveFont(context, 13),
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
                              onPressed: widget.onPlayAudiobook != null
                                  ? () => widget.onPlayAudiobook!(book)
                                  : null,
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
                              onPressed: () => _addToCart(book),
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