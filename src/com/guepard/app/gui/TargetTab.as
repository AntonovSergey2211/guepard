package com.guepard.app.gui
{
	import com.guepard.app.Converter;
	import com.guepard.app.data.Builder;
	import com.guepard.compiler.CodeCompiler;
	import com.guepard.converter.HTMLGenerator;
	import com.guepard.converter.ResourcesConverter;
	import com.guepard.parser.fla.FLAExporter;
	
	import flash.display.MovieClip;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	
	/**
	 * ...
	 * @author Antonov Sergey
	 */
	public class TargetTab extends TabController
	{
		public function get custom():HTML5Design
		{
			return HTML5Design(design);
		}
		
		public function get targetPath():File
		{
			return getFile(custom.html5ProjectPath.text);
		}
		
		public function get targetCodePath():File
		{
			return resolvePath(targetPath, "js");
		}
		
		public function get targetDataPath():File
		{
			return resolvePath(targetPath, "data");
		}
		
		public function get htmlTemplatePath():File
		{
			return getFile(custom.htmlTemplate.text);
		}
		
		public function TargetTab(design:MovieClip)
		{
			super(design);
			
			new BrowseController(custom.html5ProjectPath, custom.html5ProjectPathButton);
			new BrowseController(custom.htmlTemplate, custom.htmlTemplateButton, [new FileFilter("HTML Template (*.html)", "*.html")]);
			
			getDefaults();
		}
		
		override public function addBuilders(builders:Vector.<Builder>):void
		{
			if (custom.enableBuild.selected)
			{
				if (Converter.resources.custom.exportCode.selected)
				{
					var flaPaths:Vector.<File> = Converter.source.flaPaths;
					
					if (flaPaths.length)
					{
						for each(var file:File in flaPaths)
						{
							builders.push(new FLAExporter(file));
						}
					}
					
					if (Converter.source.sourcePaths)
					{
						builders.push(new CodeCompiler());
					}
					
					var name:String = Converter.settings.preloaderTemplatePath.name.replace(".swf", "");
					
					var converter:ResourcesConverter = new ResourcesConverter(
						Converter.settings.preloaderTemplatePath,
						Converter.settings.debugDataPath.resolvePath(name),
						name,
						Converter.target.targetDataPath
					);
					
					builders.push(converter);
					
					builders.push(new HTMLGenerator());
				}
			}
		}
	}
	
}