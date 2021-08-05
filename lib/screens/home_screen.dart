import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:practicle_interview/helper/attribute_helper.dart';
import 'package:practicle_interview/helper/db_helper.dart';
import 'package:practicle_interview/models/product_model.dart';
import 'package:practicle_interview/screens/atrribute_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routes = "home_screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Products>> fetchProducts;
  late Future<List<Map<String, dynamic>>> fetchAllAttributes;
  AsyncSnapshot? as, ps;
  int newProductId = 0;
  @override
  void initState() {
    super.initState();
    dbh.initDB();
    fetchProducts = dbh.getAllData();
    fetchAllAttributes = attributeHelper.getAllData();
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _colorController = TextEditingController();
  TextEditingController _stockController = TextEditingController();
  TextEditingController _typeController = TextEditingController();
  String name = "", color = "", type = " ";

  int stock = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          "Products",
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey.shade200.withOpacity(1),
      body: FutureBuilder(
        future: fetchProducts,
        builder: (context, AsyncSnapshot snapProducts) {
          ps = snapProducts;
          if (snapProducts.hasError) {
            return Center(
              child: Text(snapProducts.error.toString()),
            );
          } else if (snapProducts.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return FutureBuilder(
              future: fetchAllAttributes,
              builder: (context, AsyncSnapshot attributeSnapshot) {
                as = attributeSnapshot;
                if (attributeSnapshot.hasError) {
                  return Center(
                    child: Text(attributeSnapshot.error.toString()),
                  );
                } else if (attributeSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return (snapProducts.data.length == 0)
                    ? Center(
                        child: Text(
                          "No Products is there....",
                          style: TextStyle(fontSize: 25),
                        ),
                      )
                    : ListView.builder(
                        itemCount: snapProducts.data!.length,
                        itemBuilder: (context, index) {
                          newProductId = snapProducts.data!.length;
                          return Card(
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      "https://png.pngtree.com/thumb_back/fw800/back_our/20190622/ourmid/pngtree-purple-ray-light-strip-minimalist-banner-background-image_210030.jpg"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      onPressed: () async {
                                        dbh.deleteProduct(
                                            id: snapProducts.data[index].id);
                                        setState(() {
                                          fetchProducts = dbh.getAllData();
                                        });
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 28,
                                      ),
                                    ),
                                  ),
                                  Wrap(
                                    direction: Axis.vertical,
                                    alignment: WrapAlignment.center,
                                    spacing: 20,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Product Type := ${snapProducts.data[index].type}",
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "Product Name := ${snapProducts.data[index].name}",
                                        style: TextStyle(
                                            fontSize: 25, color: Colors.white),
                                      ),
                                      Text(
                                        "Product Color := ${snapProducts.data[index].color}",
                                        style: TextStyle(
                                            fontSize: 25, color: Colors.white),
                                      ),
                                      Text(
                                        "Product Stock := ${snapProducts.data[index].stock}",
                                        style: TextStyle(
                                            fontSize: 25, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
              });
        },
      ),
      bottomNavigationBar: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(primary: Colors.purple),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return AttributeScreen();
                    },
                  ),
                ).then((value) {
                  setState(() {
                    fetchProducts = dbh.getAllData();
                    fetchAllAttributes = attributeHelper.getAllData();
                  });
                });
              },
              child: Center(
                  child: Text(
                "Add Attributes",
                style: TextStyle(fontSize: 20),
              )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.purple),
              onPressed: () {
                setState(() {
                  fetchAllAttributes = attributeHelper.getAllData();
                });
                getProductForm();
              },
              child: Center(
                child: Text(
                  "Add Products",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  getProductForm() {
    List<String> attributesName = [];
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Product Form"),
            content: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            controller: _typeController,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please Enter Product Product Type First....";
                              }
                              return null;
                            },
                            onSaved: (val) {
                              setState(() {
                                type = val!;
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Type",
                              hintText: "Enter Product Type",
                            ),
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            controller: _nameController,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please Enter Product Name First....";
                              }
                              return null;
                            },
                            onSaved: (val) {
                              setState(() {
                                name = val!;
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Name",
                              hintText: "Enter Product Name",
                            ),
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            controller: _colorController,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please Enter Product's Color First....";
                              }
                              return null;
                            },
                            onSaved: (val) {
                              setState(() {
                                color = val!;
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Color",
                              hintText: "Enter Product Color",
                            ),
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            controller: _stockController,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please Enter Product Quantity First....";
                              }
                              return null;
                            },
                            onSaved: (val) {
                              setState(() {
                                stock = int.parse(val!);
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Stock",
                              hintText: "Enter Product Quantity",
                            ),
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                    Text(
                      "Attributes",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: as!.data.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                TextFormField(
                                  controller: TextEditingController.fromValue(
                                      TextEditingValue.empty),
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return "Please Enter Product Quantity First....";
                                    }
                                    return null;
                                  },
                                  onSaved: (val) {
                                    setState(() {
                                      attributesName.add(val!);
                                    });
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText:
                                        "${as!.data[index]["attribute"]}",
                                    hintText:
                                        "Enter Product ${as!.data[index]["attribute"]}",
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            );
                          }),
                    ),
                    SizedBox(height: 15),
                    Wrap(
                      alignment: WrapAlignment.end,
                      crossAxisAlignment: WrapCrossAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancel"),
                        ),
                        SizedBox(width: 15),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              dbh.addData(
                                products: Products(
                                  name: name,
                                  color: color,
                                  selected: 0,
                                  stock: stock,
                                  type: type,
                                ),
                              );
                              setState(() {
                                fetchProducts = dbh.getAllData();
                              });
                              _colorController.clear();
                              _stockController.clear();
                              _nameController.clear();
                              Navigator.of(context).pop();
                              Timer(Duration(seconds: 3), () {});
                            }
                          },
                          child: Text("Submit"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
