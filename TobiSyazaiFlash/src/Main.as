package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import game.GameMain;
	import scene.SceneSpriteAqtorLogo;
	import scene.SceneSpriteGameClear;
	import scene.SceneSpriteGameStage;
	import scene.SceneSpriteGameTitle;
	import scene.SceneSpriteOpening;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;	
	import scene.SceneSpriteSoudan;
	import scene.SceneSpriteYokoku;
	import flash.display.StageDisplayState;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.desktop.NativeApplication;
	
	/**
	 * メイン処理（メイン内では、マウス・キーボード等あらゆるイベントは受け付けない事にする）
	 * @author tobisako
	 */
	public class Main extends Sprite 
	{
		// 各シーンのクラス変数
		private var scene_op:SceneSpriteOpening;
		private var scene_gametitle:SceneSpriteGameTitle;
		private var scene_gamestage:SceneSpriteGameStage;
		private var scene_gameclear:SceneSpriteGameClear;
		private var scene_soudan:SceneSpriteSoudan;
		private var scene_yokoku:SceneSpriteYokoku;
		private var st:AqtorScreenTransition;

		// デバッグ：
		private var gm:GameMain;

		// XML定義
		private function checkXML():void
		{
			var app:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = app.namespace();
			var version:String = app.ns::versionNumber;
			var fn:String = app.ns::filename;
			var iw:String = app.ns::initialWindow;
			var fs:String = app.ns::initialWindow.ns::fullScreen;
			//trace( "version=[" + version + "].");
			//trace( "filename=[" + fn + "]" );
			//trace( "iw=[" + iw + "]" );
			//trace( "ch=[" + ch + "]" );

			// フルスクリーンモード判定
			if (fs == "true") {
				// フルスクリーンモード
				stage.fullScreenSourceRect = new Rectangle(0, 0, 1080, 1920);
				stage.align = StageAlign.TOP;
				stage.scaleMode = StageScaleMode.SHOW_ALL;
				stage.displayState = StageDisplayState.FULL_SCREEN;
				//stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);			
 				trace( "FULL SCREEN MODE!" );
			} else {
				trace( "WINDOW MODE." );
			}
		}
		// 参考：　http://d.hatena.ne.jp/nenjiru/20110620/1308562339
		// 参考： http://d.hatena.ne.jp/kkanda/20071004/p1

		// ＥＳＣキーのみ無効化して最小化出来ない様にしむける
		private function onKeyDown(ke:KeyboardEvent):void {
			if (ke.keyCode == Keyboard.ESCAPE)
			{
				ke.preventDefault();
			}
		}
		// 参考：　http://stackoverflow.com/questions/14556364/change-default-behavior-of-esc-key-in-as3-air-2-0-or-above-to-keep-display-sta

		// コンストラクタ
		public function Main():void 
		{
			checkXML();		// 定義毎に画面切り替えを行う

			// 画面遷移初期化
			st = new AqtorScreenTransition( screenTransitionCallBack );
			
			// オープニング画面を表示してみるテスト
			//scene_logo = new SceneSpriteAqtorLogo();
			scene_op = new SceneSpriteOpening( st );
			scene_gametitle = new SceneSpriteGameTitle( st );
			scene_gamestage = new SceneSpriteGameStage( st );
			scene_gameclear = new SceneSpriteGameClear( st );
			scene_soudan = new SceneSpriteSoudan( st );
			scene_yokoku = new SceneSpriteYokoku( st );

			// https://github.com/umhr/AS3GIF/blob/master/GIFAnime/src/Main.as
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}

		// ＳＴＡＧＥとの接続完了
		private function addedToStage(event:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
		//	scene_op.visible = false;
			this.addChild( scene_op );
		//	scene_gametitle.visible = false;
			this.addChild( scene_gametitle );
		//	scene_gamestage.visible = false;
			this.addChild( scene_gamestage );
			this.addChild( scene_gameclear );
		//	scene_soudan.visible = false;
			this.addChild( scene_soudan );
		//	scene_yokoku.visible = false;
			this.addChild( scene_yokoku );

			// オープニング・アクター・ロゴを表示
		//	this.addChild( scene_logo );

			// デバッグ
		//	addChild( scene_gamestage );
		//	scene_gamestage.onInitScene();

			// フレーム用リスナー登録
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);

			// 初期画面遷移処理
			//st.goScreenTransition( 0, 0 );
			
			// 起動後いきなりゲームスタートさせる改造
			st.goScreenTransition( 0, 0 );
			
			}

		private var ii:int;
		// フレーム・コールバック（メインループ）
		private function onEnterFrame(e:Event):void 
		{
			ii++;
			if (ii == 24) {
			//	scene_op.visible = false;
				scene_gametitle.visible = false;
				scene_gamestage.visible = false;
				scene_gameclear.visible = false;
				scene_soudan.visible = false;
				scene_yokoku.visible = false;
			//	st.goScreenTransition( 0 );
			//	scene_logo .visible = false;
			}
		}

		// 画面遷移処理（ＲＴオリジナル）…Progression4はAIRパッケージ化出来なかった。。。
		private function screenTransitionCallBack(old:int, cur:int, para:int = 0):void
		{
			// シーンＮｏをSpriteオブジェクトに変換し、画面チェンジ処理を実行する。
			changeScreen( getSceneSprite(old), getSceneSprite(cur), para );
		}

		// シーンＮｏからシーンオブジェクトを返す（ポリモーフィズム）
		private function getSceneSprite(num:int):AqtorScreenTransSprite
		{
			switch(num) {
			case 0:		return scene_op;
			case 1:		return scene_gametitle;
			case 2:		return scene_gamestage;
			case 3:		return scene_gameclear;
			case 4:		return scene_soudan;
			case 5:		return scene_yokoku;
			}
			return null;
		}
		
		// 画面の接続と解除（ポリモーフィズムを使用）
		private function changeScreen(oldsp:AqtorScreenTransSprite, cursp:AqtorScreenTransSprite, para:int):void 
		{
			// 新画面を接続
			//this.addChild( cursp );
			cursp.visible = true;
			this.setChildIndex(cursp, this.numChildren - 1);
			cursp.onInitScene( para );

			// 旧画面を外す
			if (oldsp != null) {
				oldsp.visible = false;
				oldsp.onLeaveScene();
				//this.removeChild( oldsp );
			}
		}
	}
}

// 参考：プリローダー・　http://www.sousakuba.com/weblabo/actionscript-now-loading.html
// 参考：Loadingアイコン　https://dribbble.com/shots/1096260-Loading-GIF-Animation
// 参考：GIF->SWF変換　http://hokanko2008.seesaa.net/article/130574091.html
// 参考：ＡＩＲ・ウィンドウフレームの表示／非表示　http://d.hatena.ne.jp/tomodrop/20080108/1199851464
// 参考：フルスクリーンモード　http://help.adobe.com/ja_JP/ActionScript/3.0_ProgrammingAS3/WS2E9C7F3B-6A7C-4c5d-8ADD-5B23446FBEEB.html
// 参考：AIRのapplication.xmlをAS3から取得する　http://d.hatena.ne.jp/nenjiru/20110620/1308562339
// 参考：関数インライン展開は高速　http://ton-up.net/blog/archives/1016
