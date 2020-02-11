package react.ubo;

import react.ReactMacro.jsx;
import react.ReactComponent;
import mui.core.*;
import react.ubo.vo.UboVO;
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
import react.ubo.Provider;

typedef UBOListProps = {
    declarationId: Int,
    ubos: Array<UboVO>,
    canEdit: Bool,
    canAdd: Bool,
    onRefresh: () -> Void,
};

private typedef UBOListWrappedProps = {
    >UBOListProps,
    message: String
};

typedef UBOListState = {
    dialogIsOpened: Bool
};


@:publicProps(UBOListProps)
@:wrap(Provider.withUBOContext)
class UBOList extends ReactComponentOfPropsAndState<UBOListWrappedProps, UBOListState> {

    public function new(props: UBOListWrappedProps) {
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