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

typedef UBOListItemProps = {
    ubo: UBOVO,
    canEdit: Bool,
    onRefresh: () -> Void,
};

typedef UBOListItemState = {
    dialogIsOpened: Bool,
};

class UBOListItem extends ReactComponentOfPropsAndState<UBOListItemProps, UBOListItemState> {

    public function new(props: UBOListItemProps) {
        super(props);

        state = { dialogIsOpened: false };
    }

    override public function render() {
        var res =
            <>
                <ListItem>
                    <ListItemText
                        primary=${formatPrimary()}
                        secondary=${formatSecondary()}
                        />
                    {renderAction()}
                </ListItem>
                {renderDialog()}
            </>
        ;

        return jsx('$res');
    }

    private function formatPrimary() {
        return '${props.ubo.LastName} ${props.ubo.FirstName}';
    }
    private function formatSecondary() {
        return '${props.ubo.Address.AddressLine1} - (${props.ubo.Address.PostalCode}) ${props.ubo.Address.City} - ${props.ubo.Address.Country}';
    }

    private function renderAction() {
        var icon = props.canEdit ? <Edit fontSize={SvgIconFontSize.Small} /> : <Visibility fontSize={SvgIconFontSize.Small} />;
        return 
            <IconButton onClick=$openDialog>
                {icon}
            </IconButton>
        ;
    }

    private function renderDialog() {
        if (!state.dialogIsOpened) return <></>;
        return 
            <UBOFormDialog open ubo={props.ubo} canEdit={props.canEdit} onClose=$onDialogClose />
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