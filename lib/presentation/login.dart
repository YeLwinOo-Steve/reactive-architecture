import 'package:flutter/material.dart';
import 'package:reactive_architecture/bloc/login_bloc.dart';
import 'package:reactive_architecture/presentation/home.dart';
import 'package:reactive_architecture/service/auth_service_impl.dart';

import '../alias/login_alias.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final LoginBloc bloc = LoginBloc(AuthServiceImpl());

  @override
  void initState() {
    super.initState();
    bloc.getPerson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
      ),
      body: StreamBuilder(
        stream: bloc.mainStream,
        builder: (context, snapshot) {
          print("---------------${snapshot.data}");
          bool isLoading =
              snapshot.data is LoginVM && (snapshot.data?.isLoading ?? false);
          if (isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data?.isRequestError ?? false) {
            return Center(
              child: Text(
                snapshot.data?.message ?? 'request error',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                ),
              ),
            );
          }
          return Center(
              child: Column(
            children: [
              Text(
                "${bloc.lastPerson?.name}",
                style: const TextStyle(fontSize: 20),
              ),
              FilledButton.icon(
                onPressed: () {
                  bloc.getCity();
                },
                icon: snapshot.data is CityVM &&
                        (snapshot.data?.isLoading ?? false)
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.loop),
                label: Text(bloc.lastCity ?? 'Generate city'),
              ),
            ],
          ));
        },
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "refresh",
            onPressed: () {
              bloc.getPerson();
            },
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 20),
          FloatingActionButton(
            heroTag: "home",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(),
                ),
              );
            },
            child: const Icon(Icons.explore),
          )
        ],
      ),
    );
  }
}
