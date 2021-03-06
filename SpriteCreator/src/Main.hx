package ;

import haxe.io.BytesOutput;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
import format.png.Reader;
import format.png.Tools;
import format.png.Writer;

using Lambda;

class Main {
	static function main() {
		var imageDir = "../images";
		var imageNames = FileSystem.readDirectory(imageDir);
		var imagePaths = imageNames.map(function(image) return imageDir + "/" + image);
		var imageDatas = imagePaths.map(function(imagePath) return new Reader(File.read(imagePath, true)).read());
		var imageHeaders = imageDatas.map(Tools.getHeader);
		var maxWidth = imageHeaders.fold(function(imageHeader, width) return Math.max(width, imageHeader.width), 0);
		var totalHeight = imageHeaders.fold(function(imageHeader, height) return height + imageHeader.height, 0);

		var spriteBytes = new BytesOutput();
		for (imageData in imageDatas) {
			var header = Tools.getHeader(imageData);
			var imageDataBytes = Tools.extract32(imageData);
			if (header.width < maxWidth) {
				var spacing = Std.int(maxWidth - header.width);
				for (h in 0...header.height) {
					spriteBytes.writeBytes(imageDataBytes, h * header.width * 4, header.width * 4);
					for (w in 0...spacing) spriteBytes.writeInt32(0);
				}
			} else {
				spriteBytes.writeBytes(imageDataBytes, 0, imageDataBytes.length);
			}
		}

		var spriteImage = Tools.build32BGRA(Std.int(maxWidth), totalHeight, spriteBytes.getBytes());
		var spriteImageFile = File.write("sprite.png", true);
		new Writer(spriteImageFile).write(spriteImage);

		var currentTop = 0;
		var spriteStyleFile = File.write("sprite.css", false);
		var imageNamesSansExtension = imageNames.map(Path.withoutExtension);
		spriteStyleFile.writeString(".image{background-image:url(sprite.png); display:inline-block;}\n");
		for (i in 0...imageNamesSansExtension.length) {
			var imageHeader = imageHeaders[i];
			spriteStyleFile.writeString('.image-${imageNamesSansExtension[i]}{background-position:0px ${currentTop}px; height:${imageHeader.height}px; width: ${imageHeader.width}px;}\n');
			currentTop -= imageHeader.height;
		}
		spriteStyleFile.close();

		var htmlFile = File.write("sprite.html", false);
		htmlFile.writeString("<!doctype html><html><head><link href='sprite.css' rel='stylesheet' type='text/css'/></head><body>");
		for (imageName in imageNamesSansExtension) {
			htmlFile.writeString('<div class="image image-$imageName"></div>');
		}
		htmlFile.writeString("</body></html>");
		htmlFile.close();
	}
}