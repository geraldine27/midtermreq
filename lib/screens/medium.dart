import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class GuessTheWordMediumScreen extends StatefulWidget {
  @override
  _GuessTheWordMediumScreenState createState() =>
      _GuessTheWordMediumScreenState();
}

class _GuessTheWordMediumScreenState extends State<GuessTheWordMediumScreen> {
  static const List<String> words = [
    'yugto',
    'balakid',
    'silakbo',
    'hiraya',
    'takipsilim',
    'bukangliwayway',
    'wangis',
    'huwad',
    'ikubli',
    'kalinga'
  ];
  static const List<String> clues = [
    'Maaari rin itong isang parte sa iyong buhay o isang panahon ng pag-unlad.',
    'Ang isang bagay na humaharang o humahadlang sa iyong kasiyahan.',
    'Ito ay isang pakiramdam na napakalakas at madamdamin na hinihiling na ilabas.',
    'Ito ay ang kakayahan ng ating isip na lumikha o mag-isip ng isang bagay na wala.',
    'Dapithapon, gabi',
    'Paglubog ng araw',
    'Ang mas matandang salitang Tagalog na ito ay nangangahulugang "hitsura" o "hitsura."',
    'nangangahulugang "peke."',
    'Itago',
    'isang salitang Filipino na nangangahulugang "pag-aalaga."',
  ];

  late String currentWord;
  late String currentClue;
  late List<String?> blanks;
  List<String> alphabet = 'abcdefghijklmnopqrstuvwxyz'.split('');

  int currentIndex = 0;
  late Timer _timer;
  int _secondsRemaining = 45;

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
          _secondsRemaining = 45; // Reset the timer
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
          _secondsRemaining = 45; // Reset the timer
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
