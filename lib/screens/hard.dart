import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class GuessTheWordHardScreen extends StatefulWidget {
  @override
  _GuessTheWordHardScreenState createState() => _GuessTheWordHardScreenState();
}

class _GuessTheWordHardScreenState extends State<GuessTheWordHardScreen> {
  static const List<String> words = [
    'kinaiya',
    'marahuyo',
    'kalinaw',
    'marilag',
    'alpas',
    'pahuyaw',
    'sapantaha',
    'samyo'
    'duyog',
    'balintataw'
  ];
  static const List<String> clues = [
    'Ito ay ang lahat ng mga katangian o katangian na gumagawa sa iyo kung sino ka.',
    'Maaari rin itong gamitin upang ipakita na ikaw ay naaakit sa isang tao.',
    'Ang salitang Hiligaynon na ito ay ang salita para dito, na nangangahulugang "ang estado ng pagiging mahinahon at payapa."',
    'Isang magandang salita para ilarawan ang isang bagay na maganda.',
    'Pagiging malaya o lumayas.',
    'Magpahinga​. Para huminto',
    'Ito ay isang mas malalim na salita para sa hula o hulaan.',
    'Ang salitang mas karaniwang ginagamit ay amoy.',
    'Isang okasyon kung saan ang araw ay mukhang ganap o bahagyang natatakpan ng isang madilim na bilog dahil ang buwan ay nasa pagitan ng araw at ng Earth.',
    'Isang butas na nasa gitna ng iris ng mata na nagpapahintulot ng pagpasok ng liwanag sa retina.',
  ];

  late String currentWord;
  late String currentClue;
  late List<String?> blanks;
  List<String> alphabet = 'abcdefghijklmnopqrstuvwxyz'.split('');

  int currentIndex = 0;
  late Timer _timer;
  int _secondsRemaining = 60;

  @override
  void initState() {
    super.initState();
    startNewGame();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startNewGame() {
    Random random = Random();
    int index = random.nextInt(words.length);
    setState(() {
      currentWord = words[index];
      currentClue = clues[index];
      blanks = List.generate(currentWord.length, (index) => null);
    });
  }

  void checkAnswer() {
    String userGuess = blanks.join('');
    if (userGuess == currentWord) {
      _timer.cancel(); // Pause the timer
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Congratulations!',
        text: 'You guessed the word correctly',
        confirmBtnText: 'New Word',
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
          startNewGame();
          _secondsRemaining = 60; // Reset the timer
          _startTimer(); // Restart the timer for the new game
        },
      );
    }
  }

  void updateBlanks(String letter) {
    setState(() {
      bool correctLetter = false;
      for (int i = 0; i < currentWord.length; i++) {
        if (currentWord[i] == letter) {
          blanks[i] = letter;
          correctLetter = true;
        }
      }
      if (!correctLetter) {
        _timer.cancel(); // Pause the timer
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Incorrect Letter',
          text: "Sorry, that letter is not in the word",
          confirmBtnText: 'OK',
          onConfirmBtnTap: () {
            Navigator.of(context).pop();
            _startTimer(); // Resume the timer
          },
        );
      } else {
        checkAnswer();
      }
    });
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (timer) {
        setState(() {
          if (_secondsRemaining < 1) {
            timer.cancel();
            handleTimeout();
          } else {
            _secondsRemaining--;
          }
        });
      },
    );
  }

  void handleTimeout() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      title: 'Timeout',
      text: 'You ran out of time!',
      confirmBtnText: 'OK',
      onConfirmBtnTap: () {
        Navigator.of(context).pop();
        setState(() {
          _secondsRemaining = 60; // Reset the timer
        });
        startNewGame();
        _startTimer(); // Restart the timer for the new game
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'Guess The Word',
          style: TextStyle(
            fontFamily: 'Quiapo',
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/back2.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2),
                  BlendMode.dstATop,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Time Remaining: $_secondsRemaining seconds',
                    style: TextStyle(fontSize: 18),
                  ),
                  Gap(50),
                  Text(
                    'Clue: $currentClue',
                    style: TextStyle(fontSize: 20),
                  ),
                  Gap(30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (String? blank in blanks)
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(),
                          child: Text(
                            blank ?? '__',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                    ],
                  ),
                  Gap(80),
                  Expanded(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        for (String letter in alphabet)
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ElevatedButton(
                              onPressed: () {
                                updateBlanks(letter);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                backgroundColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: Text(
                                letter,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
