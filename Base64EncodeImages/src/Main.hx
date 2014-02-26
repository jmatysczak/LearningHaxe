package ;

import haxe.Serializer;
import sys.FileSystem;
import sys.io.File;

class Main {
	static function main() {
		var imageDir = "../images";
		var images = FileSystem.readDirectory(imageDir);
		var imagePaths = images.map(function(image) return imageDir + "/" + image);
		var imageBytes = imagePaths.map(File.getBytes);
		var imageBase64s = imageBytes.map(Serializer.run);
		var imageHTMLs = imageBase64s.map(function(imageBase64) return "\r\n<p><img src='data:image/jpg;base64," + imageBase64 + "'/></p>");

		var page = new StringBuf();
		page.add("<html><body>");
		for(imageHTML in imageHTMLs) page.add(imageHTML);
		page.add("</body></html>");
		File.saveContent("Images.html", page.toString());
	}
}