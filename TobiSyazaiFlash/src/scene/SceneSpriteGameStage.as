package scene 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.GameInputEvent;
	import game.EffectButtonSpriteMoveKey;
	import game.GameMain;
	import parts.EffectButtonSprite;

	/**
	 * ...
	 * @author tobisako
	 */
	public class SceneSpriteGameStage extends AqtorScreenTransSprite	//  implements AqtorScreenTransSpriteInterface
	{
		[Embed(source = "../img/bg_gamebase.png")] private var e_base:Class;
		[Embed(source = "../img/g_lifemark.png")] private var e_lifemark:Class;
		[Embed(source = "../img/g_life_batsu.png")] private var e_life_batsu:Class;
		[Embed(source = "../img/gameover_mouhitoiki.png")] private var e_over_mouhitoiki:Class;
		[Embed(source = "../img/gameover_chuutohanpa.png")] private var e_over_chuutohanpa:Class;
		[Embed(source = "../img/gameover_muzukashi.png")] private var e_over_muzukashi:Class;
		private var st:AqtorScreenTransition;
		private var bl:EffectButtonSpriteMoveKey;
		private var br:EffectButtonSpriteMoveKey;
		private var bretry:EffectButtonSpriteMoveKey;
		private var gm:GameMain;
		private var btn_back:EffectButtonSprite;
		private var sLifemark:Sprite;
		private var sLifeBatsu1:Sprite;
		private var sLifeBatsu2:Sprite;
		private var sLifeBatsu3:Sprite;
		private var lifeput:int;			// ライフバツを画面表示した数
		private var sGameOverPanel:Sprite;
		private var bPanel1:Bitmap;
		private var bPanel2:Bitmap;
		private var bPanel3:Bitmap;

		// コンストラクタ
		public function SceneSpriteGameStage(st:AqtorScreenTransition) 
		{
			this.st = st;

			// 左ボタン生成
			bl = new EffectButtonSpriteMoveKey(0, onKeyLeft);
			bl.x = 680;
			bl.y = 1560;

			// 右ボタン生成
			br = new EffectButtonSpriteMoveKey(1, onKeyRight);
			br.x = 900;
			br.y = 1560;

			// もう一度ボタン生成
			bretry = new EffectButtonSpriteMoveKey(2, onKeyRetry);
			bretry.x = 200;
			bretry.y = 1560;

			// 戻るボタン生成
			btn_back = new EffectButtonSprite(onBtnBack, 1);
			btn_back.x = 180;
			btn_back.y = 1800;
			
			// ライフマーク配置
			sLifemark = new Sprite();
			sLifemark.addChild( new e_lifemark() as Bitmap );
			sLifemark.x = 630;
			sLifemark.y = 1700;
			
			// ライフ・バツを３つ生成
			sLifeBatsu1 = new Sprite();
			sLifeBatsu1.addChild( new e_life_batsu() as Bitmap );
			sLifeBatsu1.visible = false;
			sLifeBatsu1.x = 640;
			sLifeBatsu1.y = 1750;

			sLifeBatsu2= new Sprite();
			sLifeBatsu2.addChild( new e_life_batsu() as Bitmap );
			sLifeBatsu2.visible = false;
			sLifeBatsu2.x = 760;
			sLifeBatsu2.y = 1750;

			sLifeBatsu3 = new Sprite();
			sLifeBatsu3.addChild( new e_life_batsu() as Bitmap );
			sLifeBatsu3.visible = false;
			sLifeBatsu3.x = 880;
			sLifeBatsu3.y = 1750;

			// ゲームオーバー画面
			sGameOverPanel = new Sprite();
			sGameOverPanel.visible = false;
			bPanel1 = new e_over_mouhitoiki() as Bitmap;
			bPanel2 = new e_over_chuutohanpa() as Bitmap;
			bPanel3 = new e_over_muzukashi() as Bitmap;

			// もう一度するボタン生成
			// ゲームクラス生成
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}

		// addChild()された時に呼び出されるコールバック（起動時１回しか呼び出されない）
		private function addedToStage(event:Event):void 
		{
			addChild( new e_base() as Bitmap );
			addChild( bl );
			addChild( br );
			addChild( bretry );
			addChild( btn_back );
			addChild( sLifemark );
			addChild( sLifeBatsu1 );
			addChild( sLifeBatsu2 );
			addChild( sLifeBatsu3 );
		}

		// 「戻る」ボタン押下時の処理
		private function onBtnBack():void
		{
			//////////////////////////////////
			// [201609]戻る処理コメントアウト

			// Ａ：Ａ：オープニングデモあり。
			// st.goScreenTransition( 0, 6 );		// オープニング画面へ戻る！
				
			// Ｂ：ゲームタイトルに戻る。
			st.goScreenTransition( 1 );		// ゲームタイトル画面へジャンプ

			//////////////////////////////////
		}

		// ゲーム開始処理（このオブジェクトがaddChildされた後に実行する事）・・・自動で行う方法は無いのか・・・。
		public function initGame():void {
			if (gm != null) removeChild( gm );	// 古いオブジェクトを排除

			// ゲームオブジェクトは、毎回生成する事にする。（参照を完全に断ち切るため）
			gm = new GameMain();				// 新しいオブジェクトに上書き（古いのはガベージ対象になる）
			gm.x = 54;
			gm.y = 450;
			addChild( gm );

			// （ステージ追加後に）ゲーム初期化
			gm.initGame();			// ゲーム初期化
			gm.setDamageCallback( onDamage );		// ダメージを受けた際のコールバック指定
			gm.setGameEndCallback( onGameEnd );		// ゲーム終了時コールバック

			lifeput = 0;				// ライフ・バツを表示した数。
			sLifeBatsu1.visible = false;
			sLifeBatsu2.visible = false;
			sLifeBatsu3.visible = false;
		}

		// ダメージを受けた際のコールバック
		private function onDamage():void {
			lifeput++;
			switch( lifeput ) {
			case 1:		sLifeBatsu1.visible = true;		break;
			case 2:		sLifeBatsu2.visible = true;		break;
			case 3:		sLifeBatsu3.visible = true;		break;
			}
		}

		// ゲーム終了コールバック（ゲームクリアorゲームオーバー）
		private function onGameEnd(flg:int):void {

			if ( flg == 0 ) {	// ゲームクリア
				st.goScreenTransition( 3 );		// クリア画面へ遷移する
			} else {	// ゲームオーバー
				// ゲームクリア用エフェクト表示
				sGameOverPanel.x = 120;
				sGameOverPanel.y = 700;
				switch( flg ) {
				case 1:		sGameOverPanel.addChild( bPanel1 );		break;	// もう一息で・・・
				case 2:		sGameOverPanel.addChild( bPanel2 );		break;	// 中途半端で・・・
				case 3:		sGameOverPanel.addChild( bPanel3 );		break;	// 難しすぎて・・・
				}
				sGameOverPanel.visible = true;	// 画面表示
				addChild( sGameOverPanel );
			}
		}

		// 左キーがおされた
		private function onKeyLeft():void {
			gm.doMoveAction(false);
		}

		// 右キーがおされた
		private function onKeyRight():void {
			gm.doMoveAction(true);
		}

		// リトライキーが押された
		private function onKeyRetry():void {
			initGame();
		}

		// 初期化処理
		public override function onInitScene(param:int = 0):void {
			initGame();
		}

		// 終了処理
		public override function onLeaveScene(param:int = 0):void {
			trace("SceneSpriteGameStage : onLeaveScene!");
			removeChild( gm );	// ゲームオブジェクトをつぶしてみる。
			gm = null;			// ゲームオブジェクトを破棄（ガベージコレクションの対象にする。）
		}
	}
}
