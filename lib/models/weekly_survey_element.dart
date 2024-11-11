class WeeklySurveyElement {
  Map<int, List<int>> answer;

  WeeklySurveyElement({
    required this.answer,
  });

  List<int> getAnswer(int weekNum) {
    return answer[weekNum]!;
  }

  void setAnswer(int weekNum, List<int> sl) {
    answer[weekNum] = sl;
  }

  bool isWeeklySurveyComplete(int week) {
    if (answer[week]!.contains(-1)) {
      return false;
    }
    return true;
  }

  // void setPhq(List<int> pq) {
  //   phq = pq;
  // }
}
