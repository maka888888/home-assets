import 'package:flutter/material.dart';
import 'package:home_assets3/models/seller_model.dart';
import 'package:home_assets3/ui/catalog/sellers/seller_edit.dart';

class SellerCard extends StatelessWidget {
  final SellerModel seller;
  const SellerCard({super.key, required this.seller});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(seller.sellerName),
      trailing: IconButton(
        icon: const Icon(Icons.arrow_forward_ios),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SellerEditScreen(seller: seller),
            ),
          );
        },
      ),
    );
  }
}
