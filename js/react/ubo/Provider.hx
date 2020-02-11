package react.ubo;

import react.ReactMacro.jsx;
import react.ReactComponent;
import react.React;
import react.ubo.Api;
import react.ubo.vo.DeclarationVO;

typedef ProviderProps = {
    children: ReactNode,
};

typedef ProviderState = {
    declarationIsLoading: Bool,
    declarations: Array<DeclarationVO>,
};

private class CtxP {
    public static var UBOContext(default, null) = React.createContext("ubocontext");
}

class Provider extends ReactComponentOfPropsAndState<ProviderProps, ProviderState> {

    public static function withUBOContext<T>(Component: ReactType): ReactType {
        var Wrapper = function(p: Dynamic) {
            var UBOContext = CtxP.UBOContext;

            var createComponent = (s: Dynamic) -> {
                return React.createElement(Component, js.Object.assign(Reflect.copy(p), Reflect.copy(s)));
            };

            return jsx('
                <UBOContext.Consumer>
                    {state -> ${createComponent(state)}}
                </UBOContext.Consumer>
            ');
        }
        return Wrapper;
    }

    public function new(props: ProviderProps) {
        super(props);

        state = {
            declarationIsLoading: false,
            declarations: [],
        };
    }

    override public function render() {
        var UBOContext = CtxP.UBOContext;
        var res = 
            <UBOContext.Provider value={{
                declarationIsLoading: state.declarationIsLoading,
                declarations: state.declarations,
                loadDeclaration: loadDeclaration
            }}>
                {props.children}
            </UBOContext.Provider>
        ;
        return jsx('$res');
    }

    private function loadDeclaration() {
        setState({ declarationIsLoading: true });

        Api.fetchDeclarations()
            .then(res -> {
                setState({
                    declarationIsLoading: false,
                    declarations: DeclarationVO.parseArray(res),
                });
                return true;
            }).catchError(err -> {
                trace(err);
            });
    }
}