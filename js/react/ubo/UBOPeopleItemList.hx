package react.ubo;

import react.ReactMacro.jsx;
import react.ReactComponent;
import mui.core.*;
import mui.core.button.IconButtonSize;
import mui.core.button.IconButtonEdge;
import mui.core.icon.SvgIconFontSize;
import mui.icon.Edit;
import react.ubo.vo.UBOVO;

typedef UBOPeopleItemListProps = {
    people: UBOVO,
    onEdit: (people: UBOVO) -> Void,
};

class UBOPeopleItemList extends ReactComponentOfProps<UBOPeopleItemListProps> {
    public function new(props: UBOPeopleItemListProps) {
        super(props);
    }

    override public function render() {
        var res = 
            <ListItem>
                <ListItemText
                    primary=${formatPrimary()}
                    secondary=${formatSecondary()}
                    />
                <ListItemSecondaryAction>
                    <IconButton
                        size={IconButtonSize.Small}
                        edge={IconButtonEdge.End}
                        aria-label="edit"
                        onClick=$onEditClick
                        >
                        <Edit fontSize={SvgIconFontSize.Small} />
                    </IconButton>
                </ListItemSecondaryAction>
            </ListItem>
        ;
        return jsx('$res');
    }

    private function onEditClick() {
        props.onEdit(props.people);
    }

    private function formatPrimary() {
        return '${props.people.LastName} ${props.people.FirstName}';
    }
    private function formatSecondary() {
        return '${props.people.Address.AddressLine1} - (${props.people.Address.PostalCode}) ${props.people.Address.City} - ${props.people.Address.Country}';
    }
}