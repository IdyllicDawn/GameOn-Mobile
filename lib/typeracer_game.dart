import 'package:flutter/material.dart';

class TypingTestScreen extends StatefulWidget {
  const TypingTestScreen({super.key});

  @override
  TypingTestScreenState createState() => TypingTestScreenState();
}

class TypingTestScreenState extends State<TypingTestScreen> {
  final String textToType = "The quick brown fox jumps over the lazy dog.";
  String typedText = "";
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentLetter();
    });
  }

  void checkInput(String value) {
    setState(() {
      if (value.length > typedText.length) {
        // User typed a character
        typedText = value;
      } else if (value.length < typedText.length) {
        // User pressed backspace
        typedText = typedText.substring(0, typedText.length - 1);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentLetter();
    });
  }

  void _scrollToCurrentLetter() {
    final currentLetterIndex = typedText.length;
    final textSpan = getTextSpan(textToType, typedText);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(maxWidth: double.infinity);

    double currentLetterOffset = 0;
    for (int i = 0; i < currentLetterIndex; i++) {
      final characterWidth = textPainter.width;
      currentLetterOffset += characterWidth;
    }

    final viewportWidth = _scrollController.position.viewportDimension;
    final scrollPosition = currentLetterOffset - (viewportWidth / 2);

    _scrollController.jumpTo(scrollPosition);
  }

  TextSpan getTextSpan(String text, String typedText) {
    List<TextSpan> textSpans = [];
    for (int i = 0; i < text.length; i++) {
      if (i < typedText.length) {
        if (text[i] == typedText[i]) {
          textSpans.add(
            TextSpan(
              text: text[i],
              style: const TextStyle(color: Colors.green),
            ),
          );
        } else {
          textSpans.add(
            TextSpan(
              text: text[i],
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
      } else if (i == typedText.length) {
        textSpans.add(
          TextSpan(
            text: text[i],
            style: const TextStyle(
              color: Colors.black,
              backgroundColor: Colors.yellow,
            ),
          ),
        );
      } else {
        textSpans.add(
          TextSpan(
            text: text[i],
            style: const TextStyle(color: Colors.black),
          ),
        );
      }
    }
    return TextSpan(children: textSpans);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Typing Test"),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: RichText(
                  text: getTextSpan(textToType, typedText),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          TextField(
            controller: _textController,
            textAlign: TextAlign.center,
            onChanged: checkInput,
            enabled: typedText.length < textToType.length,
            focusNode: _focusNode,
            autofocus: true,
          ),
        ],
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: NoAnimationTransitionBuilder(),
            TargetPlatform.iOS: NoAnimationTransitionBuilder(),
          },
        ),
      ),
      home: const TypingTestScreen(),
    );
  }
}

class NoAnimationTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

void main() {
  runApp(const MyApp());
}
