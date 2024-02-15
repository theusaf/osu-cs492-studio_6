import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:studio_6_layout_challenge/widgets/triangle.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Weather App Demo'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  final Map<String, String> forecast = {
    "name": "today",
    "temperature": "35",
    "shortForecast": "Snowy",
    "detailedForecast": "Snowy all day",
    "windSpeed": "10",
    "windDirection": "SE",
    "isDaytime": "true",
    "probabilityOfPercipitation": "100"
  };

  final Map<String, String> location = {
    "city": "Bend",
    "state": "Oregon",
    "zip": "97702"
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Center(
            child: Text(title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Theme.of(context).colorScheme.onPrimary)),
          )),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _LocationTitle(location: location),
              _WeatherForecastCard(forecast: forecast)
            ],
          ),
        ),
      ),
    );
  }
}

class _WeatherForecastCard extends StatelessWidget {
  const _WeatherForecastCard({
    required this.forecast,
  });

  final Map<String, String> forecast;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text("${forecast['name']}'s forecast",
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 10),
              Container(
                constraints: const BoxConstraints(
                  maxWidth: 500,
                ),
                child: _WeatherCardMainSection(forecast: forecast),
              ),
              const SizedBox(height: 10),
              _ForecastStatusDisplay(forecast: forecast),
            ],
          ),
        ));
  }
}

class _ForecastStatusDisplay extends StatefulWidget {
  const _ForecastStatusDisplay({
    required this.forecast,
  });

  final Map<String, String> forecast;

  @override
  State<_ForecastStatusDisplay> createState() => _ForecastStatusDisplayState();
}

class _ForecastStatusDisplayState extends State<_ForecastStatusDisplay> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final shortForecast = GestureDetector(
      onTap: () => setState(() => isExpanded = !isExpanded),
      child: Text("${widget.forecast['shortForecast']}",
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                decoration: TextDecoration.underline,
              )),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            shortForecast,
            Positioned(
              top: 30,
              child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 150),
                  opacity: isExpanded ? 1 : 0,
                  child: HoverDialog(
                    child: Text("${widget.forecast['detailedForecast']}",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.onSecondary,
                            )),
                  )),
            ),
          ],
        ),
      ],
    );
  }
}

class HoverDialog extends StatelessWidget {
  const HoverDialog({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Triangle(
            size: const Size(20, 10),
            child: Container(
                color: Theme.of(context).colorScheme.secondary,
                padding: const EdgeInsets.all(4.0))),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.all(4.0),
          child: child,
        ),
      ],
    );
  }
}

class _WeatherCardMainSection extends StatelessWidget {
  const _WeatherCardMainSection({
    required this.forecast,
  });

  final Map<String, String> forecast;

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${forecast['temperature']}°",
                  style: Theme.of(context).textTheme.bodyLarge),
              Row(children: [
                const Icon(FontAwesomeIcons.cloudRain),
                const SizedBox(width: 5),
                Text('${forecast['probabilityOfPercipitation']}%',
                    style: Theme.of(context).textTheme.bodyMedium)
              ]),
            ],
          ),
        ),
        const Expanded(
          flex: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Placeholder(
                fallbackHeight: 200,
                fallbackWidth: 200,
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Text("${forecast['windSpeed']} mph",
                  style: Theme.of(context).textTheme.bodyLarge),
              WindDirectionPointer(direction: forecast['windDirection']),
            ],
          ),
        )
      ],
    );
  }
}

class WindDirectionPointer extends StatelessWidget {
  const WindDirectionPointer({
    super.key,
    required this.direction,
  });

  final String? direction;

  @override
  Widget build(BuildContext context) {
    final rotationAngle = switch (direction) {
      "N" => 0.0,
      "NE" => pi / 4,
      "E" => pi / 2,
      "SE" => 3 * pi / 4,
      "S" => pi,
      "SW" => 5 * pi / 4,
      "W" => 3 * pi / 2,
      "NW" => 7 * pi / 4,
      _ => 0.0,
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.rotate(
            angle: rotationAngle,
            child: const Icon(FontAwesomeIcons.arrowUp, size: 15)),
        Text("$direction", style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}

class _LocationTitle extends StatelessWidget {
  const _LocationTitle({
    required this.location,
  });

  final Map<String, String> location;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("Weather for ", style: Theme.of(context).textTheme.headlineSmall),
        Text("${location['city']}, ${location['state']} ${location['zip']}",
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  decoration: TextDecoration.underline,
                )),
      ]),
    );
  }
}
