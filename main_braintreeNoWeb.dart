import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<List<dynamic>> date;
  String github_url = "https://github.com/";
  static Set<String> gits = new Set();
  final List<Feature> features = [];

  static final String tokenizationKey = 'sandbox_pgcksxz4_m4hfkc7qggxk82fg';

  @override
  void initState() {
    super.initState();

    load();
  }

  void load() async {
    await loadAsset();
    loadGits();
    test_http("LeiterCode");
  }

  void loadGits() async {
    for (var e in date) {
      String name = e[0].toString();
      gits.add(github_url + name);
    }
    print(gits);
  }

  void showNonce(BraintreePaymentMethodNonce nonce) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Payment method nonce:'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Nonce: ${nonce.nonce}'),
            SizedBox(height: 16),
            Text('Type label: ${nonce.typeLabel}'),
            SizedBox(height: 16),
            Text('Description: ${nonce.description}'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Braintree example app'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                var request = BraintreeDropInRequest(
                  tokenizationKey: tokenizationKey,
                  collectDeviceData: true,
                  googlePaymentRequest: BraintreeGooglePaymentRequest(
                    totalPrice: '4.20',
                    currencyCode: 'USD',
                    billingAddressRequired: false,
                  ),
                  applePayRequest: BraintreeApplePayRequest(
                      currencyCode: 'USD',
                      supportedNetworks: [
                        ApplePaySupportedNetworks.visa,
                        ApplePaySupportedNetworks.masterCard,
                        // ApplePaySupportedNetworks.amex,
                        // ApplePaySupportedNetworks.discover,
                      ],
                      countryCode: 'US',
                      merchantIdentifier: '',
                      displayName: '',
                      paymentSummaryItems: []),
                  paypalRequest: BraintreePayPalRequest(
                    amount: '4.20',
                    displayName: 'Example company',
                  ),
                  cardEnabled: true,
                );
                final result = await BraintreeDropIn.start(request);
                if (result != null) {
                  showNonce(result.paymentMethodNonce);
                }
              },
              child: Text('LAUNCH NATIVE DROP-IN'),
            ),
            ElevatedButton(
              onPressed: () async {
                final request = BraintreeCreditCardRequest(
                  cardNumber: '4111111111111111',
                  expirationMonth: '12',
                  expirationYear: '2021',
                  cvv: '123',
                );
                final result = await Braintree.tokenizeCreditCard(
                  tokenizationKey,
                  request,
                );
                if (result != null) {
                  showNonce(result);
                }
              },
              child: Text('TOKENIZE CREDIT CARD'),
            ),
            ElevatedButton(
              onPressed: () async {
                final request = BraintreePayPalRequest(
                  amount: null,
                  billingAgreementDescription:
                      'I hereby agree that flutter_braintree is great.',
                  displayName: 'Your Company',
                );
                final result = await Braintree.requestPaypalNonce(
                  tokenizationKey,
                  request,
                );
                if (result != null) {
                  showNonce(result);
                }
              },
              child: Text('PAYPAL VAULT FLOW'),
            ),
            ElevatedButton(
              onPressed: () async {
                final request = BraintreePayPalRequest(amount: '13.37');
                final result = await Braintree.requestPaypalNonce(
                  tokenizationKey,
                  request,
                );
                if (result != null) {
                  showNonce(result);
                }
              },
              child: Text('PAYPAL CHECKOUT FLOW'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String _url) async {
    if (!await launchUrl(Uri.parse(_url))) {
      throw Exception('Could not launch $_url');
    }
  }

  ListTile body_col_e(String git) {
    return ListTile(
        trailing: Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(20))),
        title: TextButton(
          child: Text(git),
          onPressed: () {
            print("Pressed on mindmap");
            _launchUrl(git);
          },
        ));
  }

  Widget body_col() {
    List<Widget> wids = [];
    for (String git in gits) {
      wids.add(Card(child: body_col_e(git)));
    }
    return Container(height: 800, width: 600, child: ListView(children: wids));
  }

  loadAsset() async {
    var myData = await rootBundle.loadString("data/date.csv");
    List<List<dynamic>> csvTable =
        CsvToListConverter(fieldDelimiter: " ", eol: "\n").convert(myData);
    setState(() {
      date = csvTable;
    });
  }

  void test_http(String git) async {
    var url = Uri.parse('https://avatars.githubusercontent.com/u/106401128');

    var response = await http.get(url);
    if (response.statusCode == 200) {
      //var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      print('Body of response:');
      print(response.body);
      var tmp = await http.read(url);
      print(tmp);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  void http_book(List<String> arguments) async {
    // This example uses the Google Books API to search for books about http.
    // https://developers.google.com/books/docs/overview
    var url =
        Uri.https('www.googleapis.com', '/books/v1/volumes', {'q': '{http}'});

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      var itemCount = jsonResponse['totalItems'];
      print('Number of books about http: $itemCount.');
      print(response.body);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

// WEbViewx
//
//
//
//   // In the Future fetch data from github?
//   Future<String> getHtml(String url) async {
//     final response = await http.get(Uri.parse(url), headers: {
//       "Access-Control_Allow_Origin": "*",
//     });
//     print(response);
//     if (response.statusCode == 200) {
//       // If the server did return a 200 OK response,
//       // then parse the JSON.
//       print(response.body);
//       return response.body;
//     } else {
//       // If the server did not return a 200 OK response,
//       // then throw an exception.
//       throw Exception('Failed to load album');
//     }
//   }
// // TODO nice Graphcial presentation -----------------
//   List<Widget> graph(List<Feature> feature) {
//     return [
//       const Padding(
//         padding: const EdgeInsets.symmetric(vertical: 14.0),
//         child: Text(
//           "Tasks Track",
//           style: TextStyle(
//             fontSize: 28,
//             fontWeight: FontWeight.bold,
//             letterSpacing: 2,
//           ),
//         ),
//       ),
//       LineGraph(
//         features: feature,
//         size: Size(520, 400),
//         labelX: const [
//           "Jan",
//           "Feb",
//           "Mar",
//           "Apr",
//           "May",
//           "Jun",
//           "Jul",
//           "Aug",
//           "Sep",
//           "Oct",
//           "Nov",
//           "Dec"
//         ],
//         labelY: ['20%', '40%', '60%', '80%', '100%'],
//         showDescription: true,
//         graphColor: Colors.black,
//         graphOpacity: 0.2,
//         verticalFeatureDirection: true,
//         descriptionHeight: 130,
//       )
//     ];
//   }
//   List<List> buildFeatures(List<List<dynamic>> contr) {
//     List<String> months = [
//       "Jan",
//       "Feb",
//       "Mar",
//       "Apr",
//       "May",
//       "Jun",
//       "Jul",
//       "Aug",
//       "Sep",
//       "Oct",
//       "Nov",
//       "Dec"
//     ];
//     String title = contr.first[0];
//     List<List<dynamic>> tmp = [];
//     List<int> count_month_contr = new List<int>.filled(months.length, 0);
//     for (List<dynamic> c in contr) {
//       months.asMap().forEach((index, month) {
//         if (c[2] == month) {
//           count_month_contr[index] += 1;
//         }
//       });
//       if (title != c[0]) {
//         List<dynamic> a = [title];
//         a.add(count_month_contr);
//         tmp.add(a);
//         count_month_contr = new List<int>.filled(months.length, 0);
//         title = c[0];
//       }
//     }
//     return tmp;
//   }
//   void loadFeatures() {
//     List<List> rawFeatures = buildFeatures(date);
//     for (List feat in rawFeatures) {
//       List<double> tmp = [...feat[1].map((x) => x.toDouble()).toList()];
//       print(feat);
//       features.add(Feature(
//         //title: feat[0],
//         color: Colors.blue,
//         data: tmp,
//       ));
//     }
//   }
// // TOD END Graphical presi --------------------------
//}

}
