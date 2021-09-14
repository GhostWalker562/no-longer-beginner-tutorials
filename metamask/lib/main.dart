import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:metamask/metamask.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MetaMaskProvider()..init(),
      builder: (context, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF181818),
          body: Stack(
            children: [
              Center(
                child: Consumer<MetaMaskProvider>(
                  builder: (context, provider, child) {
                    late final String text;

                    if (provider.isConnected && provider.isInOperatingChain) {
                      text = 'Connected';
                    } else if (provider.isConnected &&
                        !provider.isInOperatingChain) {
                      text =
                          'Wrong chain. Please connect to ${MetaMaskProvider.operatingChain}';
                    } else if (provider.isEnabled) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Click the button...'),
                          const SizedBox(height: 8),
                          CupertinoButton(
                            onPressed: () =>
                                context.read<MetaMaskProvider>().connect(),
                            color: Colors.white,
                            padding: const EdgeInsets.all(0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.network(
                                  'https://i0.wp.com/kindalame.com/wp-content/uploads/2021/05/metamask-fox-wordmark-horizontal.png?fit=1549%2C480&ssl=1',
                                  width: 300,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      text = 'Please use a Web3 supported browser.';
                    }

                    return ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Colors.purple, Colors.blue, Colors.red],
                      ).createShader(bounds),
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    );
                  },
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: Image.network(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTicLAkhCzpJeu9OV-4GOO-BOon5aPGsj_wy9ETkR4g-BdAc8U2-TooYoiMcPcmcT48H7Y&usqp=CAU',
                    fit: BoxFit.cover,
                    opacity: const AlwaysStoppedAnimation(0.025),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
