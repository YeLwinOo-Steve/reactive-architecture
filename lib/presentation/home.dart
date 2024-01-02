import 'package:flutter/material.dart';

import '../alias/home_alias.dart';
import '../bloc/home_bloc.dart';
import '../service/location_service_impl.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final bloc = HomeBloc(LocationServiceImpl());

  @override
  void initState() {
    super.initState();
    bloc.getContinents();
  }

  @override
  void dispose() {
    bloc.onDispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: StreamBuilder(
          stream: bloc.mainStream,
          builder: (context, snapshot) {
            if (snapshot.data is ContinentVM && snapshot.data?.isLoading ??
                false) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.teal),
              );
            }
            if (snapshot.data?.isRequestError ?? false) {
              return const Center(
                child: Text('Request error occurred!'),
              );
            }
            return Column(
              children: [
                DropdownButton<String>(
                    elevation: 0,
                    isExpanded: true,
                    underline: const SizedBox.shrink(),
                    icon: const Icon(Icons.arrow_downward),
                    items: bloc.lastContinents
                        .map((e) => DropdownMenuItem(
                              key: ValueKey<int>(e.hashCode),
                              value: e,
                              child: Text(e ?? 'Error ----'),
                            ))
                        .toList(),
                    value: bloc.selectedContinent ?? bloc.lastContinents.first,
                    hint: const Text("Select your continent"),
                    onChanged: bloc.changeContinent),
                getCountryWidget(snapshot.data),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 0.3),
                    ),
                    child: getAddressWidget(snapshot.data),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget getCountryWidget(dynamic data) {
    if (data is CountryVM && data.isLoading ?? false) {
      return const Text('Loading countries ...', textAlign: TextAlign.center);
    }
    if (data is CountryVM && data.isRequestError ?? false) {
      return const Text(
        'Hey you have an error!',
        style: TextStyle(color: Colors.red),
      );
    }
    return DropdownButton<String>(
        elevation: 0,
        isExpanded: true,
        underline: const SizedBox.shrink(),
        icon: const Icon(Icons.arrow_downward),
        items: bloc.lastCountries
            .map((e) => DropdownMenuItem(
                  key: ValueKey<int>(e.hashCode),
                  value: e,
                  child: Text(e ?? 'Error ----'),
                ))
            .toList(),
        value: bloc.selectedCountry ?? bloc.lastCountries.first,
        hint: const Text("Select your country"),
        onChanged: bloc.changeCountry);
  }

  Widget getAddressWidget(dynamic data) {
    if (data is AddressVM && data.isLoading ?? false) {
      return const Center(
        child: Text('Loading your address ...', textAlign: TextAlign.center),
      );
    }
    if (data is AddressVM && data.isRequestError ?? false) {
      return const Center(
        child: Text(
          "We can't retrieve your address!",
          style: TextStyle(color: Colors.red),
        ),
      );
    }
    if (data is AddressVM && data.isLoaded ?? false) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (bloc.lastAddress != null) ...[
              Text(
                bloc.lastAddress?.city ?? 'No address found!',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                bloc.lastAddress?.zipCode ?? 'No zip code found!',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                bloc.lastAddress?.city ?? 'No address found!',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                bloc.lastAddress?.street ?? 'No street found!',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ],
        ),
      );
    }
    return const Center(
      child: Text('Please select a country first!'),
    );
  }
}
