package ;

import haxe.io.BytesOutput;
import sys.FileSystem;
import sys.io.File;
import format.png.Reader;
import format.png.Tools;
import format.png.Writer;

class Main {
	
	static function main() {
		var imageDir = "../images";
		var images = FileSystem.readDirectory(imageDir);
		var imagePaths = images.map(function(image) return imageDir + "/" + image);
		var imageDatas = imagePaths.map(function(imagePath) return new Reader(File.read(imagePath, true)).read());
		var maxWidthTotalHeight = Lambda.fold(imageDatas, function(imageData, maxWidthTotalHeight) {
			var header = Tools.getHeader(imageData);
			maxWidthTotalHeight.MaxWidth = Math.max(maxWidthTotalHeight.MaxWidth, header.width);
			maxWidthTotalHeight.TotalHeight += header.height;
			return maxWidthTotalHeight;
		}, {MaxWidth : 0, TotalHeight : 0});
		for (imageData in imageDatas) {
			var header = Tools.getHeader(imageData);
			Sys.println(header.width + ", " + header.height + ", " + header.colbits + ", " + header.color);
		}
		Sys.println(maxWidthTotalHeight);
		
		var spriteBytes = new BytesOutput();
		for (imageData in imageDatas) {
			var header = Tools.getHeader(imageData);
			if (header.width < maxWidthTotalHeight.MaxWidth) {
				maxWidthTotalHeight.TotalHeight -= header.height;
				continue;
			}
			var imageDataBytes = Tools.extract32(imageData);
			spriteBytes.writeBytes(imageDataBytes, 0, imageDataBytes.length);
		}

		var spriteData = Tools.build32BGRA(Std.int(maxWidthTotalHeight.MaxWidth), maxWidthTotalHeight.TotalHeight, spriteBytes.getBytes());
		new Writer(File.write("sprite.png", true)).write(spriteData);
	}
}