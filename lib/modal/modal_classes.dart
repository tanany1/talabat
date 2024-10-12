class Question {
  final String text;
  final List<Option> options;
  final int correctAnswerIndex;

  Question(this.text, this.options, this.correctAnswerIndex);
}

class Option {
  final String text;
  final String imagePath;

  Option(this.text, this.imagePath);
}