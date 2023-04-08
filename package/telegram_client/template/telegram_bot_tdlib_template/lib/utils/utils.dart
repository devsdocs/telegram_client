int parserBotUserIdFromToken(dynamic token_bot) {
  try {
    return int.parse(token_bot.split(":")[0]);
  } catch (e) {
    return 0;
  }
}
