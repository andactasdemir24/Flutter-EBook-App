import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/my_tabs.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  List popularBooks = [];
  List books = [];
  late ScrollController _scrollController;
  late TabController _tabController;
  readData() async {
    await DefaultAssetBundle.of(context).loadString("json/popularBooks.json").then((value) {
      setState(() {
        popularBooks = jsonDecode(value);
      });
    });
    await DefaultAssetBundle.of(context).loadString("json/books.json").then((value) {
      setState(() {
        books = jsonDecode(value);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
    readData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const ImageIcon(
                      AssetImage('Assets/png/square.png'),
                      size: 24,
                      color: Colors.black,
                    ),
                    Row(
                      children: const [
                        Icon(Icons.search),
                        Icon(Icons.notifications),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: const Text(
                      'Populer Books',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 180,
                child: Stack(children: [
                  Positioned(
                    top: 0,
                    left: -20,
                    right: 0,
                    child: SizedBox(
                      height: 180,
                      child: PageView.builder(
                        itemCount: popularBooks.length,
                        controller: PageController(viewportFraction: 0.8),
                        itemBuilder: (_, i) {
                          return Container(
                            height: 180,
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(image: AssetImage(popularBooks[i]["img"]), fit: BoxFit.fill)),
                          );
                        },
                      ),
                    ),
                  ),
                ]),
              ),
              Expanded(
                  child: NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (BuildContext context, bool isScrolled) {
                  return [
                    SliverAppBar(
                      pinned: true,
                      backgroundColor: Colors.white,
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(50),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20, left: 20),
                          child: TabBar(
                            indicatorPadding: const EdgeInsets.all(0),
                            indicatorSize: TabBarIndicatorSize.label,
                            labelPadding: const EdgeInsets.only(right: 10),
                            isScrollable: true,
                            controller: _tabController,
                            indicator: BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                offset: const Offset(0, 0),
                                blurRadius: 7,
                              )
                            ]),
                            tabs: const [
                              AppTabs(color: Colors.yellow, text: "New"),
                              AppTabs(color: Colors.blue, text: "Popular"),
                              AppTabs(color: Colors.red, text: "Trending"),
                            ],
                          ),
                        ),
                      ),
                    )
                  ];
                },
                body: TabBarView(controller: _tabController, children: [
                  ListView.builder(
                    itemCount: books.length,
                    itemBuilder: (_, i) {
                      return Container(
                        color: Colors.white,
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                        child: Container(
                          decoration:
                              BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white, boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 2,
                              offset: const Offset(0, 0),
                            ),
                          ]),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Container(
                                  height: 120,
                                  width: 90,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(image: AssetImage(books[i]["img"]))),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          size: 20,
                                          color: Colors.yellow,
                                        ),
                                        Text(
                                          books[i]["rating"],
                                          style: const TextStyle(fontSize: 15, color: Colors.pink),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(
                                        books[i]["title"],
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: Text(
                                        books[i]["text"],
                                        style: const TextStyle(fontSize: 15, color: Colors.grey),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Container(
                                        width: 60,
                                        height: 20,
                                        decoration:
                                            BoxDecoration(borderRadius: BorderRadius.circular(3), color: Colors.blue),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          "Love",
                                          style: TextStyle(fontSize: 12, fontFamily: "Avenir", color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  ListView.builder(
                    itemCount: books.length,
                    itemBuilder: (_, i) {
                      return Container(
                        color: Colors.white,
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                        child: Container(
                          decoration:
                              BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white, boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 2,
                              offset: const Offset(0, 0),
                            ),
                          ]),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Container(
                                  height: 120,
                                  width: 90,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(image: AssetImage(books[i]["img"]))),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          size: 20,
                                          color: Colors.yellow,
                                        ),
                                        Text(
                                          books[i]["rating"],
                                          style: const TextStyle(fontSize: 15, color: Colors.pink),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(
                                        books[i]["title"],
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: Text(
                                        books[i]["text"],
                                        style: const TextStyle(fontSize: 15, color: Colors.grey),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Container(
                                        width: 60,
                                        height: 20,
                                        decoration:
                                            BoxDecoration(borderRadius: BorderRadius.circular(3), color: Colors.blue),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          "Love",
                                          style: TextStyle(fontSize: 12, fontFamily: "Avenir", color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  ListView.builder(
                    itemCount: books.length,
                    itemBuilder: (_, i) {
                      return Container(
                        color: Colors.white,
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                        child: Container(
                          decoration:
                              BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white, boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 2,
                              offset: const Offset(0, 0),
                            ),
                          ]),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Container(
                                  height: 120,
                                  width: 90,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(image: AssetImage(books[i]["img"]))),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          size: 20,
                                          color: Colors.yellow,
                                        ),
                                        Text(
                                          books[i]["rating"],
                                          style: const TextStyle(fontSize: 15, color: Colors.pink),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(
                                        books[i]["title"],
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: Text(
                                        books[i]["text"],
                                        style: const TextStyle(fontSize: 15, color: Colors.grey),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Container(
                                        width: 60,
                                        height: 20,
                                        decoration:
                                            BoxDecoration(borderRadius: BorderRadius.circular(3), color: Colors.blue),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          "Love",
                                          style: TextStyle(fontSize: 12, fontFamily: "Avenir", color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ]),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
