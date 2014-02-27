package ;

import sys.FileSystem;
import sys.io.File;
import format.png.Reader;
import format.png.Tools;

class Main {
	
	static function main() {
		var imageDir = "../images";
		var images = FileSystem.readDirectory(imageDir);
		var imagePaths = images.map(function(image) return imageDir + "/" + image);
		var imageDatas = imagePaths.map(function(imagePath) return new Reader(File.read(imagePath, true)).read());
		var maxWidthTotalHeight = Lambda.fold(imageDatas, function(imageData, maxWidthTotalHeight) {
			var header = Tools.getHeader(imageData);
			maxWidthTotalHeight[0] = Math.max(maxWidthTotalHeight[0], header.width);
			maxWidthTotalHeight[1] += header.height;
			return maxWidthTotalHeight;
		}, [0, 0]);
		for (imageData in imageDatas) {
			var header = Tools.getHeader(imageData);
			Sys.println(header.width + ", " + header.height);
		}
			Sys.println(maxWidthTotalHeight);
	}
}