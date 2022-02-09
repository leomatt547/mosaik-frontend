import 'package:flutter/material.dart';
import 'landing_screen.dart';

class RegisterChildPage extends StatelessWidget {
  const RegisterChildPage({Key? key}) : super(key: key);
  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Route route =
                  MaterialPageRoute(builder: (context) => const LandingPage());
              Navigator.push(context, route);
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Icon(
          Icons.cottage_outlined,
          size: 30,
          color: Colors.black,
        ),
        actions: const <Widget>[
          Padding(
            padding: EdgeInsets.all(4),
            child: Icon(
              Icons.check_box_outline_blank_outlined,
              size: 30,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4),
            child: Icon(
              Icons.account_circle_outlined,
              size: 30,
              color: Colors.black,
            ),
          ),
          Padding(
              padding: EdgeInsets.all(0),
              child: Icon(
                Icons.more_vert,
                size: 30,
                color: Colors.black,
              )),
        ],
        backgroundColor: const Color.fromARGB(255, 196, 196, 196),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Welcome',
                    style: TextStyle(fontSize: 28),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  child: TextFormField(
                      decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  )),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  child: TextFormField(
                      decoration: InputDecoration(
                    labelText: "Your Email (Child)",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  )),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  child: TextFormField(
                      decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  )),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  child: TextFormField(
                      decoration: InputDecoration(
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  )),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  child: TextFormField(
                      decoration: InputDecoration(
                    labelText: "Parent Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  )),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 196, 196, 196),
                    ),
                    child: const Text(
                      "Parent Account",
                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    onPressed: () {
                      Route route = MaterialPageRoute(
                          builder: (context) => const RegisterParentPage());
                      Navigator.push(context, route);
                    },
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 196, 196, 196),
                  ),
                  child: const Text(
                    "Create Account",
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {}
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterParentPage extends StatelessWidget {
  const RegisterParentPage({Key? key}) : super(key: key);
  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Route route =
                  MaterialPageRoute(builder: (context) => const LandingPage());
              Navigator.push(context, route);
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Icon(
          Icons.cottage_outlined,
          size: 30,
          color: Colors.black,
        ),
        actions: const <Widget>[
          Padding(
            padding: EdgeInsets.all(4),
            child: Icon(
              Icons.check_box_outline_blank_outlined,
              size: 30,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4),
            child: Icon(
              Icons.account_circle_outlined,
              size: 30,
              color: Colors.black,
            ),
          ),
          Padding(
              padding: EdgeInsets.all(0),
              child: Icon(
                Icons.more_vert,
                size: 30,
                color: Colors.black,
              )),
        ],
        backgroundColor: const Color.fromARGB(255, 196, 196, 196),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Welcome',
                    style: TextStyle(fontSize: 28),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  child: TextFormField(
                      decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  )),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  child: TextFormField(
                      decoration: InputDecoration(
                    labelText: "Your Email (Parent)",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  )),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  child: TextFormField(
                      decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  )),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  child: TextFormField(
                      decoration: InputDecoration(
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  )),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 196, 196, 196),
                    ),
                    child: const Text(
                      "Child Account",
                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    onPressed: () {
                      Route route = MaterialPageRoute(
                          builder: (context) => const RegisterChildPage());
                      Navigator.push(context, route);
                    },
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 196, 196, 196),
                  ),
                  child: const Text(
                    "Create Account",
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {}
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
