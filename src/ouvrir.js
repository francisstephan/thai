openDic = function (id) {
  copyTextToClipboard(id);
  var text = document.getElementById(id).innerHTML;
  // let result = text.replace(/ /g, "+");
  var chaine = "https://en.glosbe.com/th/en/" + text;
  window.open(chaine);
};
