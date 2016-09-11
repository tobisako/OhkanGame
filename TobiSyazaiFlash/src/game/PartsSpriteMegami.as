package game {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import caurina.transitions.Tweener;
	import flash.media.Sound;
	import parts.SoundParts;
	
	/**
	 * パーツ：女神
	 * @author tobisako
	 */
	public class PartsSpriteMegami extends PartsSpriteBase
	{
		[Embed(source = "img/g_megami.png")] private var e_megami:Class;
		private var s1:SoundParts;
		private var s2:SoundParts;
		private var img_megami:Bitmap;
		private var mode:int;					// 王冠モード（0:落下中、1:固定、2:はじかれた）
		//private var parentdisp:DisplayObject;	// 「表示オブジェクトの親」を取得する
		private var bActive:Boolean;			// 攻撃行動中かをチェック
		private var xLimit:int;					// x座標リミット（ＨＩＴ判定高速化用）

//		var bd:BitmapData;

		public function PartsSpriteMegami() 
		{
			super();
			//parentdisp = paredisp;	// 「表示オブジェクトの親」を取得する

			img_megami = new e_megami() as Bitmap;
			img_megami.x = 0 - (img_megami.width / 4);
			img_megami.y = 0 - (img_megami.height - (img_megami.height / 4));
			addChild( img_megami );
			xLimit = img_megami.width + (img_megami.width / 4);
			
			lfrotation = this.rotation;

			// きしみ音サウンド取り込み
			s1 = new SoundParts( 5 );
			s2 = new SoundParts( 9 );

		//	bd = new BitmapData( 1000, 1000, true, 0x0 );

			// フレーム用リスナー登録
		//	this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private var bMuki:Boolean;

		// フレーム・コールバック
		private function onEnterFrame(e:Event):void 
		{
			if (!bMuki) {
				this.rotation += 5;
				if (this.rotation >= 50) bMuki = true;
			} else {
				this.rotation -= 2.5;
				if (this.rotation <= 0) bMuki = false;
			}
		}
		
		// 女神・ファーストポジション（隠れている）
		public function initPosition():void 
		{
			lfx = this.x = -500;
			lfy = this.y = 1100;
		}

		// Twinner実行
		public function playTwinner(num:int = 0):void
		{
			switch( num ) {
			case 0:		playTwinner01();	break;
			case 1:		playTwinner02();	break;
			case 2:		playTwinner03();	break;
			}
			bActive = true;
		}

		// Tweenerをフレーム追従させる工夫
		private var lfx:int = 0;
		private var lfy:int = 0;
		private var lfrotation:Number = 0.0;

		public function get fx():int {
			return lfx;
		}
		public function set fx(x:int):void {
			lfx = x;
		}
		public function get fy():int {
			return lfy;
		}
		public function set fy(y:int):void {
			lfy = y;
		}
		public function get frotation():Number {
			return lfrotation;
		}
		public function set frotation(rr:Number):void {
			lfrotation = rr;
		}

		// Twinner実行：出現・倒れて・起き上がるアクション
		public function playTwinner01():void
		{
			initPosition();		// 初期位置
			Tweener.addTween(this, {  transition:'easeOutBack', fx:-80, fy:550, time:0.5, onComplete:onTaoreruHandler } );
			Tweener.addTween(this, {  transition:'easeOutBounce', frotation:45, time:2.0, delay:0.5 } );
			Tweener.addTween(this, {  transition:'easeInQuad', frotation:0, time:1.8, delay:2.5 } );
			Tweener.addTween(this, {  transition:'easeInExpo', fx:this.x, fy:this.y, time:0.5, delay:4.3, onComplete:onCompleteHandler } );
		}
		// http://d.hatena.ne.jp/ActionScript/20090424/as3_tweener_transition
		
		// 倒れる時のサウンドアクション１
		private function onTaoreruHandler():void {
			//s1.play( onDownHandler );
		}

		// 倒れる時のサウンドアクション２
		private function onDownHandler():void {
		//	s1.stop();
			//s2.play();
		}

		// Twinner実行：出現して、すぐにひっこむアクション
		public function playTwinner02():void
		{
			initPosition();		// 初期位置
			Tweener.addTween(this, {  transition:'easeOutBack', fx: -80, fy:550, time:0.5 } );
			Tweener.addTween(this, {  transition:'easeInExpo', fx:this.x, fy:this.y, time:0.5, delay:0.5, onComplete:onCompleteHandler } );
		}
		
		// Twinner実行：少し出現して、少しとまって、そのままひっこむ
		public function playTwinner03():void
		{
			initPosition();		// 初期位置
			Tweener.addTween(this, {  transition:'Linear', fx: -280, fy:880, time:0.5 } );
			Tweener.addTween(this, {  transition:'easeInExpo', fx:this.x, fy:this.y, time:0.5, delay:2, onComplete:onCompleteHandler } );
		}

		// Tweener終了コールバック
		private function onCompleteHandler():void {
			bActive = false;
		}

		// ヒットチェック準備（１フレームに１回だけ実行して速度向上を狙う）
		public override function createHitBitmapData(base:DisplayObject):void {
			if (bActive) bdTargetObj = createBitmapData2(base, this);
		}

		private var ch:int;

		// ヒットチェック（Ｐｏｉｎｔ）
		public override function onHitCheckPoint(paredisp:DisplayObject, x:int, y:int):Boolean {
			if (bActive) {
				if (this.x + xLimit < x ) {
					trace( "GAI!!!!!!" );
					return false;
				}
			//	ch++;
			//	if (ch > 1) {
			//		ch = 0;
					return super.onHitCheckPoint(paredisp, x, y);
			//	}
			}
			return false;	// 高速化・攻撃体制以外は当たり判定処理しない
		}
		
		// アクティブ状態チェック
		public function get isActive():Boolean {
			return bActive;
		}
		
		// 移動処理（ベース）
		public override function doMove(centerx:int = 0):void {
			// １フレームに１回だけ、ローテーション情報を反映させる。
			this.rotation = lfrotation;		// 反映。
			this.x = lfx;
			this.y = lfy;
		}
	}
}
