import 'package:flutter/material.dart';

import 'contact.dart';
import 'new_contact.dart';

void main() => runApp(
      MaterialApp(
        title: 'Material App',
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.deepOrange),
        routes: {
          '/new-contact': (context) => const NewContactView(),
        },
      ),
    );

//! Home Page !\\

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material App Bar'),
      ),
      body: ValueListenableBuilder(
        valueListenable: ContactBook(),
        builder: (context, value, child) {
          final contacts = value as List<Contact>;
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return Dismissible(
                onDismissed: (direction) {
                  ContactBook().remove(contact: contact);
                },
                key: ValueKey(contact.id),
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  shape: const StadiumBorder(),
                  elevation: 5,
                  color: Colors.deepOrange,
                  child: ListTile(
                    title: Text(contact.name),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () async {
                await Navigator.of(context).pushNamed('/new-contact');
              },
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }
}
