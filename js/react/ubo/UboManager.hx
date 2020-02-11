package react.ubo;

import react.ReactMacro.jsx;
import react.ReactComponent;

import react.ubo.Provider;
import react.ubo.UBOConfig;

class UboManager extends ReactComponent {
    override public function render() {
        var res = 
            <Provider>
                <UBOConfig />
            </Provider>;
        return jsx('$res');
    }
}