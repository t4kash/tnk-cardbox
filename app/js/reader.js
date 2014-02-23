/**
 * card info reader for Tenkuro
 */
(function() {

  var TNK_CARD_APP_ID = "4ofkpZSUMjDDFQowUnV7rrdTPb01XXhuKncyQt5b";
  var TNK_CARD_JS_KEY = "BSr5oeZvUrD3ZZZly8W170VQ81A9Q0stDU0f61iL";
  var TNK_CARD_URL = "http://tnkcb.parseapp.com/";

  /**
   * main
   */
  var main = function() {

    /**
     * メッセージFrameを表示する
     */
    var messagePanel = function(message, loading) {

      removeFrame();

      var lcss = "#TNK_CARD_FRAME {"
            + "  position: fixed;"
            + "  top: 0px; left: 0px;"
            + "  width: 100%;"
            + "  height: 90px;"
            + "  padding-top: 20px;"
            + "  background: #ffffff;"
            + "  z-index: 2147483647;"
            + "  border-bottom: solid 2px black;"
            + "  text-align: center;"
            + "} "
            + "#TNK_CARD_FRAME .btn {"
            + "  border: 1px solid;"
            + "  border-radius: 4px;"
            + "  margin: 5px;"
            + "  padding: 4px 8px;"
            + "  background-color: #fff;"
            + "  border-color: #ccc;"
            + "} "
            + "#TNK_CARD_FRAME .btn-warning {"
            + "  color: #fff;"
            + "  background-color: #f0ad4e;"
            + "  border-color: #eea236;"
            + "}";

      var lf = '<div id="TNK_CARD_FRAME">';

      if (loading) {
        lf = lf + '  <img src="' + TNK_CARD_URL + 'images/loading.gif">';
      }

      lf = lf + ' ' + message + '<br>'

      if (!loading) {
        lf = lf + ' <input type="button" id="TNK_CARD_FORM_CLOSE_BTN" class="btn btn-primary" value="閉じる">';
        lf = lf + ' <input type="button" id="TNK_CARD_FORM_LOGOUT_BTN" class="btn btn-warning" value="ログアウト">';
      }

      lf = lf + '</div>';

      var e = document.createElement("div");
      e.innerHTML = '<style id="TNK_CARD_STYLE">' + lcss + "</style>" + lf;
      document.body.appendChild(e);

      setTimeout(function(){
          window.scrollTo(0, window.pageYOffset + 1);
      }, 100);

      if (!loading) {
        $('#TNK_CARD_FORM_LOGOUT_BTN').click(function() {
          Parse.User.logOut();
          removeFrame();
        });

        setTimeout(function() {
          removeFrame();
        }, 3000);

        $('#TNK_CARD_FORM_CLOSE_BTN').click(function() {
          removeFrame();
        });
      }

    };

    /**
     * ログインフォームを表示する
     */
    var loginForm = function() {

      removeFrame();
      
      //Parse.User.logOut();

      var lcss = "#TNK_CARD_FRAME {"
            + "  position: fixed;"
            + "  top: 0px; left: 0px;"
            + "  width: 100%;"
            + "  height: 130px;"
            + "  padding-top: 10px;"
            + "  background: #f0f0f0;"
            + "  z-index: 2147483647;"
            + "  border-bottom: solid 2px black;"
            + "  text-align: center;"
            + "} "
            + "#TNK_CARD_FRAME .txt {"
            + "  border: 2px inset;"
            + "  margin: 2px;"
            + "  padding: 4px;"
            + "  background: white;"
            + "} "
            + "#TNK_CARD_FRAME .btn {"
            + "  border: 1px solid;"
            + "  border-radius: 4px;"
            + "  margin: 5px;"
            + "  padding: 4px 8px;"
            + "  color: #333;"
            + "  background-color: #fff;"
            + "  border-color: #ccc;"
            + "} "
            + "#TNK_CARD_FRAME .btn-primary {"
            + "  color: #fff;"
            + "  background-color: #428bca;"
            + "  border-color: #357ebd;"
            + "} "
            + "#TNK_CARD_FRAME .btn-warning {"
            + "  color: #fff;"
            + "  background-color: #f0ad4e;"
            + "  border-color: #eea236;"
            + "}";

      var lf = '<div id="TNK_CARD_FRAME">'
            + '  <form id="TNK_CARD_FORM">'
            + '    <input type="text" id="TNK_CARD_FORM_ID" class="txt" placeholder="Login ID"><br>'
            + '    <input type="password" id="TNK_CARD_FORM_PASSWORD" class="txt" placeholder="Password"><br>'
            + '    <input type="submit" id="TNK_CARD_FORM_LOGIN_BTN" class="btn btn-primary" value="ログイン">'
            + '    <input type="button" id="TNK_CARD_FORM_CLOSE_BTN" class="btn btn-warning" value="閉じる">'
            + '  </form>'
            + '</div>';

      var e = document.createElement("div");
      e.innerHTML = '<style id="TNK_CARD_STYLE">' + lcss + "</style>" + lf;
      document.body.appendChild(e);

      setTimeout(function(){
          window.scrollTo(0, window.pageYOffset + 1);
      }, 100);

      $('#TNK_CARD_FORM').submit(function(event) {
        event.preventDefault();

        $('#TNK_CARD_FORM_LOGIN_BTN').attr('disabled', true);

        var loginId = $('#TNK_CARD_FORM_ID').val();
        var loginPassword = $('#TNK_CARD_FORM_PASSWORD').val();

        Parse.User.logIn(loginId, loginPassword, {
          success: function(user) {
            // 成功
            removeFrame();
            readCard();
          },
          error: function(user, error) {
            // エラー
            $('#TNK_CARD_FORM_LOGIN_BTN').attr('disabled', false);
            if (error.code == Parse.Error.OBJECT_NOT_FOUND) {
              alert('IDもしくはパスワードのエラー');
            } else {
              alert('ログインできません:' + error.code);
              console.log(error);
            }
          }
        });
      });

      $('#TNK_CARD_FORM_CLOSE_BTN').click(function() {
        removeFrame();
      });
    };

    /**
     * 表示パネルを消す
     */
    var removeFrame = function() {
      var e = document.getElementById("TNK_CARD_FRAME");
      if (e) {
        e.parentNode.removeChild(e);
      }
      e = document.getElementById("TNK_CARD_STYLE");
      if (e) {
        e.parentNode.removeChild(e);
      }
    };

    /**
     * 詳細ダイアログを開いているか
     */
    var findDetailDialog = function() {
      var cdId = '';
      var cd = $('#cardDetailDialog');
      if (cd.size() != 0 && cd.css('display') == 'block') {
        cdId = cd.find('#cardActionList').attr('data-user-card-id');
        if (typeof cdId === 'undefined') {
          cdId = '';
        }
      }

      return cdId;
    };

    /**
     * Level関連のパース
     */
    var parseLevel = function(cardLevel) {
      var m = cardLevel.text().match(/^([0-9]+)\/([0-9]+)(★*)$/);
      var extendLevel = cardLevel.find('.white').text().length;
      console.log(cardLevel.find('.white').text());
      return {"level": parseInt(m[1]), "maxLevel": parseInt(m[2]), "extendLevel": extendLevel};
    };

    /**
     * カード情報をオブジェクトに格納
     */
    var makeCardInfo = function(id, card) {
      var cardName = card.find('.cardName');
      var cardSkill = card.find('.cardSkill');

      var level = parseLevel(card.find('.cardLevelValue'));

      return {
        "cardId": id,
        "name": cardName.attr('data-card-name'),
        "nameKana": cardName.attr('data-kana-name'),
        "rarity": cardName.attr('data-rarity'),
        "region": card.find('.regionBackgroundColor').text(),
        "level": level.level,
        "maxLevel": level.maxLevel,
        "extendLevel": level.extendLevel,
        "cost": parseInt(card.find('.cardCost').text()),
        "attack": parseInt(card.find('.cardAttackPt').text()),
        "defence": parseInt(card.find('.cardDefencePt').text()),
        "type": card.find('.cardType').text(),
        "skill": cardSkill.attr('data-skill-description'),
        "skillLevel": parseInt(cardSkill.attr('data-skill-level')),
        "skillName": cardSkill.attr('data-skill-name'),
        "skillTarget": cardSkill.attr('data-skill-target'),
      };
    };

    /**
     * カード保存処理
     */
    var _saveCard = function(sendData, existsData) {
      var Card = Parse.Object.extend("Card");

      var user = Parse.User.current();

      var list = [];
      sendData.forEach(function(data) {

        var card = null;
        for (var i = 0; i < existsData.length; i++) {
          if (existsData[i].get("cardId") == data.cardId) {
            card = existsData[i];
            break;
          }
        }
        if (!card) {
          card = new Card();
        }

        data.userName = user.get("userName");

        card.set(data);
        card.set("user", user);

        var acl = new Parse.ACL(user);
        //acl.setReadAccess(user, true);
        //acl.setWriteAccess(user, true);
        card.setACL(acl);

        list.push(card);
      });

      Parse.Object.saveAll(list, {
          success: function(list) {
            console.log('success');
            messagePanel('送信完了!!!', false);
          },
          error: function(error) {
            console.log('error:' + error.code + ' ' + error.message);
            messagePanel('エラーが発生しました:' + error.code);
          }
      });
    };

    /**
     * カード情報をbackendに保存
     */
    var saveCard = function(sendData) {

      // パネル表示
      messagePanel(sendData.length + "件のカード情報を送信しています", true);

      var Card = Parse.Object.extend("Card");

      var user = Parse.User.current();

      // 同じカードが登録されていないか検索
      var query = new Parse.Query(Card);
      query.limit(1000);
      query.equalTo("user", user);
      var cardList = [];
      sendData.forEach(function(data) {
        cardList.push(data.cardId);
      });
      query.containedIn("cardId", cardList);
      query.find({
        success: function(results) {
          console.log("Successfully retrieved " + results.length + " scores.");
          // 登録
          _saveCard(sendData, results);
        },
        error: function(error) {
          // エラー
          console.log('error:' + error.code + ' ' + error.message);
          alert('エラーが発生しました:' + error.code);
          loginForm();
        }
      }); 
    }

    /**
     * カード読み取りと送信処理
     */
    var readCard = function() {

      // カード詳細Dialogを出しているか
      var cdId = findDetailDialog();

      var d = [];
      var cards = $('.resultCardList').children();
      for (var i = 0; i < cards.length; i++) {
        var card = cards.eq(i);

        if (card.attr('class').indexOf('hidden') != -1) {
          // hidden card
          continue;
        }

        var id = card.attr('data-user-card-id');
        if (cdId != '' && id != cdId) {
          // dialogに出しているカードと違う
          continue;
        }

        var cardInfo = makeCardInfo(id, card);

        if (cdId == '' && cardInfo.level == 1) {
          // レベル1のカードは除く
          continue;
        }

        d.push(cardInfo);

        if (id == cdId) {
          // dialogに出しているカードなので終わり
          break;
        }
      }
      console.log('read num:' + d.length);
      //console.log(d);

      if (d.length == 0) {
        alert('カード情報が見つかりません');
        return;
      }

      saveCard(d);
    };

    var $ = jQuery.noConflict(true);

    Parse.initialize(TNK_CARD_APP_ID, TNK_CARD_JS_KEY);

    if (Parse.User.current()) {
      console.log('login!');
      readCard();
    } else {
      console.log('not login!');
      loginForm();
    }

  };

  /**
   * 外部jsファイルの読み込み
   */
  var loadSync = function(src, f) {
    var s = document.createElement('script');
    s.type = 'text/javascript';
    s.src = src;
    s.onload = f;
    var o = document.getElementsByTagName('head')[0] || document.documentElement;
    o.appendChild(s);
  };

  loadSync(
    TNK_CARD_URL + 'js/parse-1.2.16.js',
    function() {
      loadSync(
        "//ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min.js",
        main
      );
    }
  );

})();

