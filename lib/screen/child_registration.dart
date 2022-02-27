import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:mosaic/screen/landing_screen.dart';
import 'package:mosaic/widgets/appbar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
import '../constant.dart';

class ChildRegistration extends StatelessWidget {
  ChildRegistration({Key? key}) : super(key: key);
  static final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(),
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
                    'Membuat Akun Anak',
                    style: TextStyle(fontSize: 28),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  child: TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Masukkan nama anak';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Nama Anak",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                      )),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  child: TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Masukkan email anak';
                        }
                        if (!EmailValidator.validate(value)) {
                          return 'Email tidak valid';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Email Anak",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                      )),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  child: TextFormField(
                      controller: passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Masukkan kata sandi';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Kata Sandi",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                      )),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  child: TextFormField(
                    controller: confirmPasswordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Konfirmasi kata sandi';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Konfirmasi Kata Sandi",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                      )),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 196, 196, 196),
                  ),
                  child: const Text(
                    "Buat Akun",
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Memproses Data')),
                      );
                    } else {
                      return;
                    }
                    Map data = {
                      'nama': nameController.text.toString(),
                      'email': emailController.text.toString(),
                      'password': passwordController.text.toString(),
                      'parent_id': storage.read('parent_id'),
                    };

                    String body = json.encode(data);
                    final response = await http.post(
                      Uri.parse(API_URL + "/childs"),
                      body: body,
                      encoding: Encoding.getByName('utf-8'),
                      headers: {
                        'Authorization': 'Bearer ' + getToken()
                      }
                    );

                    if (response.statusCode == 201) {
                      Alert(
                        context: context,
                        type: AlertType.success,
                        title: "Berhasil",
                        desc: "Registrasi anak berhasil",
                        buttons: [
                          DialogButton(
                            child: const Text(
                              "TUTUP",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            onPressed: () {
                              Route route = MaterialPageRoute(
                                  builder: (context) => const LandingPage());
                              Navigator.push(context, route);
                            },
                          )
                        ],
                      ).show();
                    } else {
                      Alert(
                        context: context,
                        type: AlertType.error,
                        title: "Gagal",
                        desc: "Terjadi kesalahan pada sistem",
                        buttons: [
                          DialogButton(
                            child: const Text(
                              "TUTUP",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            onPressed: () => Navigator.pop(context),
                          )
                        ],
                      ).show();
                    }
                    return;
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
