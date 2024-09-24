import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lewach/controller/add_item_controller.dart';
import 'package:lewach/controller/user_controller.dart';
import 'package:lewach/view/widgets/common_button.dart'; // Make sure to import your AddItemController

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  UserController? userController;
  @override
  void initState() {
    userController = Get.find<UserController>();
    // TODO: implement initState
    super.initState();
  }

  // Initialize the controller
  final AddItemController _controller = Get.put(AddItemController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item for Exchange'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _controller.productNameController,
                  decoration: const InputDecoration(labelText: 'Product Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _controller.priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'Price estimation of your product (Optional)'),
                ),

                const SizedBox(height: 20),
                Obx(() => DropdownButtonFormField(
                      value: _controller.status.value,
                      items: _controller.statusOptions.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                      onChanged: (value) {
                        _controller.status.value = value!;
                        print(_controller.status.value);
                      },
                      decoration: const InputDecoration(
                          labelText: 'Status of the Item'),
                    )),
                const SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Add Eligible Item for Exchange'),
                  onSubmitted: (value) =>
                      _controller.addEligibleExchangeItem(value),
                ),
                //   const SizedBox(height: 5),
                Wrap(
                  children: List.generate(
                    _controller.exchangeItemList.length,
                    (index) {
                      String item = _controller.exchangeItemList[index];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: Obx(() {
                          // Check if item is selected in eligibleExchangeItems
                          bool isSelected =
                              _controller.eligibleExchangeItems.contains(item);

                          return FilterChip(
                            label: Text(item),
                            selected:
                                isSelected, // This ensures the chip stays in the selected state
                            onSelected: (bool value) {
                              if (value == true) {
                                // Add item if it's selected
                                _controller.eligibleExchangeItems.add(item);
                              } else {
                                // Remove item if it's deselected
                                _controller.eligibleExchangeItems.remove(item);
                              }
                            },
                          );
                        }),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),
                Obx(() => _controller.selectedImage.value == null
                    ? const Text("No image selected")
                    : Image.file(_controller.selectedImage.value!,
                        height: 100)),
                ElevatedButton(
                  onPressed: _controller.pickImage,
                  child: const Text('Pick Image'),
                ),
                const SizedBox(height: 40),
                Obx(() {
                  return _controller.isLoading.value
                      ? Center(child: CircularProgressIndicator())
                      : CommonButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _controller.addItem(); // Call the add item method
                            }
                          },
                          child: Text(
                            'Add Item',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
