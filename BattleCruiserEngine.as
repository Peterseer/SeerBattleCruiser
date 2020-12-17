package
{
	import fl.data.DataProvider;
	import fl.controls.*;
	import fl.core.*;
	import fl.containers.*;
	import fl.controls.listClasses.*;
	import fl.controls.dataGridClasses.*;
	import fl.controls.progressBarClasses.*;
	import fl.core.UIComponent;
	import fl.events.DataChangeEvent;

	public class BattleCruiserEngine
	{
		
		internal var EngineVersion:String = "0.0.1"; //战巡舰引擎版本名称
		internal var EngineVersionInt:int = 1; //战巡舰引擎数字版本
		var DataResource:Array = ["精灵数据|quick_search|xml|true|0|202010151214","技能数据|skill_list|xml|true|0|202010151448","技能对应|skillCompar|json|true|0|202010151040","属性|elemType|xml|true|0|202010240355","职责|petDuty|xml|true|0|202009161812","状态|State|xml|false|0|202009302137","技能效果|SkillEffectDes|xml|false|0"]; //这里是各种加载数据的，格式：名称|文件名|类型|预先加载|加载需要(0无要求 1必须加载 2需要联机检查最新版)|日期(可选)
		

		public function BattleCruiserEngine() //战巡舰引擎系统
		{
			// constructor code
			/*
			赛尔号 战列巡航舰 V0.0.1
			!!文件保存功能在Main里，这里不支持！
			
			DataProviderFilterForPetXML 根据xml和搜索关键词，过滤最后导出DataProvider
			XMLFilterConstructor xml重新生成
			searchPetName 搜索精灵
			SkillEffectSlicer 技能效果自动翻译功能
			FontStyleAuto 字体快速设置
			
			测试功能请在Banshee女妖中测试
			*/
			super();
		}
		
		
		public function findItemIndex(element: ComboBox, dataString: String): int
		{
			var index: int = 0;
			for (var i = 0; i < element.length; i++)
			{
				if (element.getItemAt(i).data.toString() == dataString)
				{
					index = i;
					break;
				}
				else
				{}
			}
			return index;
		}
		
		
		public function DataProviderFilterForPetXML(xml:XML,arg:*):DataProvider
		{
			var dp:DataProvider = new DataProvider();
			if(xml)
			{
				trace("xml正常")
				var len:int = xml.children().length();
				for(var i:int=0;i<len-1;i++)
				{
					if(String(xml.children()[i].name).indexOf(arg) >= 0)
					{
						trace(xml.children()[i].name)
						dp.addItem(
						{
							petname: String(i + 1) + ":"+String(xml.children()[i].name),
							data: String(i) + "|" + String(xml.children()[i].id)
						});
					}
				}
				return dp;
			}
			return null;
		}
		
		public function DataProviderFilterForSkillXML(xml:XML,arg:*):DataProvider
		{
			var dp:DataProvider = new DataProvider();
			if(xml)
			{
				var len:int = xml.children().length();
				for(var i:int=0;i<len-1;i++)
				{
					if(String(xml.children()[i].name).indexOf(arg) >= 0)
					{
						trace(xml.children()[i].name)
						dp.addItem(
						{
							skillname: String(i + 1) + ":"+String(xml.children()[i].name),
							data: String(i) + "|" + String(xml.children()[i].id)
						});
					}
				}
				return dp;
			}
			return null;
		}

		public function XMLFilterConstructor(xml: XML, arg: *): XML
		{
			var retXML:XML = new XML();
			retXML = <root></root>;
			var len: int = xml.children().length();

			for (var i: int = 0; i < len; i++)
			{
				if (xml.children()[i].name == arg)
				{
					trace(xml.children()[i].name);
					retXML.insertChildAfter(retXML,xml.children()[i]);
				}
			}
			trace(retXML);
			return retXML;
		}
		
		
		function searchPetName(xml: XML, arg: String): XML
		{
			var len: int = xml.pet.length();

			for (var i: int = 0; i < len; i++)
			{
				if (xml.pet[i].name == arg)
				{
					return XML(xml.pet[i]);
				}
			}

			for (i = 0; i < len; i++)
			{
				if (xml.pet[i].pet.length() > 1)
				{
					var newXML: XML = searchPetName(XML(xml.pet[i]), arg);
					if (newXML == null)
					{
						continue;
					}
					else
					{
						return newXML;
					}
				}
			}

			return null;
		}
//字体设置
		function FontStyleAuto(ft:*,sizemode:String):void
		{
			if(sizemode=="font")
			{
				ft.size = 17;
				ft.bold = true;
			}
			else if(sizemode=="button")
			{
				ft.size = 15;
				ft.bold = false;
			}
			ft.italic = false;
			ft.underline = false;
			ft.align = "left";
			ft.font = "汉仪中圆简";
		}
		
//技能效果反编译
		
		function SkillEffectSlicer(wholetxt:String):Array
		{
			//分割多组效果
			var combinedArr:Array = wholetxt.split("]*[");
			var slicedlen:int = combinedArr.length;
			var groupArr:Array = [];
			for(var i:int=0;i<slicedlen;i++)
			{
				combinedArr[i] = removeCharacters_Complex(combinedArr[i]);
				var splitarr:Array = String(combinedArr[i]).split(",");
				groupArr[i] = splitarr;
				
			}
			trace("全组效果："+groupArr)
			return groupArr;
			
		}
		
		function SkillEffectAnalyzer(arg:String):void
		{
			var skillform:Array = arg.split(",");
			//skillform[0]是判定条件，skillform[1]是效果
			//注意！效果不能用*叠加使用，必须分开成不同组效果
			skillform[0] = SkillEffectMultiCheck(String(skillform[0]));
			
		}
		
		function SkillEffectMultiCheck(arg:String):Array
		{
			var retr:Array = arg.split("*");
			return retr;
		}
		
		function removeCharacters_Complex(str:String):String
		{
			var noLines:String = str.replace("[", "" );
			trace("清理完毕:"+noLines)
			return noLines;
		}
		
		function SkillEffectJudgeReplacer(des:String, arr:Array):void
		{
			
		}
		
		function SkillEffectDescriptionReplacer(des:String, arr:Array):void
		{
			
		}

	}

}