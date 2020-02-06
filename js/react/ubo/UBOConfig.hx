package react.ubo;

import react.ReactMacro.jsx;
import react.ReactComponent;
import react.ubo.UBOPeopleForm;

class UBOConfig extends ReactComponent {

    override public function render() {
        var res = 
            <UBOPeopleForm />
        ;

        return jsx('$res');
    }
}