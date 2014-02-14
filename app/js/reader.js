/**
 * card info reader for Tenkuro
 */
(function() {

  var TNK_CARD_APP_KEY = "a8f150d43aec60003889f014317dbbe73380925c62e72b4e672ff0ff6cc2326c";
  var TNK_CARD_CLIENT_KEY = "d48b3fb6162b5c0e06bca7047866a30e2fc8b85bc12a2d8f9a5a476d571e57cc";

  /**
   * main
   */
  var main = function() {

    /**
     * ログインフォームを表示する
     */
    var loginForm = function() {

      removeLoginForm();
      
      NCMB.User.logOut();

      var shadowHeight = 20;
      var i = 80;
      var o = i;
      var s= 20;

      var lcss = "#TNK_CARD_FRAME {"
            + "  position: fixed;"
            + "  top: 0px; left: 0px;"
            + "  width: 100%;"
            + "  height: 100px;"
            + "  background: #f0f0f0;"
            + "  z-index: 2147483647;"
            + "  border-bottom: solid 2px black;"
            + "  text-align: center;"
            + "} "
            + "#TNK_CARD_FRAME .txt {"
            + "  border: 2px inset;"
            + "  margin: 0px;"
            + "  padding: 1px;"
            + "  background: white;"
            + "} "
            + "#TNK_CARD_FRAME .btn {"
            + "  border: 1px solid;"
            + "  border-radius: 4px;"
            + "  margin: 0px;"
            + "  padding: 4px 8px;"
            + "  color: #333;"
            + "  background-color: #fff;"
            + "  border-color: #ccc;"
            + "}";

      var lf = '<div id="TNK_CARD_FRAME">'
            + '  <form id="TNK_CARD_FORM">'
            + '    <input type="text" id="TNK_CARD_FORM_ID" class="txt" placeholder="Login ID"><br>'
            + '    <input type="password" id="TNK_CARD_FORM_PASSWORD" class="txt" placeholder="Password"><br>'
            + '    <input type="submit" id="TNK_CARD_FORM_LOGIN_BTN" class="btn" value="Login">'
            + '    <input type="button" id="TNK_CARD_FORM_CLOSE_BTN" class="btn" value="Close">'
            + '  </form>'
            + '</div>';

      var e = document.createElement("div");
      e.innerHTML = '<style id="TNK_CARD_STYLE">' + lcss + "</style>" + lf;
      document.body.appendChild(e);

      $('#TNK_CARD_FORM').submit(function(event) {
        event.preventDefault();

        var loginId = $('#TNK_CARD_FORM_ID').val();
        var loginPassword = $('#TNK_CARD_FORM_PASSWORD').val();

        NCMB.User.logIn(loginId, loginPassword, {
          success: function(user) {
            // 成功
            //alert("success");
            removeLoginForm();
            readCard();
          },
          error: function(user, error) {
            // エラー
            alert("ログインできません[" + error.code + "]");
            console.log("error:" + error.message);
          }
        });
      });

      $('#TNK_CARD_FORM_CLOSE_BTN').click(function() {
        removeLoginForm();
      });
    };

    /**
     * ログインフォームを消す
     */
    var removeLoginForm = function() {
      var e = document.getElementById("TNK_CARD_FRAME");
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
    var parseLevel = function(text) {
      var m = text.match(/^([0-9]+)\/([0-9]+)(★*)$/);
      return {"level": parseInt(m[1]), "maxLevel": parseInt(m[2]), "extendLevel": m[3].length};
    };

    /**
     * カード情報をオブジェクトに格納
     */
    var makeCardInfo = function(id, card) {
      var cardName = card.find('.cardName');
      var cardSkill = card.find('.cardSkill');

      var level = parseLevel(card.find('.cardLevelValue').text());

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
      var Card = NCMB.Object.extend("Card");

      var user = NCMB.User.current();

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

        var acl = new NCMB.ACL();
        acl.setReadAccess(user, true);
        acl.setWriteAccess(user, true);
        card.setACL(acl);

        list.push(card);
      });

      NCMB.Object.saveAll(list, {
          success: function(list) {
            console.log('success');
            alert('カード情報を送信しました');
          },
          error: function(error) {
            console.log('error:' + error.code + ' ' + error.message);
            alert('error:' + error.code + ' ' + error.message);
          }
      });
    };

    /**
     * カード情報をbackendに保存
     */
    var saveCard = function(sendData) {
      var Card = NCMB.Object.extend("Card");

      var user = NCMB.User.current();

      // 同じカードが登録されていないか検索
      var query = new NCMB.Query(Card);
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
          alert('error:' + error.code + ' ' + error.message);
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

        d.push(makeCardInfo(id, card));

        if (id == cdId) {
          // dialogに出しているカードなので終わり
          break;
        }
      }
      console.log('read num:' + d.length);
      //console.log(d);

      if (d.length == 0) {
        alert('カードが見つかりません');
        return;
      }

      saveCard(d);
    };

    var $ = jQuery.noConflict(true);

    NCMB.initialize(TNK_CARD_APP_KEY, TNK_CARD_CLIENT_KEY);

    if (NCMB.User.current()) {
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
    'http://mb.cloud.nifty.com/sdk/javascript/ncmb-1.2.0.min.js',
    function() {
      loadSync(
        "//ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min.js",
        main
      );
    }
  );

})();

