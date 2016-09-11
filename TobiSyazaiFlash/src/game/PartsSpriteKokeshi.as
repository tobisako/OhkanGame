package game 
{
	import flash.display.Bitmap;

	/**
	 * こけし（小）制御用・・・プレイヤーに当たるとダメージを受ける
	 * @author tobisako
	 */
	public class PartsSpriteKokeshi extends PartsSpriteBase
	{
		[Embed(source="img/g_kokeshi.png")] private var e_koke:Class
		private var img_koke:Bitmap;
		private var mode_kokeshi:int;				// こけしモード（0:落下中、1:固定、2:はじかれた）
		private var fall_spd:Number;
		private var vx:Number;					// はじけ飛んだ際の移動量Ｘ
		private var vy:Number;					// はじけ飛んだ際の移動量Ｙ
		private var vr:Number;					// はじけ飛んだ際の回転量Ｒ

		// コンストラクタ
		public function PartsSpriteKokeshi(w:int, h:int, spd:Number = 2.0)
		{
			super(w, h, false);
			fall_spd = spd;
			mode_kokeshi = 0;

			// こけし画像を「中心部」に添える。
			img_koke = new e_koke() as Bitmap;
			img_koke.x = 0 - (img_koke.width / 2);
			img_koke.y = 0 - (img_koke.height / 2);
			addChild( img_koke );
			
			// 生成直後のこけしの移動調整
			vx = Math.random() * 5;
			if (Math.random() * 2 == 1) vx = vx * -1;
		}
		
		// こけし（小）がはじけ飛んだ時の処理。
		public override function dropOutMe():void {
			// はじけ飛び方角演算
			var fx:int = Math.random() * 2;
			//var fy:int = Math.random() * 2;
			vx = Math.random() * 10 + 1;
			vy = -10 - Math.random() * 10;
			if (fx == 1) vx = vx * -1;
			//if (fy == 1) vy = vy * -1;
			vr = 10 - Math.random() * 20;
			
			mode_kokeshi = 2;		// こけしが当たった時のモードに変更。
			super.dropOutMe();		// ドロップアプト
		}

		// こけし（小）移動処理（落下・追従・回転）
		public override function doMove(centerx:int = 0):void {
			if ( mode_kokeshi == 0 ) {
				this.x += vx;
				this.y += 22;
				this.rotation += 45;
			} else if ( mode_kokeshi == 2 ) {
				this.x = this.x + vx;
				this.y = this.y + vy;
				this.rotation += vr;
				vy += 1.8;			// 重力
			}
		}
		
		// こけしのモードをゲットする
		public function get mode():int {
			return mode_kokeshi;
		}
	}
}