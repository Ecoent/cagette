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
import react.ubo.UBODialogForm;
import react.ubo.UBOListItem;

typedef UBOListProps = {
    ubos: Array<UBOVO>,
    canEdit: Bool,
};

class UBOList extends ReactComponentOfProps<UBOListProps> {

    public function new(props: UBOListProps) {
        super(props);
    }

    override public function render() {
        var res =
            <List dense disablePadding>
                {props.ubos.map(ubo -> <UBOListItem key={ubo.Id} ubo={ubo} canEdit={props.canEdit} />)}
            </List>
        ;

        return jsx('$res');
    }
}