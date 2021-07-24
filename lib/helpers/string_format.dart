String betterString(String str) {
  bool found = false;
  String finalStr = "";

  for (int i = 0; i < str.length; i++) {
    if (!found && str[i] != '-') {
      finalStr += str[i].toUpperCase();
      found = true;
    } else if (str[i] == '-') {
      finalStr += ' ';
      found = false;
    } else {
      finalStr += str[i];
    }
  }

  return finalStr;
}
