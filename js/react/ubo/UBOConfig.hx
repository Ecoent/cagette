package react.ubo;

import react.ReactMacro.jsx;
import react.ReactComponent;
import mui.core.*;
import react.ubo.vo.DeclarationVO;
import react.ubo.vo.UboVO;
import react.ubo.DeclarationList;
import react.mui.Box;
import mui.icon.ExpandLess;
import mui.icon.ExpandMore;
import react.ubo.Provider;
import react.ubo.DeclarationsHistory;

typedef UBOConfigProps = {};

typedef UBOConfigWrappedProps = {
    >UBOConfigProps,
    declarationIsLoading: Bool,
    declarations: Array<DeclarationVO>,
    loadDeclaration: () -> Void,
};

typedef UBOConfigState = {
    showHistory: Bool,
}; 

@:publicProps(UBOConfigProps)
@:wrap(Provider.withUBOContext)
class UBOConfig extends ReactComponentOfPropsAndState<UBOConfigWrappedProps, UBOConfigState> {

    public function new(props: UBOConfigWrappedProps) {
        super(props);
        state = {
            showHistory: false,
        };
    }

    override function componentDidMount() {
        props.loadDeclaration();
    }

    override public function render() {
        var res = 
            <Card>
                <CardHeader
                    title="Déclaration des bénéficiaires effectifs (UBO)"
                    subheader="Liste des actionnaires détenant plus de 25% de la société"
                    />
                <CardContent>
                    {renderCardContent()}
                </CardContent>
            </Card>
        ;

        return jsx('$res');
    }

    /**
     *
     */
    private function renderCardContent() {
        if (props.declarationIsLoading) {
            return
                <Box p={4} display="flex" justifyContent="center">
                    <CircularProgress />
                </Box>;
        } else if (props.declarations.length == 0) {
            return <div>No declaration</div>; // TODO
        } else {
            var ds = props.declarations.map(d -> d);
            ds.sort((a, b) ->  a.CreationDate - b.CreationDate);
            var current = ds.pop();
            return
                <>
                    <DeclarationList declarations=${[current]} displayAction onRefresh=$refresh />
                    <DeclarationsHistory declarations={ds} />
                </>
            ;
        }
    }

    /**
     * 
    */
    private function refresh() {
        var timer = new haxe.Timer(100);
        timer.run = function() {
            props.loadDeclaration();
            timer.stop();
        };
    }
}