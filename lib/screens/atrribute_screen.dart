import 'package:flutter/material.dart';

import 'package:practicle_interview/helper/attribute_helper.dart';

class AttributeScreen extends StatefulWidget {
  @override
  _AttributeScreenState createState() => _AttributeScreenState();
}

class _AttributeScreenState extends State<AttributeScreen> {
  GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  TextEditingController _attributeController = TextEditingController();
  String attributes = "";
  late Future<List<Map<String, dynamic>>> fetchAllAttributes;

  @override
  void initState() {
    fetchAllAttributes = attributeHelper.getAllData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("Attributes"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: fetchAllAttributes,
        builder: (context, AsyncSnapshot snapshotAttributes) {
          if (snapshotAttributes.hasError) {
            return Center(
              child: Text(snapshotAttributes.error.toString()),
            );
          } else if (snapshotAttributes.connectionState ==
              ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return (snapshotAttributes.data.length == 0)
              ? Center(
                  child: Text(
                    "No Attributes is there ... ",
                    style: TextStyle(fontSize: 30),
                  ),
                )
              : ListView.builder(
                  itemCount: snapshotAttributes.data.length,
                  itemBuilder: (context, index) {
                    return Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 40, top: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${snapshotAttributes.data[index]["attribute"]}",
                            style:
                                TextStyle(color: Colors.purple, fontSize: 30),
                          ),
                          IconButton(
                            onPressed: () async {
                              attributeHelper.deleteAttributes(
                                  id: snapshotAttributes.data[index]["id"]);
                              setState(() {
                                fetchAllAttributes =
                                    attributeHelper.getAllData();
                              });
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    );
                  });
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {
          getForm();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  getForm() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Add Attributes"),
            content: Form(
              key: _formKey2,
              child: TextFormField(
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                controller: _attributeController,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Please Enter Product Product Type First....";
                  }
                  return null;
                },
                onSaved: (val) {
                  setState(() {
                    attributes = val!;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Type",
                  hintText: "Enter Product Type",
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  if (_formKey2.currentState!.validate()) {
                    _formKey2.currentState!.save();
                    attributeHelper.insertData(attributes: attributes);
                    _attributeController.clear();
                    setState(() {
                      fetchAllAttributes = attributeHelper.getAllData();
                    });
                    Navigator.of(context).pop();
                  }
                },
                child: Text("Add"),
              ),
            ],
          );
        });
  }
}
