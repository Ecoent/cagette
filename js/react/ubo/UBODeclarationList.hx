package react.ubo;

import react.ReactMacro.jsx;
import react.ReactComponent;
import mui.core.styles.Styles;
import mui.core.styles.Classes;
import mui.core.*;
import mui.icon.Close;
import react.ubo.vo.UBODeclarationVO;
import react.mui.CagetteTheme;
import react.mui.Alert;
import react.mui.AlertTitle;
import dateFns.DateFns;
import dateFns.DateFns;
import dateFns.DateFnsLocale;

typedef UBODeclarationListProps = {
    declarations: Array<UBODeclarationVO>
};

typedef UBODeclarationListPropsClasses = Classes<[alert]>;

typedef UBODeclarationListPropsWithClasses = {
    >UBODeclarationListProps,
    classes: UBODeclarationListPropsClasses,
};

typedef UBODeclarationListStateState = {
    ?activeDeclaration: UBODeclarationVO
};

@:publicUBODeclarationListProps(UBODeclarationListProps)
@:wrap(Styles.withStyles(styles))
class UBODeclarationList extends ReactComponentOfPropsAndState<UBODeclarationListPropsWithClasses, UBODeclarationListStateState> {

    public static function styles(theme:Theme):ClassesDef<UBODeclarationListPropsClasses> {
        return {
            alert: {
                flex: "1"
            }
        }
    }

    public function new(props: UBODeclarationListPropsWithClasses) {
        super(props);

        state = {};
    }

    override public function render() {
        var res = 
            <List dense>
                {props.declarations.map(declaration -> 
                    <UBODeclarationListItem
                        key={declaration.Id}
                        declaration={declaration}
                        active={declaration == state.activeDeclaration}
                        onSelect=$onItemSelect
                        />
                )}
            </List>
        ;

        return jsx('$res');
    }

    private function onItemSelect(?declaration: UBODeclarationVO) {
        setState({ activeDeclaration: declaration });
    }
}
