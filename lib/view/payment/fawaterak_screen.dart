import 'dart:convert';

import 'package:DentaCarts/core/app_strings.dart';
import 'package:DentaCarts/view/cart/cart_screen.dart';
import 'package:DentaCarts/view/payment/success_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class FawaterakScreen extends StatefulWidget {
  final Map dataUser;
  const FawaterakScreen({super.key, required this.dataUser});

  @override
  State<FawaterakScreen> createState() => _FawaterakScreenState();
}

class _FawaterakScreenState extends State<FawaterakScreen> {


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => orders(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }



  Future<void> orders(context) async {
    final response = await http.post(
      Uri.parse('${AppStrings.baseUrl}/api/orders/pay'),
      body: jsonEncode({
          "payment_method_id": "card",
          "first_name":widget.dataUser['first_name'],
          "last_name":widget.dataUser['last_name'],
          "address_line": widget.dataUser['address_line'],
          "country": widget.dataUser['country'],
          "city": widget.dataUser['city'],
          "state": widget.dataUser['state'],
          "postal_code": widget.dataUser['postal_code'],
          "phone": widget.dataUser['phone'],
      }),

      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AppStrings.token}',
      },
    );
    final data = json.decode(response.body);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("${data['message']}")));
      String paymentLink = data['payment_link'];
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => WebViewFawaterak(url: paymentLink)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${data}")));
    }
  }


}





class WebViewFawaterak extends StatefulWidget {
  const WebViewFawaterak({super.key, required this.url});

  final String url;

  @override
  State<WebViewFawaterak> createState() => _WebViewFawaterakState();
}

class _WebViewFawaterakState extends State<WebViewFawaterak> {
  late WebViewController controller;
  bool isLoading = false; // track loading state


  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            // if (request.url.startsWith('https://www.youtube.com/')) {
            //   return NavigationDecision.prevent;
            // }

            if(request.url.contains("https://dev.fawaterk.com/success")){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> const SuccessScreen()));
              return NavigationDecision.prevent;
            }else if(request.url.contains("https://dev.fawaterk.com/fail")){
              //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> const FailureScreen()));
              return NavigationDecision.prevent;
            }else if(request.url.contains("https://dev.fawaterk.com/pending")){
              //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> const PendingScreen()));
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Fawaterak')),
        body: isLoading
            ?WebViewWidget(controller: controller)
            : const Center(child: CircularProgressIndicator(),)
    );
  }
}