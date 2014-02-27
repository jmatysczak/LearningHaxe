package ;

import haxe.io.Bytes;
import neko.Lib;
import sys.FileSystem;
import sys.io.File;

class Main {
	static function main() {
		var imageDir = "../images";
		var images = FileSystem.readDirectory(imageDir);
		var imagePaths = images.map(function(image) return imageDir + "/" + image);
		var imageBytes = imagePaths.map(File.getBytes);
		var imageBase64s = imageBytes.map(ConvertToBase64String);
		var imageHTMLs = imageBase64s.map(function(imageBase64) return "<img src='data:image/jpg;base64," + imageBase64 + "'/>");

		var page = new StringBuf();
		page.add("<html><body>");
		for (imageHTML in imageHTMLs) page.add(imageHTML);
		page.add("</body></html>");
		File.saveContent("Images.html", page.toString());
	}

	static var NekoStdBaseEncode = Lib.load("std", "base_encode", 2);
	static var BASE64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
	static function ConvertToBase64String(v : Bytes) {
		return new String(NekoStdBaseEncode(v.getData(), untyped BASE64.__s));
	}
}