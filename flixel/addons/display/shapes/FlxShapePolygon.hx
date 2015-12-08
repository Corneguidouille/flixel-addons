package flixel.addons.display.shapes;

import flash.geom.Matrix;
import flixel.math.FlxPoint;
import flixel.math.FlxPolygon;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxSpriteUtil.LineStyle;

class FlxShapePolygon extends FlxShape 
{
	public var polygon(default, set):FlxPolygon;
	
	/**
	 * Creates a FlxSprite with a polygon drawn on top of it.
	 */
	public function new(Polygon:FlxPolygon, LineStyle_:LineStyle) 
	{
		polygon = Polygon;

		var trueWidth:Float = polygon.right - polygon.left;
		var trueHeight:Float = polygon.bottom - polygon.top;

		super(polygon.left, polygon.top, 0, 0, LineStyle_, FlxColor.TRANSPARENT, trueWidth, trueHeight);
		
		shape_id = FlxShapeType.POLYGON;
	}
	
	override public function drawSpecificShape(?matrix:Matrix):Void 
	{
		FlxSpriteUtil.drawPolygon(this, polygon.points, lineStyle, { matrix: matrix });
	}
	
	private inline function set_polygon(Polygon:FlxPolygon):FlxPolygon
	{
		polygon.copyFrom(Polygon);
		
		shapeWidth = polygon.right - polygon.left;
		shapeHeight = polygon.bottom - polygon.top;
		shapeDirty = true;

		return Polygon;
	}
	
	override public function get_strokeBuffer():Float
	{
		return lineStyle.thickness * 2.0;
	}
	
	private override function getStrokeOffsetX():Float
	{
		return strokeBuffer / 2;
	}
	
	private override function getStrokeOffsetY():Float
	{
		return strokeBuffer / 2;
	}
}