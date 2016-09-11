package scene 
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	import parts.EffectButtonSprite;
	import flash.events.TimerEvent;
	import flash.utils.getQualifiedClassName;

	/**
	 * 謝罪の王様：相談案件画面
	 * @author tobisako
	 */
	public class SceneSpriteSoudan extends AqtorScreenTransSprite
	{
		private var st:AqtorScreenTransition;

		[Embed(source = "../img/img_case1.png")] private var e_c1:Class;
		[Embed(source = "../img/img_case2.png")] private var e_c2:Class;
		[Embed(source = "../img/img_case3.png")] private var e_c3:Class;
		[Embed(source = "../img/img_case4.png")] private var e_c4:Class;
		[Embed(source = "../img/img_case5.png")] private var e_c5:Class;
		[Embed(source = "../img/img_case6.png")] private var e_c6:Class;

		private var slist:AnkenScene;		// クラス名を変更する事。
		private var btn_case1:DisplayObject;
		private var btn_case2:DisplayObject;
		private var btn_case3:DisplayObject;
		private var btn_case4:DisplayObject;
		private var btn_case5:DisplayObject;
		private var btn_case6:DisplayObject;
		private var d:DisplayObject;
		private var btn_modoru:EffectButtonSprite;
		private var btn_owari:DisplayObject;
		private var img_case1:Bitmap;
		private var img_case2:Bitmap;
		private var img_case3:Bitmap;
		private var img_case4:Bitmap;
		private var img_case5:Bitmap;
		private var img_case6:Bitmap;
		private var backtimer:Timer;

		// コンストラクタ
		public function SceneSpriteSoudan(st:AqtorScreenTransition)
		{
			this.st = st;

			// 相談一覧
			slist = new AnkenScene();

			// 各ケース画像
			img_case1 = new e_c1() as Bitmap;
			img_case2 = new e_c2() as Bitmap;
			img_case3 = new e_c3() as Bitmap;
			img_case4 = new e_c4() as Bitmap;
			img_case5 = new e_c5() as Bitmap;
			img_case6 = new e_c6() as Bitmap;
			
			// 一覧に戻るボタン
			btn_modoru = new EffectButtonSprite(onBtnBackToList, 2);
			btn_modoru.x = img_case1.width / 2 - (btn_modoru.width / 8);
			btn_modoru.y = img_case1.height - (btn_modoru.height * 0.8);

			// 相談案件を終了する「もどる」ボタン
		//	btn_owari = new EffectButtonSprite(onBtnLeaveScene, 2);
		//	btn_owari.x = 162;
		//	btn_owari.y = 1400;
		//	this.addChild( btn_owari );

			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		// addChild()された時に呼び出されるコールバック
		private function addedToStage(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);

			this.addChild( slist );
			this.addChild( img_case1 );
			this.addChild( img_case2 );
			this.addChild( img_case3 );
			this.addChild( img_case4 );
			this.addChild( img_case5 );
			this.addChild( img_case6 );
			this.addChild( btn_modoru );

			//btn_case1 = slist.getChildAt(　1　);
			//btn_case2 = slist.getChildAt( 2 );
			//btn_case3 = slist.getChildAt( 3 );
			//btn_case4 = slist.getChildAt( 4 );
			//btn_case5 = slist.getChildAt( 5 );
			//btn_case6 = slist.getChildAt( 6 );
			//btn_owari = slist.getChildAt( 7 );

			// ボタンにリスナー登録
			//btn_case1.addEventListener(MouseEvent.MOUSE_DOWN, onBtnCase1);
			//btn_case2.addEventListener(MouseEvent.MOUSE_DOWN, onBtnCase2);
			//btn_case3.addEventListener(MouseEvent.MOUSE_DOWN, onBtnCase3);
			//btn_case4.addEventListener(MouseEvent.MOUSE_DOWN, onBtnCase4);
			//btn_case5.addEventListener(MouseEvent.MOUSE_DOWN, onBtnCase5);
			//btn_case6.addEventListener(MouseEvent.MOUSE_DOWN, onBtnCase6);
			//btn_owari.addEventListener(MouseEvent.MOUSE_DOWN, onBtnLeaveScene);
			onButtonCallBack();
		}

		// ボタンのコールバック登録処理
		private function onButtonCallBack():void {
			var i:int = 0;
			var result:int = 0;
			// ボタン・インスタンス確認
			while (true) {
				trace("(" + i + ")=[" + slist.getChildAt(i) + "]");
				if (getQualifiedClassName(slist.getChildAt(i)) == "An1") {
					slist.getChildAt(i).addEventListener(MouseEvent.MOUSE_DOWN, onBtnCase1);
					result++;
				}
				if (getQualifiedClassName(slist.getChildAt(i)) == "An2") {
					slist.getChildAt(i).addEventListener(MouseEvent.MOUSE_DOWN, onBtnCase2);
					result++;
				}
				if (getQualifiedClassName(slist.getChildAt(i)) == "An3") {
					slist.getChildAt(i).addEventListener(MouseEvent.MOUSE_DOWN, onBtnCase3);
					result++;
				}
				if (getQualifiedClassName(slist.getChildAt(i)) == "An4") {
					slist.getChildAt(i).addEventListener(MouseEvent.MOUSE_DOWN, onBtnCase4);
					result++;
				}
				if (getQualifiedClassName(slist.getChildAt(i)) == "An5") {
					slist.getChildAt(i).addEventListener(MouseEvent.MOUSE_DOWN, onBtnCase5);
					result++;
				}
				if (getQualifiedClassName(slist.getChildAt(i)) == "An6") {
					slist.getChildAt(i).addEventListener(MouseEvent.MOUSE_DOWN, onBtnCase6);
					result++;
				}
				if (getQualifiedClassName(slist.getChildAt(i)) == "pModoruButton") {
					slist.getChildAt(i).addEventListener(MouseEvent.MOUSE_DOWN, onBtnLeaveScene);
					result++;
				}
				if (result == 7) break;
				i++;
			}
		}
		
		// 画面切り替え時、上からふってきてどすん！と、やってみる。
		
		// ケース１ボタン押下
		private function onBtnCase1(me:MouseEvent):void {
			this.setChildIndex(img_case1, this.numChildren - 1);
			this.setChildIndex(btn_modoru, this.numChildren - 1);
			setTimeUpTimer();
		}

		// ケース2ボタン押下
		private function onBtnCase2(me:MouseEvent):void {
			this.setChildIndex(img_case2, this.numChildren - 1);
			this.setChildIndex(btn_modoru, this.numChildren - 1);
			setTimeUpTimer();
		}

		// ケース3ボタン押下
		private function onBtnCase3(me:MouseEvent):void {
			this.setChildIndex(img_case3, this.numChildren - 1);
			this.setChildIndex(btn_modoru, this.numChildren - 1);
			setTimeUpTimer();
		}

		// ケース4ボタン押下
		private function onBtnCase4(me:MouseEvent):void {
			this.setChildIndex(img_case4, this.numChildren - 1);
			this.setChildIndex(btn_modoru, this.numChildren - 1);
			setTimeUpTimer();
		}

		// ケース5ボタン押下
		private function onBtnCase5(me:MouseEvent):void {
			this.setChildIndex(img_case5, this.numChildren - 1);
			this.setChildIndex(btn_modoru, this.numChildren - 1);
			setTimeUpTimer();
		}

		// ケース6ボタン押下
		private function onBtnCase6(me:MouseEvent):void {
			this.setChildIndex(img_case6, this.numChildren - 1);
			this.setChildIndex(btn_modoru, this.numChildren - 1);
			setTimeUpTimer();
		}

		// 戻るボタン押下→リストへ戻る
		private function onBtnBackToList():void {
			this.setChildIndex(slist, this.numChildren - 1);
			//this.setChildIndex(btn_owari, this.numChildren - 1);
			setTimeUpTimer();
		}

		// 戻るボタン押下→シーン終了
		private function onBtnLeaveScene(me:MouseEvent):void {
			st.goScreenTransition( 0, 6 );		// 最初の画面へ戻るジャンプ
		//	st.goScreenTransition( 0, 1 );		// 最初の画面へ戻るジャンプ
		}

		// タイマー設定・再設定処理（ボタン入力毎に行う）
		private function setTimeUpTimer():void {
			// 既存タイマーＣＢ解除
			if (backtimer != null) {
				backtimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimeUp);
				backtimer = null;
			}
			// ３０秒タイマ設定
			backtimer = new Timer(1000);	// タイマ生成（毎回作り直す）
			backtimer.repeatCount = 30;		// ３０秒
			backtimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimeUp);
			backtimer.start();
		}
		
		// ３０秒タイムアップＣＢ
		private function onTimeUp(te:TimerEvent):void {
			st.goScreenTransition( 0, 6 );		// 最初の画面へ戻るジャンプ
		}

		// 【画面遷移】　初期化処理
		public override function onInitScene(param:int = 0):void {
			// 画面遷移配置を元に戻る（一覧をトップに）
			this.setChildIndex(slist, this.numChildren - 1);
			setTimeUpTimer();
		}

		// 【画面遷移】　終了処理
		public override function onLeaveScene(param:int = 0):void {
			if (backtimer != null) {
				backtimer.stop();
				backtimer = null;	// タイマ解放（ガベージコレクションさせる）
			}
		}
	}
}
