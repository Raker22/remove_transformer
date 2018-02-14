// This illustrates how remove affects code

main() {
  // This print will be changed in release
  print('Hello Debug'); /* remove:line
  print('Hello Release');
  remove:start */
  print('This line is for debug only!!!');
  // remove:end
}
