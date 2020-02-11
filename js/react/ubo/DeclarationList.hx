package react.ubo;

import react.ReactMacro.jsx;
import react.ReactComponent;
import mui.core.styles.Styles;
import mui.core.styles.Classes;
import mui.core.*;
import mui.icon.Close;
import react.ubo.vo.DeclarationVO;
import react.mui.CagetteTheme;
import react.mui.Alert;
import react.mui.AlertTitle;
import dateFns.DateFns;
import dateFns.DateFns;
import dateFns.DateFnsLocale;

private typedef Props = {
    declarations: Array<DeclarationVO>,
    displayAction: Bool,
    onRefresh: () -> Void,
};

private typedef ClassesProps = Classes<[alert]>;

private typedef PrivateProps = {
    >Props,
    classes: ClassesProps,
};

typedef DeclarationListStateState = {
    ?activeDeclaration: DeclarationVO
};

@:publicProps(Props)
@:wrap(Styles.withStyles(styles))
class DeclarationList extends ReactComponentOfPropsAndState<PrivateProps, DeclarationListStateState> {

    public static function styles(theme:Theme):ClassesDef<ClassesProps> {
        return {
            alert: {
                flex: "1"
            }
        }
    }

    public function new(props: PrivateProps) {
        super(props);

        state = {};
    }

    override public function render() {
        var res = 
            <List dense>
                {props.declarations.map(declaration -> 
                    <DeclarationListItem
                        key={declaration.Id}
                        declaration={declaration}
                        displayAction=${props.displayAction}
                        active={declaration == state.activeDeclaration}
                        onSelect=$onItemSelect
                        onRefresh=${props.onRefresh}
                        />
                )}
            </List>
        ;

        return jsx('$res');
    }

    private function onItemSelect(?declaration: DeclarationVO) {
        setState({ activeDeclaration: declaration });
    }
}
