import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;
import 'dart:js' as js;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser Stripe seulement si ce n'est pas le web
  if (!kIsWeb) {
    Stripe.publishableKey = 'pk_live_51QXlYxEZxCby7GrItNxRVJ5Tn0kIE8lM1TNbGlIvW5ErLFNIKHYRf2tVaRGLyGNNgjn20GQ22HwJXKA56XC0b20j00rcKIzBUV';
  }
  
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 126, 125, 125),
        title: const Text(
          'NMAL',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'BUY EVERYTHING, GET NOTHING',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 3,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('asset/mountain.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black26,
              BlendMode.darken,
            ),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                padding: const EdgeInsets.all(16),
                child: const Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '"In a world obsessed with more,\nfind freedom in nothing."',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                          height: 1.5,
                          letterSpacing: 2.0,
                          fontStyle: FontStyle.italic,
                          shadows: [
                            Shadow(
                              color: Colors.black45,
                              offset: Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        '— Sarah Chen',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                          letterSpacing: 1.5,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      Text(
                        'Minimalist Philosopher',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w300,
                          color: Colors.white60,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = constraints.maxWidth > 800 ? 3 : 1;
                  double padding = constraints.maxWidth > 800 ? 64.0 : 16.0;
                  
                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(padding, 32, padding, 32),
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.85,
                    children: const [
                      NothingCard(
                        price: '4.99',
                        description: 'Entry-level nothingness.\nPerfect for beginners!',
                        index: 1,
                        icon: Icons.remove_circle_outline,
                        title: 'Basic Nothing',
                      ),
                      NothingCard(
                        price: '9.41',
                        description: 'Premium nothing with\nextra emptiness included',
                        index: 2,
                        icon: Icons.radio_button_unchecked,
                        title: 'Premium Nothing',
                      ),
                      NothingCard(
                        price: '15.76',
                        description: 'Deluxe nothing.\nNow with invisible gift wrap!',
                        index: 3,
                        icon: Icons.blur_circular,
                        title: 'Deluxe Nothing',
                      ),
                      NothingCard(
                        price: '47.35',
                        description: 'Artisanal nothing,\nhandcrafted by void experts',
                        index: 4,
                        icon: Icons.grain,
                        title: 'Artisanal Nothing',
                      ),
                      NothingCard(
                        price: '72.46',
                        description: 'Limited edition nothing.\nRarer than rare!',
                        index: 5,
                        icon: Icons.stars,
                        title: 'Limited Nothing',
                      ),
                      NothingCard(
                        price: '134.11',
                        description: 'Luxury nothing.\nStatus symbol of emptiness',
                        index: 6,
                        icon: Icons.diamond_outlined,
                        title: 'Luxury Nothing',
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NothingCard extends StatefulWidget {
  final String price;
  final String description;
  final int index;
  final IconData icon;
  final String title;
  
  const NothingCard({
    super.key, 
    required this.price, 
    required this.description,
    required this.index,
    required this.icon,
    required this.title,
  });

  @override
  State<NothingCard> createState() => _NothingCardState();
}

class _NothingCardState extends State<NothingCard> {
  bool isHovered = false;

  LinearGradient _getGradient() {
    switch (widget.index) {
      case 1:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey[700]!, Colors.grey[600]!],
        );
      case 2:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey[800]!, Colors.grey[700]!],
        );
      case 3:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey[850]!, Colors.grey[800]!],
        );
      case 4:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey[900]!, Colors.grey[850]!],
        );
      case 5:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF212121),
            const Color(0xFF424242),
          ],
        );
      case 6:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1a1a1a),
            const Color(0xFF303030),
          ],
        );
      default:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey[600]!, Colors.grey[500]!],
        );
    }
  }

  Future<void> _handlePayment(String paymentMethod) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final response = await http.post(
        Uri.parse('https://nothing-site-nu.vercel.app/api/create-payment-intent'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'amount': (double.parse(widget.price) * 100).round(),
          'currency': 'usd',
          'payment_method': paymentMethod,
        }),
      );

      if (context.mounted) {
        Navigator.pop(context);
      }

      if (response.statusCode == 200) {
        final paymentIntentData = jsonDecode(response.body);
        
        if (kIsWeb) {
          if (paymentIntentData['id'] != null) {
            final String sessionId = paymentIntentData['id'];
            final stripe = html.window.document.createElement('script');
            final stripeInstance = js.context.callMethod('Stripe', ['pk_live_51QXlYxEZxCby7GrItNxRVJ5Tn0kIE8lM1TNbGlIvW5ErLFNIKHYRf2tVaRGLyGNNgjn20GQ22HwJXKA56XC0b20j00rcKIzBUV']);
            stripeInstance.callMethod('redirectToCheckout', [
              js.JsObject.jsify({
                'sessionId': sessionId,
              })
            ]);
          } else {
            throw 'Session ID not found in response: ${response.body}';
          }
        } else {
          // Code mobile existant
          await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntentData['clientSecret'],
              merchantDisplayName: 'NMAL Store',
            ),
          );

          await Stripe.instance.presentPaymentSheet();

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Paiement réussi!')),
            );
            _showSuccessDialog();
          }
        }
      } else {
        throw 'Error from server: ${response.body}';
      }
    } catch (e) {
      print('Error in _handlePayment: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
  }

  void _showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white.withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Purchase ${widget.title}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Total: \$${widget.price}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Choose your payment method:',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _handlePayment('card');
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.credit_card),
                  SizedBox(width: 8),
                  Text('Credit Card'),
                ],
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Paiement réussi !'),
        content: const Text('Merci pour votre achat de rien !'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width <= 800;
    
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Card(
          elevation: isHovered ? 8 : 0,
          child: InkWell(
            onTap: () => _showPaymentDialog(context),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: _getGradient(),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.icon,
                    size: isSmallScreen ? 36 : 48,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 18 : 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 11 : 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${widget.price}',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 28 : 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black45,
                          offset: const Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    transform: Matrix4.translationValues(0, isHovered ? 8 : 0, 0),
                    child: Text(
                      isHovered ? 'GIFT WRAPPED' : 'ONLY',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 9 : 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
