package scene {
	//import fl.video.FLVPlayback;
	//import fl.video.VideoEvent;
	import flash.automation.AutomationAction;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	//import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.utils.getQualifiedClassName;
	import flash.utils.Timer;
	import parts.DogetherButtonParts;
	//import parts.VideoFLVPlaybackParts;
	import parts.VideoPlayWindowParts;
	import caurina.transitions.Tweener;

	/**
	 * 謝罪の王様：オープニング
	 * @author tobisako
	 */
	public class SceneSpriteOpening extends AqtorScreenTransSprite implements AqtorScreenTransSpriteInterface
	{
		private var st:AqtorScreenTransition;
		private var s_logo:SceneSpriteAqtorLogo;
		private var se01:Sound;
		private var btn_game:DisplayObject;
		private var btn_soudan:DisplayObject;
		private var btn_yokoku:DisplayObject;
		//private var btn_doge:DisplayObject;
		private var spinningLight:DisplayObject;
		private var spinningLight2:SpinningLight;

		private var s_08:Opening;
		private var s_12:Telop;
		private var s_13:Opening2;
		private var s_20:DogezaAnime;
		private var s_21:MainMovie;
		private var s_30l:LeftDogezing;
		private var s_30r:RightDogezing;
		private var btn_doge:DogetherButtonParts;

		private var vp1:VideoPlayWindowParts;	// VideoFLVPlaybackParts;		// 特殊ビデオパーツ
		private var vp2:VideoPlayWindowParts;	//  FLVPlayback;
		private var vp3:VideoPlayWindowParts;	//  FLVPlayback;
		private var timer1:Timer;
		private var timer2:Timer;

		// コンストラクタ（起動時１回しか呼び出されない）
		public function SceneSpriteOpening(st:AqtorScreenTransition) 
		{
			this.st = st;
			s_logo = new SceneSpriteAqtorLogo();	// ＡＱスプラッシュ画面
			vp1 = new VideoPlayWindowParts();		// ビデオパーツ（FLVプレイバックをラップ）追加
			vp2 = new VideoPlayWindowParts();		// FLVプレイバック追加
			vp3 = new VideoPlayWindowParts();		// FLVプレイバック追加
			s_08 = new Opening();			// 0811 オープニング（１２を背景とする。）
			s_12 = new Telop();				// 12 テロップ（０８１１の背景としても使用する）
			s_13 = new Opening2();			// 1319 掛け軸
			s_20 = new DogezaAnime();		// 20 土下座
			s_21 = new MainMovie();			// 21 メインムービー
			s_30l = new LeftDogezing();
			s_30r = new RightDogezing();
			btn_doge = new DogetherButtonParts();		// 土下座ボタン

			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}

		// addChild()された時に呼び出されるコールバック（起動時１回しか呼び出されない）
		private function addedToStage(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			// 画面の重なり順（※順番注意）
		//	this.addChild( vp3 );		// 音声のみ。非表示
		//	this.addChild( vp2 );		// 音声のみ。非表示
			this.addChild( s_21 );
			this.addChild( s_20 );		// 下地に使用
			this.addChild( s_13 );
			this.addChild( s_12 );		// 下地に使用
			this.addChild( s_08 );		// 上（s_12を背景とする）
			this.addChild( btn_doge );	// 土下座牡丹
			this.addChild( s_30l );		// ドゲザーＬ
			this.addChild( s_30r );		// ドゲザーＲ
			this.addChild( vp1 );		// 動画・画面表示あり
			this.addChild( s_logo );	// ＡＱスプラッシュ
		}

		// 各パーツ初期化
		private function initParts():void {
			// 各パーツ初期化
			s_08.visible = false;
			s_08.gotoAndStop( 0 );
			s_12.visible = false;
			s_12.gotoAndStop( 0 );
			s_13.visible = false;
			s_13.gotoAndStop( 0 );
			s_20.visible = false;
			s_20.gotoAndStop( 0 );
			s_21.visible = false;
			s_21.gotoAndStop( 0 );

			btn_doge.x = 810;
			btn_doge.y = 1726;
			btn_doge.visible = false;
			btn_doge.addEventListener(MouseEvent.MOUSE_DOWN, onBtnPlayDogether);

			s_30l.visible = false;
			s_30l.gotoAndStop( 0 );
			s_30r.visible = false;
			s_30r.gotoAndStop( 0 );
			s_logo.visible = false;

			// 動画初期化
			vp1.x = 0;
			vp1.y = 300;
			vp1.setViewArea( 1080, 720 );
			vp1.videoStreamParts.stop();
			vp2.videoStreamParts.stop();
			vp3.videoStreamParts.stop();
		}

		// 初期化処理
		public override function onInitScene(param:int = 0):void {
			trace("SceneSpriteOpening : onInitScene(" + param + ")");

			// パーツ初期化
			startOpening(param);

			// キーボード・コールバック（デバッグ用）
		//	stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyEvent);
		}

		// オープニング処理スタート
		public function startOpening(param:int):void {
			// 各パーツ初期化
			initParts();
			// フレーム用リスナー登録
			//this.addEventListener(Event.ENTER_FRAME, onEnterFrame);

			// 画面遷移開始
			sceneControl( true, param );				// 最初から再生（起動時・３分たった時）
	//		if(param == 0) sceneControl( true, 1 );		// 最初から再生（起動時・３分たった時）
//			else sceneControl( true, 5 );				// 途中から再生（戻ってきたとき）
		//	sceneControl( true, 3 );				// 最初から再生（起動時・３分たった時）
		}

		private var s:int;
		private var olds:int;

		// 画面遷移処理
		private function sceneControl(b:Boolean = false, inits:int = -1):void {
			// 画面遷移開始直後の動作か？
			if (b) {			// 開始直後だ
				olds = -1;
			}
			// シーン番号指定か？
			if (inits == -1) {	// 指定されなかった。
				s++;	// 次のシーンへ自動移動。
			} else {
				s = inits;		// 再生シーンが指定された
			}
			trace( "START scene control = " + s + ", old s = " + olds );
			
			//　シーン変更時のタイマーキャンセル
			if (timer1 != null) timer1.stop();	timer1 = null;
			if (timer2 != null) timer2.stop();	timer2 = null;

			///////////////////////////////////////////////////////////////////
			// 再生が終わったシーンの後始末
			switch( olds ) {
			case 0:	// ＡＱスプラッシュ＋プリロード
				s_logo.visible = false;
				break;
			case 1:		// 動画再生
				break;
			case 2:		//　最初のシーン「ごめんなさい」
				s_08.stop();
				s_08.visible = false;
				//vp1.visible = false;
				break;
			case 3:		// スターウォーズ風
				//s_12.gotoAndStop( 0 );
				s_12.stop();
				s_12.visible = false;
				s_08.visible = false;
				break;
			case 4:
				s_13.stop();
				s_13.visible = false;
				break;
			case 5:
				s_20.stop();
				s_20.visible = false;
				break;
			case 6:
				//s_21.stop();
				//s_21.visible = false;
				break;
			}
			
			// 共通的に隠す
			s_30l.visible = false;
			s_30r.visible = false;
			btn_doge.visible = false;

			olds = s;

			///////////////////////////////////////////////////////////////////
			// 次のシーンを実行
			switch( s ) {
			case 0:			// ＡＱスプラッシュ＋プリロード
				s_logo.visible = true;
				timer1 = new Timer(100);			// タイマ生成
				timer1.repeatCount = 10;		// １秒
				timer1.start();
				timer1.addEventListener(TimerEvent.TIMER_COMPLETE, onSplashTimeUp);
				break;
			case 1:			// 動画再生開始
				s_12.visible = true;
				vp1.visible = true;
				vp1.videoStreamParts.volume = 1;		// 最大音量
				vp1.setPlayStartCallBack( onVideoPlayStartCallBack );
				vp1.setAutoHidden( 1.8 );	// 一定時間経過後、自動的に隠れる様にする。
				vp1.setPlayCompleteCallBack( onVideoCompleteCallback );
				vp1.playVideo( "opening.mp4" );
				// 動画２（音声のみ）
				vp2.videoStreamParts.volume = 0.0;	// カクッとなる対策・先に再生させて安定させておく
				vp2.playVideo( "sound.mp4" );	// ストリーム開始
				vp2.videoStreamParts.stop();	// すぐに停止させる
				break;
			case 2:			// 最初のシーン「ごめんなさい」
				s_12.visible = true;	// 画面表示・停止状態（背景として使用）
				s_08.visible = true;
				s_08.addFrameScript(s_08.totalFrames - 1, onStopCallback　);
				s_08.gotoAndPlay( 0 );		// テロップ再生
				// マウス・コールバック（ＯＰ飛ばし用）
				stage.addEventListener(MouseEvent.CLICK, onStageTapMouseEvent);
				break;
			case 3:		// スターウォーズ風
				s_12.visible = true;
				s_12.addFrameScript(s_12.totalFrames - 1, onStopCallback　);
				s_12.gotoAndPlay( 0 );
				break;
			case 4:		// 掛け軸
				s_13.visible = true;
				s_20.visible = true;
				s_13.addFrameScript(s_13.totalFrames - 1, onStopCallback);
				s_13.gotoAndPlay( 0 );
				break;
			case 5:		// 土下座コマ送り
				s_20.addFrameScript(s_20.totalFrames - 1, onStopCallback);
				s_20.gotoAndPlay( 0 );
				break;
			case 6:		// 最後のシーン
				stage.removeEventListener(MouseEvent.CLICK, onStageTapMouseEvent);
				s_21.visible = true;
				s_21.gotoAndPlay( 0 );
				onButtonCallBack();	// ためし
				s_21.addFrameScript( 100, onTaikoCallback);	// 太鼓の音を鳴らすタイミング
				//s_21.addFrameScript( 240, onButtonCallBack );		// ボタンリスナ登録（暫定
				s_21.addFrameScript(150, onStopCallbackLastLoop);
				break;
			case 7:	// ボタン入力待ち（たまに回転光が回る）
				// タイマースタート
				timer2 = new Timer(100);		// タイマ生成
				timer2.repeatCount = 600;		// １０秒
				timer2.addEventListener(TimerEvent.TIMER_COMPLETE, onTitleWaitTimeUp);
				timer2.start();
				// 土下座ボタン表示
				btn_doge.start();	// ボタン・アニメ・スタート
				btn_doge.visible = true;
				break;
			case 9:		// 何もしない
				break;
			}
			//trace( "END scene control = " + s + ", old s = " + olds );
		}

		// ＡＱスプラッシュ画面表示タイムアップＣＢ
		private function onSplashTimeUp(te:TimerEvent):void {
			timer1.stop();
			timer1 = null;	// タイマ解放（ガベージコレクションさせる）
			//timer1.removeEventListener(TimerEvent.TIMER_COMPLETE, onSplashTimeUp);
			trace( "onSplashTimeUp" );
			// 全てプリロードが完了していればいいのだが。。

			///////////////////////////////////////
			// [201609]戻る処理コメントアウトＯＰムービーを飛ばして、いきなりオープニングへ移動するテストコード

			// Ａ：オープニングデモあり。
			//sceneControl();		// 引数なし＝次のシーンへ遷移せよ。

			// Ｂ：オープニングデモ無し。
			sceneControl( false, 7 );
			st.goScreenTransition( 1 );		// ゲームタイトル画面へジャンプ
			
			///////////////////////////////////////
		}

		// タイトルウェイト・タイムアップＣＢ
		private function onTitleWaitTimeUp(te:TimerEvent):void {
			timer2.stop();
			timer2 = null;	// タイマ解放（ガベージコレクションさせる）
			//timer2.removeEventListener(TimerEvent.TIMER_COMPLETE, onTitleWaitTimeUp);
			trace( "onSplashTimeUp" );
			// 全てプリロードが完了していればいいのだが。。
			sceneControl( false, 1 );		// オープニングに戻る
		}

		// 画面タッチしてオープニングを飛ばす処理
		private function onStageTapMouseEvent(me:MouseEvent):void {
			stage.removeEventListener(MouseEvent.CLICK, onStageTapMouseEvent);
			//trace( "hoge! x=" + mouseX + ", y=" + mouseY );
			vp1.videoStreamParts.stop();		// ムービー再生停止
			vp2.videoStreamParts.stop();		// ムービー停止
			// シーンを一気に飛ばすので、不要画面を隠す
			s_logo.visible = false;
			vp1.visible = false;
			s_08.visible = false;
			s_12.visible = false;
			s_13.visible = false;
			s_20.visible = false;
			//vp1.removeEventListener(VideoEvent.COMPLETE, videoCompleteCallback);
			sceneControl( false, 6 );	// 再生を飛ばす
		}

		// 動画安定再生コールバック（ここから０８を再生開始する）
		private function onVideoPlayStartCallBack():void {
			trace( "onVideoPlayedCallBack()" );
			sceneControl();		// 引数なし＝次のシーンへ遷移せよ。
			//Tweener.addTween(vp1.videoStreamParts, { volume:0.2, time:10 } );
		}

		// 各シーンの最終フレームでストップした際のコールバック
		private function onStopCallback():void
		{
			//trace( "onStopCallback" );
			sceneControl();		// 引数なし＝次のシーンへ遷移せよ。
		}

		// ムービー連続再生コールバック
		private function onVideoCompleteCallback():void {
			//trace( "videoCompleteCallback" );
			//vp2.videoStreamParts.stop();
			//vp2.videoStreamParts.volume = 0.5;
			vp2.videoStreamParts.resume();
			// フェードイン
			Tweener.addTween(vp2.videoStreamParts, { volume:0.5, time:1.5 } );
			// フェードアウト
			Tweener.addTween(vp2.videoStreamParts, { volume:0.0, time:6, delay:13.5 } );
		}

		// 太鼓の音を再生するコールバック
		private function onTaikoCallback():void {
			vp3.videoStreamParts.volume = 0;
			vp3.playVideo( "sound2.mp4" );
			// フェードイン
			Tweener.addTween(vp3.videoStreamParts, { volume:1, time:3.0 } );
		}

		// ボタンのコールバック登録処理
		private function onButtonCallBack():void {
			trace( "onButtonCallBack" );
			var i:int = 0;
			var result:int = 0;
			// ボタン・インスタンス確認
			while (true) {
				trace("(" + i + ")=[" + s_21.getChildAt(i) + "]");
				if (getQualifiedClassName(s_21.getChildAt(i)) == "GameButton") {
					s_21.getChildAt(i).addEventListener(MouseEvent.MOUSE_DOWN, onBtnGame);
					result++;
				}
				if (getQualifiedClassName(s_21.getChildAt(i)) == "AnkenButton") {
					s_21.getChildAt(i).addEventListener(MouseEvent.MOUSE_DOWN, onBtnSoudan);
					result++;
				}
				if (getQualifiedClassName(s_21.getChildAt(i)) == "YokokuButton") {
					s_21.getChildAt(i).addEventListener(MouseEvent.MOUSE_DOWN, onBtnYokoku);
					result++;
				}
			//	if (getQualifiedClassName(s_21.getChildAt(i)) == "DogeBack") {
			//		s_21.getChildAt(i).addEventListener(MouseEvent.MOUSE_DOWN, onBtnDogether);
			//		result++;
			//	}
				// ついでに「回転する光」も、ここで取ってしまう。
				if (getQualifiedClassName(s_21.getChildAt(i)) == "SpinningLight") {
					spinningLight = s_21.getChildAt(i);
					spinningLight2 = s_21.getChildAt(i) as SpinningLight;	// キャスト
					result++;
				}
				if (result == 4) break;
				i++;
			}
		}

		// BEDOGETHERボタン押下
//		private function onBtnDogether(me:MouseEvent):void
//		{	// 画面遷移実施
//			trace( "BTN_どげざ" );
//			// かさねボタンを配置してつかまえられるかチェック
		//	btn_do = new Sprite();
		//	btn_do.addChild( new hoge() as Bitmap );
		//	btn_do.x = 950;
		//	btn_do.y = 1800;
		//	addChild( btn_do );
			// 生成して動作をチェックする
		//ddChild( s1 );
//			s_30l.gotoAndPlay( 0 );
		//	var s2:RightDogezing = new RightDogezing();
		//	addChild( s2 );
		//	s2.gotoAndPlay( 0 );
//		}
		
		// 土下座アニメ（２パターン）表示処理
		private function onBtnPlayDogether(me:MouseEvent):void {
			// どちらのパターンかを判断する
			if (btn_doge.getAbePos()) {	// 右
				s_30l.visible = false;
				s_30r.addFrameScript(s_30r.totalFrames - 1, onDogezaStopCallback);
				s_30r.gotoAndPlay( 0 );
				s_30r.visible = true;
			} else {
				s_30r.visible = false;
				s_30l.addFrameScript(s_30l.totalFrames - 1, onDogezaStopCallback);
				s_30l.gotoAndPlay( 0 );
				s_30l.visible = true;
			}
		}
		// 各シーンの最終フレームでストップした際のコールバック
		private function onDogezaStopCallback():void
		{
		//	s_30l.visible = false;
		//	s_30r.visible = false;
		}

		//テスト用
		[Embed(source = "../game/img/btn_left.png")] private var hoge:Class;
		private var btn_do:Sprite;

		// ラストコールバック
		private function onStopCallbackLastLoop():void {
		//	s_21.stop();
			sceneControl();		// 「入力待ちタイマー発動」へ遷移。
		}

		// 「ゲーム」ボタン押下
		private function onBtnGame(me:MouseEvent):void
		{	// 画面遷移実施
			trace( "BTN_GAME" );
		//	spinningLight2.gotoAndPlay( 0 );
			st.goScreenTransition( 1 );		// ゲームタイトル画面へジャンプ
			//btn_game.y -= 50;
		}

		// 「相談案件」ボタン押下
		private function onBtnSoudan(me:MouseEvent):void
		{	// 画面遷移実施
			trace( "BTN_SOUDAN" );
			st.goScreenTransition( 4 );		// 相談画面へジャンプ
			//btn_soudan.y -= 50;

		//	spinningLight.play();
		//	spinningLight2.play();

			//(MovieClip)spinningLight.play();
		}

		// 「予告」ボタン押下
		private function onBtnYokoku(me:MouseEvent):void
		{	// 画面遷移実施
			trace( "BTN_YOKOKU" );
			st.goScreenTransition( 5 );		// 予告画面へジャンプ
			//btn_yokoku.y -= 50;
		}

		// フレーム・コールバック（メインループ）
		private function onEnterFrame(e:Event):void 
		{
		}

		// 終了処理
		public override function onLeaveScene(param:int = 0):void {
			trace("SceneSpriteOpening : onLeaveScene()");

			// 各種イベントの解除
			if (timer1 != null) timer1.stop();	timer1 = null;
			if (timer2 != null) timer2.stop();	timer2 = null;

			// シーン遷移の終了処理を実行
			sceneControl( false, 9 );		// ありえないシーン（シーン終了処理のみ実行する）

			// 各パーツ初期化・非表示
			initParts();

			// 画面遷移ボタン終了
			
			// フレーム用リスナー終了。
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);

			// キーボード・コールバック終了。
			//stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyEvent);
		}

		// キーボードコールバック
		//private function onKeyEvent(e:KeyboardEvent):void
		//{
		//	if (e.keyCode == 32) {
		//		st.goScreenTransition( 1 );
		//	} else {
		//		se01.play();
		//	}
		//}
	}
}
