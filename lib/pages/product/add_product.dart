import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kope/pages/widgets/custom_drop_down_button.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String categorie;
  List<String> _categorieList = ["Electronique", "Vetement"];
  List<File> _image = List<File>();
  final PageController ctrl = PageController(viewportFraction: 0.8);
  // Keep track of current page to avoid unnecessary renders
  int currentPage = 0;
  @override
  void initState() {
    super.initState();
    categorie = _categorieList[0];
    ctrl.addListener(() {
      int next = ctrl.page.round();

      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
  }

  picker(bool isCamenra) async {
    print('Picker is called');
    File img = isCamenra
        ? await ImagePicker.pickImage(source: ImageSource.camera)
        : await ImagePicker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      _image.add(img);
      setState(() {});
    }
  }

  _buildStoryPage(File img, bool active) {
    // Animated Properties
    final double blur = active ? 30 : 0;
    final double offset = active ? 20 : 0;
    final double top = active ? 1 : 2;

    return AnimatedContainer(
      width: MediaQuery.of(context).size.width,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOutQuint,
      margin: EdgeInsets.only(top: top, bottom: 1, right: 3),
      child: Image.file(img,
          fit: BoxFit.cover, width: MediaQuery.of(context).size.width),
    );
  }

  _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 130.0,
            color: Color(0xFF737373).withOpacity(1.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0))),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text('Camera'),
                    leading: Icon(Icons.camera, color: Colors.deepOrange),
                    onTap: () {
                      Navigator.pop(context);
                      picker(true);
                    },
                  ),
                  ListTile(
                    title: Text('Gallery'),
                    leading: Icon(Icons.folder_open, color: Colors.lightGreen),
                    onTap: () {
                      Navigator.pop(context);
                      picker(false);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.grey,
            expandedHeight: 250.0,
            pinned: true,
            floating: false,
            flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  "Ajouter un article",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                background: _image.length == 0
                    ? Image.asset("assets/images/back.jpg", fit: BoxFit.cover)
                    : PageView.builder(
                        controller: ctrl,
                        itemCount: _image.length,
                        itemBuilder: (context, int currentIdx) {
                          // Active page
                          // if (currentIdx == 0)
                          //   return _buildStoryPage(
                          //       _image[0], true);
                          bool active = currentIdx == currentPage;
                          return _buildStoryPage(_image[currentIdx], active);
                        })),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Material(
                    elevation: 5.0,
                    child: Container(
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            child: Text('Add Photo'),
                            onPressed: () {
                              _showBottomSheet();
                            },
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          RaisedButton(
                            onPressed: (){},
                            child: Text('Remove Photo'),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Material(
                    elevation: 10.0,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Form(
                        key: _formKey,
                        child: Container(
                          height: 400.0,
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(Icons.category),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text('Categorie'),
                                  Spacer(),
                                  CustomDropdownButton(
                                    value: categorie,
                                    items: _categorieList,
                                    onChanged: (value) {
                                      setState(() {
                                        categorie = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  icon: Icon(Icons.edit),
                                  labelText: 'Designation',
                                ),
                                validator: (value) => value == null
                                    ? 'Completez la designation'
                                    : null,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  icon: Icon(Icons.monetization_on),
                                  labelText: 'Prix',
                                ),
                                validator: (value) =>
                                    value == null ? 'Completez le prix' : null,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  icon: Icon(Icons.description),
                                  labelText: 'Description',
                                ),
                                keyboardType: TextInputType.multiline,
                                maxLines: 5,
                                validator: (value) => value == null
                                    ? 'Completez la description'
                                    : null,
                              ),
                              Spacer(),
                              RaisedButton(
                                  child: Text('Ajouter'),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                    }
                                  })
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
