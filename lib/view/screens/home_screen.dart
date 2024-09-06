import 'package:flutter/material.dart';
import 'package:lewach/view/widgets/bid_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController = TextEditingController();
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0), // Ensures circular shape
        ),
        //backgroundColor: Colors.lightGreen.withOpacity(0.5),
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 15, vertical: 0), // Reduced vertical padding
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hi, Welcome to Lewach',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: 'Search',
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 25,
                    color: Colors.grey,
                  ),
                  // suffixIcon: const Icon(
                  //   Icons.keyboard_voice_outlined,
                  //   size: 25,
                  //   color: Colors.grey,
                  // ),
                ),
              ),
              const SizedBox(height: 40),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trending Items for bid',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          BidCardWidget(
                            title: 'Pair of Shoe',
                            color: Colors.green.withOpacity(0.3),
                            imagePath: "",
                            numberOfBids: 10,
                            percentFinished: 10,
                          ),
                          BidCardWidget(
                            title: 'Tshirt',
                            color: Colors.green.withOpacity(0.3),
                            imagePath: "",
                            numberOfBids: 10,
                            percentFinished: 10,
                          ),
                          BidCardWidget(
                            title: 'Gym Bag',
                            color: Colors.green.withOpacity(0.3),
                            imagePath: "",
                            numberOfBids: 10,
                            percentFinished: 10,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'All items for bid',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          BidCardWidget(
                            title: 'Pair of Shoe',
                            color: Colors.green.withOpacity(0.3),
                            imagePath: "",
                            numberOfBids: 10,
                            percentFinished: 10,
                          ),
                          BidCardWidget(
                            title: 'Tshirt',
                            color: Colors.green.withOpacity(0.3),
                            imagePath: "",
                            numberOfBids: 10,
                            percentFinished: 10,
                          ),
                          BidCardWidget(
                            title: 'Gym Bag',
                            color: Colors.green.withOpacity(0.3),
                            imagePath: "",
                            numberOfBids: 10,
                            percentFinished: 10,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
