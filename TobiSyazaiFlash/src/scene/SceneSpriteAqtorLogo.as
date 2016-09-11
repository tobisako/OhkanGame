package scene 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.TextField;
	/**
	 * ...
	 * @author tobisako
	 */
	public class SceneSpriteAqtorLogo extends Sprite
	{
		[Embed(source = "../img/aqtor_logo.png")] private var e_aqtor:Class;
		private var rect:Sprite;
		private var img:Bitmap;

		public function SceneSpriteAqtorLogo() 
		{
			// 透過チェック用ダミー表示
			addChild( new e_aqtor() as Bitmap );

			// 背景（黒）描画
			var rectBLACK:Sprite = new Sprite();
			rectBLACK.graphics.beginFill(0x000000);
			rectBLACK.graphics.drawRect(0, 0, 1080 + 10, 1920 + 10);
			rectBLACK.graphics.endFill();
			addChild(rectBLACK);

			// 背景（白）描画
			rect = new Sprite();
			rect.graphics.beginFill(0xffffff);
			rect.graphics.drawRect(0, 0, 1080 + 10, 1920 + 10);
			rect.graphics.endFill();
			addChild(rect);
			
			//　アクターロゴ描画
			img = new e_aqtor() as Bitmap;
			img.x = this.width / 2 - (img.width / 2);
			img.y = this.height / 2 - (img.height / 2) + 40;
			addChild( img );

			// low loading文字
			var t:TextField = new TextField();
			t.selectable = false;
			t.text = "Loading...";
			t.x = img.x;
			t.y = img.y + 80;
			addChild( t );
		}
	}
}
