void sendPD() {
  OscMessage myMessage = new OscMessage("/bang");
  myMessage.add("bang"); /* add an int to the osc message */
  oscP5.send(myMessage, puredata);
}