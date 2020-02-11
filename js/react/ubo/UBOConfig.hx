package react.ubo;

import react.ReactMacro.jsx;
import react.ReactComponent;
import mui.core.*;
import react.ubo.vo.UBODeclarationVO;
import react.ubo.vo.UBOVO;
import react.ubo.UBODeclarationList;
import react.mui.Box;
import mui.icon.ExpandLess;
import mui.icon.ExpandMore;

typedef UBOConfigProps = {};

typedef UBOConfigState = {
    isLoading: Bool,
    showHistory: Bool,
    ?declarations: Array<UBODeclarationVO>,
}; 

class UBOConfig extends ReactComponentOfPropsAndState<UBOConfigProps, UBOConfigState> {

    public function new(props: UBOConfigProps) {
        super(props);
        state = {
            isLoading: true,
            showHistory: false,
        };
    }

    override function componentDidMount() {
        loadData();
    }

    override public function render() {
        var res = 
            <Card>
                <CardHeader
                    title="Déclaration des bénéficiaires effectifs (UBO)"
                    subheader="Liste des actionnaires détenant plus de 25% de la société"
                    />
                <CardContent>
                    {renderLoader()}
                    {renderDeclarationList()}
                </CardContent>
            </Card>
        ;

        return jsx('$res');
    }

    /**
     * 
    */
    private function renderLoader() {
        if (state.isLoading) {
            return 
                <Box p={4} display="flex" justifyContent="center">
                    <CircularProgress />
                </Box>
            ;
        }
        return <></>;
    }
    
    private function renderDeclarationList() {
        if (state.isLoading) return <></>;
        if (state.declarations == null || state.declarations.length == 0) return <div>No declaration</div>;
        var ds = state.declarations.map(d -> d);
        ds.sort((a, b) ->  a.CreationDate - b.CreationDate);
        var current = ds.pop();
        return
            <>
                <UBODeclarationList declarations=${[current]} displayAction onRefresh=$refresh />
                {renderHistory(ds)}
            </>
        ;
    }

    private function renderHistory(declarations: Array<UBODeclarationVO>) {
        if (declarations.length == 0) return <></>;

        var icon = state.showHistory ? <ExpandLess /> : <ExpandMore />;
        var toggleHistory = () -> setState({ showHistory: !state.showHistory });
        return 
            <>
                <Box m={2} mt={0} display="flex" justifyContent="space-between" alignItems="center">
                    <Typography>Historique des déclarations</Typography>
                    <IconButton onClick={toggleHistory}>{icon}</IconButton>
                </Box>
                <Collapse in={state.showHistory}>
                    <UBODeclarationList declarations=${declarations} displayAction={false} onRefresh=$refresh />
                </Collapse>
            </>
        ;
    }

    private function refresh() {
        var timer = new haxe.Timer(100);
        timer.run = function() {
            loadData();
            timer.stop();
        };
    }

    private function loadData() {
        setState({ isLoading: true, declarations: [] });

        js.Browser.window.fetch("/api/currentgroup/mangopay/kyc/ubodeclarations")
            .then(res -> {
                if (!res.ok) {
                    throw res.statusText;
                }
                return res.json();
            }).then(res -> {
                setState({
                    isLoading: false,
                    declarations: UBODeclarationVO.parseArray(res),
                });
                return true;
            }).catchError(err -> {
                trace(err);
            });
    }
}