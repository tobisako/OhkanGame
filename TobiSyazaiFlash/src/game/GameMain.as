package game {
	//import fl.video.VideoAlign;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	//import caurina.transitions.Tweener;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import parts.SoundParts;
	import parts.SoundPartsDamage;

	/**
	 * ...
	 * @author tobisako
	 */
	public class GameMain extends Sprite
	{
	//	[Embed(source = "se/decide1.wav", mimeType = "application/octet-stream")] private var se_notta:Class;
	//	[Embed(source = "se/se_damage.mp3")] private var se_damage:Class;
		[Embed(source = "img/bg_gameback.png")] private var e_bg:Class;
		[Embed(source = "img/btn_play.png")] private var e_play:Class;
		//[Embed(source = "img/g_abe.png")] private var emb01:Class;
		private var cb_DamageCallback:Function;		// ダメージを受けた際のコールバック
		private var cb_GameEndCallback:Function;	// ゲーム終了コールバック
		private var btn_start:Sprite;
		private var img_bg:Bitmap;			// 背景画像
		private var abe:PartsSpriteAbe;
		private var megami:PartsSpriteMegami;			// 自由の女神
		private var big_kokeshi:PartsSpriteBigKokeshi;	// 巨大こけし
		private var remainingtime:int;
		private var framecnt:uint;
		private var bIsPlaying:Boolean;				// ゲーム進行中フラグ
		private var hai:Vector.<PartsSpriteBase>;
		private var cnttxt:TextField;
		private var txt:TextField;
		private var contdowntimer:Timer;
		private var lefttime:int;
		private var bIsWaitAddToStage:Boolean;
		private var fGameClear:Boolean;		// ゲームクリアフラグ（王冠１０個つみあがった）
		private var life:int;				// ライフ数
		private var s0:SoundParts;
		private var s1:SoundParts;
		private var s2:SoundParts;
		private var s3:SoundParts;

		[Embed(source = "../game/se/se_damage.mp3")] private var s_damage:Class;
		
		// コンストラクタ
		public function GameMain() 
		{
			bIsWaitAddToStage = true;

			// サウンド生成
			s0 = new SoundParts( 0 );	// ゲームプレイ中ＢＧＭ
			s1 = new SoundParts( 1 );	// 王冠が頭の上に乗った音
			s2 = new SoundParts( 2 );	// ダメージ音
			s3 = new SoundParts( 7 );	// ボウリング・ピン音

			//　ゲーム背景を設定。これがフィールドになる
			img_bg = new e_bg() as Bitmap;

			// 自由の女神・設定
			megami = new PartsSpriteMegami();

			// 巨大こけし・設定
			big_kokeshi = new PartsSpriteBigKokeshi();

			// 阿部設定
			abe = new PartsSpriteAbe(img_bg.width, img_bg.height);

			// ゲーム開始（再生）ボタン
			btn_start = new Sprite();
			btn_start.addChild( new e_play() as Bitmap );
			btn_start.x = img_bg.width / 2 - (btn_start.width / 2);
			btn_start.y = img_bg.height / 2 - (btn_start.height / 2);

			// カウントダウンタイマー設定
			cnttxt = new TextField();
			cnttxt.x = img_bg.width - 180;
			cnttxt.y = 20;
			var fm:TextFormat = new TextFormat();
			fm.size = 144;
			cnttxt.defaultTextFormat = fm;
			cnttxt.width = 200;
			cnttxt.height = 200;
			cnttxt.text = "95";
			cnttxt.textColor = 0x00ffffff;

			// デバッグ用テキスト生成
			txt = new TextField();
			txt.x = 20;
			txt.y = img_bg.height - 30;
			var fm2:TextFormat = new TextFormat();
			fm2.size = 20;
			txt.defaultTextFormat = fm2;
			txt.text = "HELLO";
			txt.textColor = 0x00999999;

			// 動的配列の生成
			hai = new Vector.<PartsSpriteBase>();

			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}

		// addChild()された時に呼び出されるコールバック
		private function addedToStage(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			// Event.REMOVED_FROM_STAGE
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

			addChild( img_bg );

			// ゲーム背景をマスキングする
			var mask_sp:Sprite = new Sprite();
			var r_sp:Sprite = new Sprite();
			r_sp.graphics.beginFill(0x999999);
			r_sp.graphics.drawRect(0, 0, img_bg.width, img_bg.height);
			r_sp.graphics.endFill();
			mask_sp.addChild(r_sp);
			addChild(mask_sp);
			this.mask = mask_sp;

			addChild( abe );
			addChild( megami );
			addChild( big_kokeshi );
			addChild( btn_start );
			addChild(cnttxt);
			addChild(txt);

			// キーボード・コールバック（デバッグ用）
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyEvent);

			// ゲーム初期化（まだ接続できていなかった場合）
			if (bIsWaitAddToStage) initGame();
			bIsWaitAddToStage = false;
		}

		// ゲーム初期化処理
		public function initGame():void {
			// 接続を待つ
			while ( bIsWaitAddToStage ) return;	// 後で実行する

			// フレーム用リスナー登録
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);

			// 主人公キャラ座標初期化
			abe.x = img_bg.width / 2;
			abe.y = 780;	// 330;		//  780;

			// 自由の女神・座標初期化
			megami.initPosition();

			// 巨大こけし・座標初期化
			big_kokeshi.initPosition();

			// パラメータ初期化
			remainingtime = 90;		// のこり３０秒→90秒
			bIsPlaying　 = false;	// ゲーム開始フラグ
			fGameClear = false;		// ゲームクリアフラグ
			life = 3;				// 残ライフ３．

			// ゲームスタートボタン表示
			btn_start.visible = true;
			btn_start.addEventListener(MouseEvent.CLICK, onGameStart);
			
			// ゲームＢＧＭ再生開始
			s0.play();

			// マウス検知コールバック
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
		}

		// （デバッグ用）キーボードコールバック
		private function onKeyEvent(e:KeyboardEvent):void
		{
			if (e.keyCode == 37) doMoveAction(false);
			else if (e.keyCode == 39) doMoveAction(true);
		}

		// ゲーム終了時処理
		public function leaveGame():void {
		}
		
		private var test:PartsSpriteOhkan;

		// ゲームスタート処理
		public function onGameStart(e:Event):void {
			bIsPlaying　 = true;
			btn_start.visible = false;	// スタートボタンを消す
			// ３０秒カウントダウンタイマー起動
			lefttime = 95;						// のこり３０秒→90秒
			cnttxt.text = "" + lefttime;		// 画面表示更新
			contdowntimer = new Timer(1000);
			contdowntimer.addEventListener(TimerEvent.TIMER, onGameTimeCountDown);
			contdowntimer.start();

			cnt_megami = 0;
			cnt_big_kokeshi = 0;
			cnt_ohkan = 0;
			cnt_kokeshi = 0;
		}

		// ゲーム・カウントダウン・コールバック
		private function onGameTimeCountDown(te:TimerEvent):void {
			if (fGameClear) return;		// ガード処理

			lefttime --;

			cnttxt.text = "" + lefttime;	// 画面表示更新
			if (lefttime <= 0) {
				trace( "onTimeUP" );
				// タイムアップ！
				contdowntimer.stop();
				contdowntimer = null;
				// ゲームオーバー判定を行い、画面表示する。	※動画音声を再生するといいかも！
				// 中途半端でごめんなさい！
				cb_GameEndCallback( 2 );
				bIsPlaying = false;
				return;
			}
			//contdowntimer.start();
		}

		// 回転対応のBitmapData作成
		private function createBitmapData(src:DisplayObject):Object
		{
			var rect:Rectangle = src.getBounds(this);
			var matrix:Matrix = src.transform.matrix;
			matrix.tx = src.x - rect.x;
			matrix.ty = src.y - rect.y;
 
			var bd:BitmapData = new BitmapData(rect.width, rect.height, true, 0x0);
			bd.draw(src, matrix);
			return {"bd":bd, "rect":rect};
		}

		private var hoge:int = 0;
		private var cnt_megami:int;
		private var cnt_big_kokeshi:int;
		private var cnt_ohkan:int;
		private var cnt_kokeshi:int;
		private var toggle:Boolean;

		// フレーム・コールバック（メインループ）
		private function onEnterFrame(e:Event):void 
		{
			if ( fGameClear ) return;
			if (!bIsPlaying) return;
			framecnt++;


			if ( toggle ) {
				// 自由の女神ＭＯＶＥ処理
				cnt_megami++;
				if (cnt_megami > 96) {
					if ( !big_kokeshi.isActive ) {
						var rnd:int = Math.random() * 3;
						megami.playTwinner( rnd );
						cnt_big_kokeshi = 0;
						toggle = false;
					}
				}
			} else {
				// 巨大こけしアクション処理
				cnt_big_kokeshi++;
				if (cnt_big_kokeshi > 110) {
					if ( !megami.isActive ) {
						big_kokeshi.playTwinner();
						cnt_megami = 0;
						toggle = true;
					}
				}
			}

			// ボタン同時押し対策を、画面遷移に組み込む事！
			// おそらく大丈夫だと思うが、
			// 少しでも非同期処理がはさまっていると可能性があるので注意だっぜ。
			// 	遷移部の処理だけでなんとか逃れられないだろうか？
			//	すなわち、画面遷移時に、前回の遷移を覚えておいて、

			// 王冠発生処理
			//if ((framecnt % 40) == 0) {		// 20フレームに１回落ちてくる。
			if (cnt_ohkan == 20) {
				var spd:Number = Math.random() * 3.5 + 4.5;
				var tmp:PartsSpriteOhkan = new PartsSpriteOhkan(img_bg.width, img_bg.height, spd);
				tmp.y = - tmp.height;
				tmp.x = Math.random() * (img_bg.width - tmp.width);
				//trace("Drop OHKAN.");
				hai.push( tmp );
				addChildAt( tmp, 3 );
				cnt_ohkan = 0;
			}
			cnt_ohkan++;

			// こけし（小）発生処理
			//if ((framecnt % 130) == 0) {
			if (cnt_kokeshi == 30) {
				var spd2:Number = Math.random() * 4.5 + 1.5;
				var tmp2:PartsSpriteKokeshi = new PartsSpriteKokeshi(img_bg.width, img_bg.height, spd2);
				tmp2.y = 50;	//  - tmp2.height;
				tmp2.x = Math.random() * (img_bg.width - tmp2.width);
				hai.push( tmp2 );
				addChild( tmp2 );
				cnt_kokeshi = 0;
			}
			cnt_kokeshi++;

			// 女神・ヒットポイント更新
			megami.doMove();
			megami.createHitBitmapData(this);
			// 巨大こけし・ヒットポイント更新
			big_kokeshi.doMove();
			big_kokeshi.createHitBitmapData(this);

			// 配列ループ：
			var len:int = hai.length;	// 高速化
			var delindex:int = -1;
			for (var i:int = 0; i < len; i++) {
				var sb:PartsSpriteBase;
				sb = hai[i];

				// オブジェクトが画面外から消えたかチェック
				if (sb.checkOutOfScreen()) {
					//removeChild( sb );			// ステージから降ろす
					//hai.splice( i, 1 );			// 配列からアイテムを削除。
					delindex = i;
					continue;
				}

				// オブジェクトの種類別に処理を切り分ける
				if ( hai[i] is PartsSpriteOhkan ) {
					var oh:PartsSpriteOhkan = hai[i] as PartsSpriteOhkan;

					// 王冠がマウント出来る状態の時のみ、判定処理を実行する
					if (oh.isOhkanMode() == 0) {		// 王冠がプレイヤーの上に積みあがるか判定
						if ( abe.onMountCheck( sb ) ) {	// 積み上げる処理も実施する。
							var aa:int;
							aa = abe.checkOnMountObjectNum();
							//trace( "aa = [" + aa + "]!!!!!!!!!!!!!!!" );

							if ( aa == 11 ) {	// 自分を含め１１個→１０個積みあがった！
							//if ( aa == 0 ) {	// 自分を含め１１個→１０個積みあがった！
								
								fGameClear = true;	// ゲームクリア！！
								contdowntimer.stop();
								cb_GameEndCallback( 0 );
								//s3.play();		// ゲームクリア音
							} else {
								s1.play();		// 王冠かぶりますた音
							}
							continue;	// 効果音とか付ける
						}
					}//	var p:Point = hai[i].getMountingPoint();//	txt.text = "rec px=" + p.x + ", py=" + p.y;
				
					// 王冠の状態をチェック
					if (oh.isOhkanMode() != 2) {
						// 巨大こけしチェック
						if (big_kokeshi.onHitCheckPoint( this, oh.x, oh.y ) ) {
							//trace( "HIT!! kokeshi x=" + oh.x + ", y=" + oh.y + ", mouseX=" + mouseX + ", mouseY=" + mouseY );
							if(oh.isOhkanMode() == 1) s3.play();
							oh.dropOutMe();		// setOhkanMode( 2 );		//　くるくるまわるはず
							continue;
						}

						//var xx:Number = mouseX;
						//var yy:Number = mouseY;
					
						// 自由の女神チェック
						if (megami.onHitCheckPoint( this, oh.x, oh.y) ) {
						//if (megami.onHitCheckPoint( mouseX, mouseY ) ) {
							//txt.text = "[true] x=" + sb.x + ", y=" + sb.y;
							if(oh.isOhkanMode() == 1) s3.play();
							oh.dropOutMe();		//  setOhkanMode( 2 );		//　くるくるまわるはず
							continue;
						}// megamiTest( sb.x, sb.y );
					}
				} else if ( hai[i] is PartsSpriteKokeshi ) {
					var koke:PartsSpriteKokeshi = hai[i] as PartsSpriteKokeshi;

					// 阿倍ちゃんとのあたり判定チェック（負荷を下げるための特別処理）
					if ( abe.y < koke.y && (abe.y + abe.height) > koke.y ) {
						//if ( (abe.x - abe.width / 2) < koke.x && (abe.x + abe.width / 2) > koke.x) {
						if ( (abe.x - (abe.width >> 1)) < koke.x && (abe.x + (abe.width >> 1)) > koke.x) {
							//trace( "hit" );
							if ( koke.mode != 2) {
								// ダメージを受ける
								cb_DamageCallback();

								life　--;

								s2.play();
								if ( life == 0 ) {	// ゲームオーバー
									if ( abe.checkOnMountObjectNum() > 9 ) {
										// もう一息でごめんなさい！
										cb_GameEndCallback( 1 );
									} else {
										// 難しすぎてごめんなさい！
										cb_GameEndCallback( 3 );
									}
									contdowntimer.stop();	// タイマー停止
									bIsPlaying = false;
								}
							}
							koke.dropOutMe();
						}
					}
				}

				// 王冠移動処理を実行（一番最後に実施する事
				//(PartsSpriteOhkan)(sb).doMove();	// 落下したり、くるくるまわってはじけ飛んだり・・・。
				hai[i].doMove();
			}

			// １フレームに最大１個だけ、アイテム排除する事にする（高速化）
			if ( delindex != -1 ) {
				removeChild( hai[delindex] );	// ステージから降ろす
				hai.splice( delindex, 1 );		// 配列からアイテムを削除。
			}

			// 阿倍サダオ移動			// 王冠ズを阿部サダヲに追従させる
			abe.doMove( dx );
			dx = 0;

			// つまり、連結中の奴は、連結アクションを起こす必要があるので、
			// この「メインループ」では、判断しない事になる。
			// 自分の真上の王冠がどれかだけを記録し、あとは、伝達させる。
			//　その「伝達」は、王冠クラス内部でやらせる。

			// デバッグ用：
			// 女神がタップされた時に光る処理
			if (bMegami) {
				if (bDrawed) megami.filters = [new GlowFilter(0xFFFFFF, 1, 8, 8)];
				bDrawed = true;
				cnt++;
				if (cnt == 10) {
					bMegami = false;
					bDrawed = false;
					cnt = 0;
				}
			} else {
				if (bDrawed) megami.filters = [];
				bDrawed = true;
			}

			// リスト数を表示する
			txt.text = "list=[" + hai.length + "]";
		}
		private var bMegami:Boolean;
		private var bDrawed:Boolean;
		private var cnt:int;

		// マウスボタンおした時（テスト）
		private function onMouseEvent(me:MouseEvent):void {
			if (megami.onHitCheckPoint( this, mouseX, mouseY) ) {
				bMegami = true;
				bDrawed = false;
			}
		}

		// 女神ヒットテスト・
		private function megamiTest(xxx:Number, yyy:Number):void
		{
		//	target.rotation++;

		//	xxx = mouseX;
		//	yyy = mouseY;
		//	player.x = mouseX;
		//	player.y = mouseY;
 
		//	var bdTargetObj:Object = createBitmapData(target);
		//	var bdPlayerObj:Object = createBitmapData(player);
 
		//	var bdTarget:BitmapData = bdTargetObj.bd;
		//	var bdPlayer:BitmapData = bdPlayerObj.bd;
 
		//	if (bdTarget.hitTest(new Point(bdTargetObj.rect.x, bdTargetObj.rect.y), 0xFF, bdPlayer, new Point(bdPlayerObj.rect.x, bdPlayerObj.rect.y), 0xFF))
		//	{
		//		target.filters = [new GlowFilter(0xFFFFFF, 1, 8, 8)];
		//	}
		//	else
		//	{
		//		target.filters = [];
		//	}
			
			// 女神のあたり判定を作ってみる。
			var b:Boolean;
		//	var p:Point = globalToLocal( new Point( oh.x, oh.y ) );
		
			var bdTarget2Obj:Object = createBitmapData( megami );	// 女神ターゲット
			var bdTarget2:BitmapData = bdTarget2Obj.bd;

			b = bdTarget2.hitTest(new Point(bdTarget2Obj.rect.x, bdTarget2Obj.rect.y),
									0xFF,
		//							new Point(player.x, player.y));			
			//						new Point(mouseX, mouseY));			
									new Point(xxx, yyy));			
			txt.text = "[" + b + "]";
			
			// 女神上にマウスが重なると、フィルターを発動する。
			if (b) {
				megami.filters = [new GlowFilter(0xFFFFFF, 1, 8, 8)];
				trace("mouseX=" + mouseX + ", mouseY=" + mouseY + ", xxx=" + xxx + ", yyy=" + yyy );
			} else {
				megami.filters = [];
			}

		//	me2.rotation += 0.2;
		//	if (me2.rotation >= 40) me2.rotation = 0;
		//	me.x += 1;
			
			// 参考ＵＲＬ：
			// http://www40.atwiki.jp/spellbound/pages/2121.html
			// http://www40.atwiki.jp/spellbound/pages/2123.html
			// http://www40.atwiki.jp/spellbound/pages/2125.html
		}
		///////////////////////////////////////////////////////////////

		private var dx:int;

		// ボタン押下時の処理 false=左、true=右
		public function doMoveAction(b:Boolean):void {
			dx = (b) ? 20 : -20;
		//	abe.x += (b) ? 10 : -10;		// 主人公を左右に移動させる
		}
		// 主人公は、やる気があれば「超高速移動」も可能。

		private var bDoMegami:Boolean;
		
		// 「自由の女神」アクション
		private function moveMegami():void {
			
			// 女神ヒットテスト
			txt.text = "megami";
			
		}

		///////////////////////////////////////////////////////////////
		// 画面遷移系処理

		// ダメージを受けた際のコールバック受取
		public function setDamageCallback(f:Function):void {
			cb_DamageCallback = f;
		}
		
		// ダメージを受けた際のコールバック受取
		public function setGameEndCallback(f:Function):void {
			cb_GameEndCallback = f;
		}

		// ステージからＲＥＭＯＶＥされた時のイベント（後処理）
		private function onRemovedFromStage(e:Event):void {
			trace("RemovedFromStage!(GameMain)");
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			// サウンド停止
			s0.stop();
			s1.stop();
			s2.stop();
//			s3.stop();

			// タイマークリア
			if (contdowntimer != null) {
				contdowntimer.stop();
				contdowntimer = null;	// 解放（ガーベージコレクション対象にする）
			}
		}
		// タイマーは、オブジェクトが参照を失った後も動いている可能性あり。
		// なので、コールバック内では、自分の参照がない（ＮＵＬＬ）にも関わらず、
		// このコールバックが呼び出される可能性がある。
		// ＣＢ内部では必ず、「nullかどうか」をチェックする事。
	}
}

// 参考ＵＲＬ：[ActionScript 3.0] ビットマップの非透明部分のみでマウスイベントを受け取る方法
// http://syake-labo.com/blog/2012/01/as3-bitmaphittest/

// 参考ＵＲＬ：ポリモーフィズム
// http://www.atmarkit.co.jp/ait/articles/0805/13/news149_2.html
// http://itpro.nikkeibp.co.jp/article/COLUMN/20070802/278909/

// 参考ＵＲＬ：インターフェース
// http://n2works.net/frontend.php/column/pickup/id/42

// 参考ＵＲＬ：Flashで怒涛のごときイベント処理を捌きまくる3技 (2/3)
// http://www.atmarkit.co.jp/ait/articles/1007/22/news109_2.html

// 参考ＵＲＬ：ＭＰ４．http://ameblo.jp/5min-programming/entry-11075310670.html
