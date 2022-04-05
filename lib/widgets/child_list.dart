import 'package:mosaic/models/child.dart';
import 'package:flutter/material.dart';

class ChildList extends StatelessWidget {
  final List<Child> child;
  final Function navigateFunction;

  // ignore: use_key_in_widget_constructors
  const ChildList(this.child, this.navigateFunction);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Column(
          children: [
            SizedBox(
              height: 450,
              child: child.isEmpty
                  ? Column(
                      children: const <Widget>[
                        Text(
                          'No child registered',
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    )
                  : ListView.builder(
                      itemBuilder: (ctx, index) {
                        return Card(
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 5,
                          ),
                          child: InkWell(
                            onTap: () {
                              navigateFunction(child[index].id);
                            },
                            child: ListTile(
                              title: Text(
                                child[index].nama.toString(),
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              subtitle: Text(
                                child[index].email.toString(),
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: child.length,
                    ),
            )
          ],
        ));
  }
}
