package react.ubo;

import react.ReactMacro.jsx;
import react.ReactComponent;
import react.mui.Box;
import mui.core.*;
import mui.icon.ExpandLess;
import mui.icon.ExpandMore;
import react.ubo.vo.DeclarationVO;
import react.ubo.DeclarationList;

private typedef Props = {
    declarations: Array<DeclarationVO>,
}

private typedef State = {
    isCollapsed: Bool,
}

class DeclarationsHistory extends ReactComponentOfPropsAndState<Props, State> {

    public function new(props: Props) {
        super(props);

        state = {
            isCollapsed: true,
        }
    }

    override public function render() {
        var res;

        if (props.declarations.length == 0) res = <></>;

        var icon = state.isCollapsed ? <ExpandMore /> : <ExpandLess />;
        return 
            <>
                <Box m={2} mt={0} display="flex" justifyContent="space-between" alignItems="center">
                    <Typography>Historique des déclarations</Typography>
                    <IconButton onClick={toggleHistory}>{icon}</IconButton>
                </Box>
                <Collapse in={!state.isCollapsed}>
                    <DeclarationList declarations=${props.declarations} displayAction={false} onRefresh=$refresh />
                </Collapse>
            </>
        ;

        return jsx('$res');
    }

    /**
     * 
     */
    private function toggleHistory() {
        setState({ isCollapsed: !state.isCollapsed });
    }

    private function refresh() {}

}