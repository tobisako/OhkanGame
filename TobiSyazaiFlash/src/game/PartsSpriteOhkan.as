package game 
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * パーツ「王冠」
	 * @author tobisako
	 */
	public class PartsSpriteOhkan extends PartsSpriteBase
	{
		[Embed(source = "img/g_ohkan.png")] private var e_ohkan:Class;
		private var img_ohkan:Bitmap;
		private var mode_ohkan:int;				// 王冠モード（0:落下中、1:固定、2:はじかれた）
		private var fall_spd:Number;
		private var vx:Number;			// はじけ飛んだ際の移動量Ｘ
		private var vy:Number;			// はじけ飛んだ際の移動量Ｙ

		// コンストラクタ
		public function PartsSpriteOhkan(w:int, h:int, spd:Number = 2.0)
		{
			super(w, h, false);
			fall_spd = spd;

			img_ohkan = new e_ohkan() as Bitmap;
			img_ohkan.x = 0 - img_ohkan.width / 2;
			img_ohkan.y = 0 - img_ohkan.height / 2;
			addChild( img_ohkan );

			// フレーム用リスナー登録
			//this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		// 王冠の状態を返す
		public function isOhkanMode():int {
			return mode_ohkan;
		}

		// 王冠の状態を変更する
		private function setOhkanMode(m:int):void {
			mode_ohkan = m;
		}

		// 王冠がはじけ飛んだ時の処理。
		public override function dropOutMe():void {
			// はじけ飛び方角演算
			var fx:int = Math.random() * 2;
			var fy:int = Math.random() * 2;
			vx = (10 + Math.random() * 10);
			vy = 10 + Math.random() * 10;
			if (fx == 1) vx = vx * -1;
			if ( fy == 1) vy = vy * -1;
			
			setOhkanMode( 2 );		// 王冠がはじけとんだモードにする。
			super.dropOutMe();		// ドロップアプト
		}

		// 自分の上のマウントエリアを返す
		public override function getMountRect():Rectangle {
			// 当たり判定用矩形オブジェクト
		//	mountedRect.x = this.x - (this.width / 4) - 4;
			mountedRect.x = this.x - (this.width >> 1) + 2;
		//	mountedRect.width = this.width / 2 + 4;
			mountedRect.width = (this.width) -1;
		//	mountedRect.y = this.y - (this.height / 2) + 2;
			mountedRect.y = this.y - (this.height >> 1) + 2;
			mountedRect.height = 8;
			//trace("OHKAN RECT! x=" + mountedRect.x + ", y=" + mountedRect.y + ", w=" + mountedRect.width + ", h=" + mountedRect.height );
			return mountedRect;
		}

		// 自分の下のヒットエリアを返す
		public override function getMountingPoint():Point {
			// 当たり判定（下）用の座標オブジェクト
			mountingPoint.x = this.x;
		//	mountingPoint.y = this.y + (this.height / 2) - 4;
			mountingPoint.y = this.y + (this.height >> 1) - 4;
			//trace("OHKAN POINT! x=" + mountingPoint.x + ", y=" + mountingPoint.y );
			return mountingPoint;
		}

		// 自分の頭上中央点を返す（重ねる時の中心点ゲット用）
		protected override function getCenterTopPoint():Point {
			var tmp:Point = super.getCenterTopPoint();
			tmp.y = tmp.y + 2;		// 少し深くかさなる
			return tmp;
		}

		// 自分が何かの上に立った（停止した）事を設定する
		protected override function setMounting(ob:PartsSpriteBase):void {
			setOhkanMode(1);			// 王冠モード変更。
			super.setMounting(ob);		// 親クラス呼び出し。
		}

		// 王冠が、（何かの）上に乗っかった時に呼び出す。
		public function mountOhkan():void {
			mode_ohkan = 1;
		}

		// 王冠移動処理（落下・追従・回転）
		public override function doMove(centerx:int = 0):void {
			// もし自分がだれかの上に載っている場合。
			if (bIsMounting) {
				super.doMove(centerx);				// 阿倍にまとめてやらせるので、ここでは実行しない。
				return;
			}

			// 自分は誰の上にものっていない場合
			if (mode_ohkan == 0) {
				// 落下中！
				this.y += fall_spd;
			} else if (mode_ohkan == 2) {	// はじかれた時の処理
				this.rotation += 45;
				this.x += vx;		// はじける
				this.y += vy;		// はじける
				vy += 1.5;			// 重力
			}
		}

		// フレーム・コールバック
		private function onEnterFrame(e:Event):void 
		{
		//	if (mode_ohkan == 0) {		// 落下中
		//		this.y += 4.4;
		//	} else if (mode_ohkan == 2) {	// はじかれた時の処理
		//		this.rotation += 45;
		//		this.x -= 16;
		//	}
			//if (mode == 1) this.rotation -= 2;
		}
	}

/*
	// 王冠列挙型
	interface IEnum 
	{
		function toInt():int;
	}

	class final OhkanType implements IEnum
	{
		// Enum の各要素
		public static const RAKKA:OhkanType = new OhkanType(0);
		public static const MOUNT:OhkanType = new OhkanType(1);
		public static const KURUKURU:OhkanType = new OhkanType(2);

		// Enum の実装
		private var _value:int;

		public function Hoge(value:int)
		{
			_value = value;
		}

		public function toInt():int
		{
			return _value;
		}
	}
*/

}
