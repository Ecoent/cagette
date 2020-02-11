package react.ubo;

import react.ReactMacro.jsx;
import react.ReactComponent;
import mui.core.*;
import react.ubo.vo.UBOVO;
import mui.core.button.IconButtonSize;
import mui.core.button.IconButtonEdge;
import mui.core.icon.SvgIconFontSize;
import mui.icon.Edit;
import mui.icon.Visibility;
import react.ubo.UBOFormDialog;
import react.ubo.UBOListItem;
import react.mui.Box;
import mui.core.button.ButtonVariant;
import mui.core.button.ButtonSize;

typedef UBOListProps = {
    declarationId: Int,
    ubos: Array<UBOVO>,
    canEdit: Bool,
    canAdd: Bool,
    onRefresh: () -> Void,
};

typedef UBOListState = {
    dialogIsOpened: Bool
};

class UBOList extends ReactComponentOfPropsAndState<UBOListProps, UBOListState> {

    public function new(props: UBOListProps) {
        super(props);

        state = {
            dialogIsOpened: false
        };
    }

    override public function render() {
        var res =
            <>
                <List dense disablePadding>
                    {props.ubos.map(ubo -> <UBOListItem key={ubo.Id} ubo={ubo} canEdit={props.canEdit} onRefresh=${props.onRefresh} declarationId={props.declarationId} />)}
                </List>
                {renderAddButton()}
                {renderDialog()}
            </>
        ;

        return jsx('$res');
    }

    private function renderAddButton() {
        if (!props.canAdd) return <></>;
        return 
            <Box display="flex" justifyContent="center" my={2}>
                <Button
                    size={ButtonSize.Small}
                    variant={ButtonVariant.Outlined}
                    color={mui.Color.Primary}
                    onClick=$openDialog>
                    Ajouter un bénéficiaire effectif
                </Button>
            </Box>
        ;
    }

    private function renderDialog() {
        if (!state.dialogIsOpened) return <></>;
        return 
            <UBOFormDialog open canEdit onClose=$onDialogClose declarationId={props.declarationId} />
        ;
    }

    private function openDialog() {
        setState({ dialogIsOpened: true });
    }

    private function onDialogClose(refresh: Bool) {
        if (refresh) props.onRefresh();
        setState({ dialogIsOpened: false });
    }
}