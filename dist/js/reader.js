!function(){var a="a8f150d43aec60003889f014317dbbe73380925c62e72b4e672ff0ff6cc2326c",b="d48b3fb6162b5c0e06bca7047866a30e2fc8b85bc12a2d8f9a5a476d571e57cc",c=function(){var c=function(){d(),NCMB.User.logOut();var a="#TNK_CARD_FRAME {  position: fixed;  top: 0px; left: 0px;  width: 100%;  height: 100px;  background: #f0f0f0;  z-index: 2147483647;  border-bottom: solid 2px black;  text-align: center;} #TNK_CARD_FRAME .txt {  border: 2px inset;  margin: 0px;  padding: 1px;  background: white;} #TNK_CARD_FRAME .btn {  border: 1px solid;  border-radius: 4px;  margin: 0px;  padding: 4px 8px;  color: #333;  background-color: #fff;  border-color: #ccc;}",b='<div id="TNK_CARD_FRAME">  <form id="TNK_CARD_FORM">    <input type="text" id="TNK_CARD_FORM_ID" class="txt" placeholder="Login ID"><br>    <input type="password" id="TNK_CARD_FORM_PASSWORD" class="txt" placeholder="Password"><br>    <input type="submit" id="TNK_CARD_FORM_LOGIN_BTN" class="btn" value="Login">    <input type="button" id="TNK_CARD_FORM_CLOSE_BTN" class="btn" value="Close">  </form></div>',c=document.createElement("div");c.innerHTML='<style id="TNK_CARD_STYLE">'+a+"</style>"+b,document.body.appendChild(c),k("#TNK_CARD_FORM").submit(function(a){a.preventDefault();var b=k("#TNK_CARD_FORM_ID").val(),c=k("#TNK_CARD_FORM_PASSWORD").val();NCMB.User.logIn(b,c,{success:function(){d(),j()},error:function(a,b){alert("ログインできません["+b.code+"]"),console.log("error:"+b.message)}})}),k("#TNK_CARD_FORM_CLOSE_BTN").click(function(){d()})},d=function(){var a=document.getElementById("TNK_CARD_FRAME");a&&a.parentNode.removeChild(a)},e=function(){var a="",b=k("#cardDetailDialog");return 0!=b.size()&&"block"==b.css("display")&&(a=b.find("#cardActionList").attr("data-user-card-id"),"undefined"==typeof a&&(a="")),a},f=function(a){var b=a.match(/^([0-9]+)\/([0-9]+)(★*)$/);return{level:parseInt(b[1]),maxLevel:parseInt(b[2]),extendLevel:b[3].length}},g=function(a,b){var c=b.find(".cardName"),d=b.find(".cardSkill"),e=f(b.find(".cardLevelValue").text());return{cardId:a,name:c.attr("data-card-name"),nameKana:c.attr("data-kana-name"),rarity:c.attr("data-rarity"),region:b.find(".regionBackgroundColor").text(),level:e.level,maxLevel:e.maxLevel,extendLevel:e.extendLevel,cost:parseInt(b.find(".cardCost").text()),attack:parseInt(b.find(".cardAttackPt").text()),defence:parseInt(b.find(".cardDefencePt").text()),type:b.find(".cardType").text(),skill:d.attr("data-skill-description"),skillLevel:parseInt(d.attr("data-skill-level")),skillName:d.attr("data-skill-name"),skillTarget:d.attr("data-skill-target")}},h=function(a,b){var c=NCMB.Object.extend("Card"),d=NCMB.User.current(),e=[];a.forEach(function(a){for(var f=null,g=0;g<b.length;g++)if(b[g].get("cardId")==a.cardId){f=b[g];break}f||(f=new c),a.userName=d.get("userName"),f.set(a),f.set("user",d);var h=new NCMB.ACL;h.setReadAccess(d,!0),h.setWriteAccess(d,!0),f.setACL(h),e.push(f)}),NCMB.Object.saveAll(e,{success:function(){console.log("success"),alert("カード情報を送信しました")},error:function(a){console.log("error:"+a.code+" "+a.message),alert("error:"+a.code+" "+a.message)}})},i=function(a){var b=NCMB.Object.extend("Card"),d=NCMB.User.current(),e=new NCMB.Query(b);e.equalTo("user",d);var f=[];a.forEach(function(a){f.push(a.cardId)}),e.containedIn("cardId",f),e.find({success:function(b){console.log("Successfully retrieved "+b.length+" scores."),h(a,b)},error:function(a){console.log("error:"+a.code+" "+a.message),alert("error:"+a.code+" "+a.message),c()}})},j=function(){for(var a=e(),b=[],c=k(".resultCardList").children(),d=0;d<c.length;d++){var f=c.eq(d);if(-1==f.attr("class").indexOf("hidden")){var h=f.attr("data-user-card-id");if((""==a||h==a)&&(b.push(g(h,f)),h==a))break}}return console.log("read num:"+b.length),0==b.length?void alert("カードが見つかりません"):void i(b)},k=jQuery.noConflict(!0);NCMB.initialize(a,b),NCMB.User.current()?(console.log("login!"),j()):(console.log("not login!"),c())},d=function(a,b){var c=document.createElement("script");c.type="text/javascript",c.src=a,c.onload=b;var d=document.getElementsByTagName("head")[0]||document.documentElement;d.appendChild(c)};d("http://mb.cloud.nifty.com/sdk/javascript/ncmb-1.2.0.min.js",function(){d("//ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min.js",c)})}();