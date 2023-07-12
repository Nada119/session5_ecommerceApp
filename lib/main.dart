import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class Product {
  final String name;
  final String imageURL;
  final double price;
  int quantity;

  Product({
    required this.name,
    required this.imageURL,
    required this.price,
    this.quantity = 0,
  });
}

class ProductCard extends StatefulWidget {
  final Product product;
  final Function(Product) addToCart;
  final Function(Product) removeFromCart;

  ProductCard({
    required this.product,
    required this.addToCart,
    required this.removeFromCart,
  });

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isAddedToCart = false;

  @override
  void initState() {
    super.initState();
    isAddedToCart = widget.product.quantity > 0;
  }

  void toggleCartStatus() {
    if (isAddedToCart) {
      widget.removeFromCart(widget.product);
    } else {
      widget.addToCart(widget.product);
    }

    setState(() {
      isAddedToCart = !isAddedToCart;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductInfoPage(product: widget.product),
            ),
          );
        },
        child: Column(
          children: [
            SizedBox(
              height: 450,
              width: double.infinity,
              child: Image.network(
                widget.product.imageURL,
                fit: BoxFit.cover,
              ),
            ),
            ListTile(
              title: Text(widget.product.name),
              subtitle: Text('\$${widget.product.price.toStringAsFixed(2)}'),
              trailing: IconButton(
                icon: Icon(
                  isAddedToCart ? Icons.shopping_cart : Icons.add_shopping_cart,
                  color: isAddedToCart ? Colors.black : null,
                ),
                onPressed: toggleCartStatus,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductInfoPage extends StatefulWidget {
  final Product product;

  ProductInfoPage({required this.product});

  @override
  _ProductInfoPageState createState() => _ProductInfoPageState();
}

class _ProductInfoPageState extends State<ProductInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 450,
              width: double.infinity,
              child: Image.network(
                widget.product.imageURL,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              'Product Info:',
              style: TextStyle(fontSize: 20),
            ),
            Text('Name: ${widget.product.name}'),
            Text('Price: \$${widget.product.price.toStringAsFixed(2)}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (widget.product.quantity > 0) {
                        widget.product.quantity--;
                      }
                    });
                  },
                ),
                Text(
                  widget.product.quantity.toString(),
                  style: TextStyle(fontSize: 18),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      widget.product.quantity++;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  final List<Product> cartItems;

  CartPage({required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.network(cartItems[index].imageURL),
            title: Text(cartItems[index].name),
            subtitle: Text('\$${cartItems[index].price.toStringAsFixed(2)}'),
            trailing: Text('Quantity: ${cartItems[index].quantity}'),
          );
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Product> products = [
    Product(
      name: 'Birman',
      imageURL:
          'https://images.pexels.com/photos/2061057/pexels-photo-2061057.jpeg?cs=srgb&dl=pexels-tranmautritam-2061057.jpg&fm=jpg',
      price: 3000,
    ),
    Product(
      name: 'Abyssinian',
      imageURL:
          'https://d1hjkbq40fs2x4.cloudfront.net/2016-07-16/files/cat-sample_1313.jpg',
      price: 2500,
    ),
    Product(
      name: 'Maine Coon',
      imageURL:
          'https://images.unsplash.com/photo-1611267254323-4db7b39c732c?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8Y3V0ZSUyMGNhdHxlbnwwfHwwfHw%3D&w=1000&q=80',
      price: 5000,
    ),
  ];

  List<Product> cartItems = [];

  void addToCart(Product product) {
    setState(() {
      if (!cartItems.contains(product)) {
        cartItems.add(product);
      }
      product.quantity++;
    });
  }

  void removeFromCart(Product product) {
    setState(() {
      product.quantity--;
      if (product.quantity == 0) {
        cartItems.remove(product);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(cartItems: cartItems),
                ),
              );
            },
          ),
        ],
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductCard(
                  product: products[index],
                  addToCart: addToCart,
                  removeFromCart: removeFromCart,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
