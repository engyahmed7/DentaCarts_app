import 'dart:convert';

import 'package:DentaCarts/core/app_colors.dart';
import 'package:DentaCarts/core/app_strings.dart';
import 'package:DentaCarts/model/product_model.dart';
import 'package:DentaCarts/view/details_produc_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class SaleProductsList extends StatefulWidget {
  const SaleProductsList({super.key});

  @override
  _SaleProductsListState createState() => _SaleProductsListState();
}

class _SaleProductsListState extends State<SaleProductsList> {


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {


    return FutureBuilder <List<ProductModel>?>(
      future: getProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading banner'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No banner available'));
        } else {
          List<ProductModel>? productModel = snapshot.data;
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: productModel?.length,
            itemBuilder: (context, index) {
              ProductModel product = productModel![index];

              return InkWell(
                onTap: () {
                  // Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  //   return DetailsProductPage(
                  //     product: widget.product,
                  //   );
                  // }));
                },
                child: Stack(
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SizedBox(
                        height: 150,
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                              child: Image.network(
                                "${AppStrings.marwanHoo}"
                                // widget.product.images.isNotEmpty
                                //     ? widget.product.images.first
                                //     : 'https://via.placeholder.com/100',
                                // height: double.infinity,
                                // width: 100,
                                // fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                Row(
                                children: List.generate(
                                  5,
                                      (index) => Icon(
                                    Icons.star,
                                    // color: index < avgRating.round()
                                    //     ? Colors.amber
                                    //     : Colors.grey,
                                        color:
                                        Colors.amber,

                                    size: 16,
                                  ),
                                ),
                              ),
                                        const SizedBox(width: 5),
                                        const Text(
                                          "{rating}+",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "${productModel?[index].title}",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      product.description,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              // "\$${widget.product.price.toStringAsFixed(2)}",
                                              "",
                                              style: TextStyle(
                                                decoration: TextDecoration.lineThrough,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              //"\$${(widget.product.price * 0.8).toStringAsFixed(2)}",
                                              "",
                                              style: TextStyle(
                                                color: AppColors.primaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: const Text(
                                            "30% OFF",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){

                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  color: Colors.pink.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.add_shopping_cart,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: (){},
                          icon: Icon(
                            //isWishlisted ? Icons.favorite : Icons.favorite_border,
                            //color: isWishlisted ? Colors.red : AppColors.primaryColor,
                            Icons.favorite_border,
                            color: AppColors.primaryColor,
                          ),
                          iconSize: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }


}

 Future<List<ProductModel>> getProducts() async {
  final response = await http.get(
    Uri.parse('${AppStrings.baseUrl}/api/products'),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return ProductModel.listFromJson(data);
  } else {
    return [];
  }
}