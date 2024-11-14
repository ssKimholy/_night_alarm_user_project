class WeeklySurveyElement {
  int weekNum;
  List<int> answerList;

  WeeklySurveyElement({
    required this.weekNum,
    required this.answerList,
  });

  int get getWeekNum => weekNum;
  List<int> get getAnswerList => answerList;

  void setAnswerList(List<int> list) {
    answerList = list;
  }
  // void setPhq(List<int> pq) {
  //   phq = pq;
  // }
}
