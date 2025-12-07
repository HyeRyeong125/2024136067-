import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;
  const EditProductScreen({required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.product.title);
    _descController = TextEditingController(text: widget.product.description);
    _priceController = TextEditingController(text: widget.product.price.toString());
  }

  Future<void> _saveChanges() async {
    await FirebaseFirestore.instance.collection('products').doc(widget.product.id).update({
      'title': _titleController.text.trim(),
      'description': _descController.text.trim(),
      'price': int.parse(_priceController.text.trim()),
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('상품 수정')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: InputDecoration(labelText: '제목')),
            TextField(controller: _descController, decoration: InputDecoration(labelText: '설명')),
            TextField(controller: _priceController, decoration: InputDecoration(labelText: '가격'), keyboardType: TextInputType.number),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _saveChanges, child: Text('저장')),
          ],
        ),
      ),
    );
  }
}
