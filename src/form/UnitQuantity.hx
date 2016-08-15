package form;
import Common;
/**
 * ...
 * @author fbarbut
 */
class UnitQuantity extends sugoi.form.elements.FloatInput
{

	var unit : UnitType;
	
	public function new(name, label, value, ?required=false,unit){
		super(name, label, value, required);
		
		this.unit = unit;
	}
	
	override function render(){
		
		var r = super.render();
		
		return '
					<div class="input-group">
						'+r+'
						<div class="input-group-addon">'+App.current.view.unit(unit)+'</div>
					</div>
				';
		
		
	}
	
}