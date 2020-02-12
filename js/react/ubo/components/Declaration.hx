package react.ubo.components;

import react.ReactMacro.jsx;
import react.ReactComponent;
import mui.core.styles.Styles;
import mui.core.styles.Classes;
import dateFns.DateFns;
import dateFns.DateFnsLocale;
import mui.TextColor;
import mui.core.*;
import mui.core.button.IconButtonSize;
import mui.core.icon.SvgIconFontSize;
import mui.icon.ExpandLess;
import mui.icon.ExpandMore;
import mui.icon.Edit;
import mui.icon.Visibility;
import mui.icon.Add;
import react.mui.CagetteTheme;
import react.mui.Box;
import react.mui.Alert;
import react.mui.AlertTitle;
import react.ubo.Utils;
import react.ubo.vo.DeclarationVO;
import react.ubo.vo.UboVO;

private typedef Props = {
    declaration: DeclarationVO,
    ?isOld: Bool,
    ?expend: Bool,
    ?onAddClick: () -> Void,
    ?onEditClick: (ubo: UboVO) -> Void,
    ?onViewClick: (ubo: UboVO) -> Void,
};

private typedef ClassessProps = Classes<[alert, alertMessage]>;

private typedef PrivateProps = {
    >Props,
    classes: ClassessProps,
};


private typedef State = {
    listIsCollapsed: Bool,
};

@:publicProps(Props)
@:wrap(Styles.withStyles(styles))
class Declaration extends ReactComponentOfPropsAndState<PrivateProps, State> {

    public static var defaultProps = {
        isOld: false
    }

    public static function styles(theme:Theme):ClassesDef<ClassessProps> {
        return {
            alert: { flex: "1" },
            alertMessage: { width: "100%" }
        }
    }

    public function new(props: PrivateProps) {
        super(props);

        state = {
            listIsCollapsed: props.expend == null ? true : !props.expend,
        };
    }

    override public function render() {
        var declaration = props.declaration;
        var status = declaration.Status;

        var dateStr = DateFns.format(
            Date.fromTime(declaration.CreationDate * 1000),
            'EEEE dd MMMM yyyy',
            { locale: DateFnsLocale.fr }
        );

        var alertAction = Utils.declaration(declaration).canBeExtended() ? renderAlertAction() : <></>;

        var res = 
            <Box>
                <Alert
                    severity={Utils.declaration(declaration).getAlertServerity()}
                    classes={{ message: props.classes.alertMessage }} 
                    className=${props.classes.alert}>
                    <AlertTitle>
                        <Box display="flex" justifyContent="space-between">
                            <Typography>{Utils.declaration(declaration).getAlertTitle(dateStr)}</Typography>
                            {alertAction}
                        </Box>
                    </AlertTitle>
                    <Collapse in={!state.listIsCollapsed}>
                        {renderList()}
                    </Collapse>
                </Alert>
            </Box>
        ;

        return jsx('$res');
    }

    private function renderAlertAction() {
        var icon = state.listIsCollapsed  ? <ExpandMore /> : <ExpandLess />;
        return 
            <IconButton size=${IconButtonSize.Small} onClick=$toggleList>
                {icon}
            </IconButton>;
    }

    private function renderList() {
        var declaration = props.declaration;
        var isOld = props.isOld == null ? false : props.isOld;
        var editable = Utils.declaration(declaration).ubosCanBeEdited() && !isOld;
        var addButton = editable && declaration.Ubos.length < 4 && props.onAddClick != null ? renderAddButton() : <></>;
        
        return
            <Box mt={2} mx={2}>
                {declaration.Ubos.map(ubo -> renderListItem(ubo, editable))}
                {addButton}
            </Box>
        ;
    }

    private function renderListItem(ubo: UboVO, editable: Bool) {
        var formatPrimary = (ubo) -> '${ubo.LastName} ${ubo.FirstName}';
        var formatSecondary = (ubo) -> '${ubo.Address.AddressLine1} - (${ubo.Address.PostalCode}) ${ubo.Address.City} - ${ubo.Address.Country}';
        var icon = editable ? <Edit fontSize={SvgIconFontSize.Small} /> : <Visibility fontSize={SvgIconFontSize.Small} />;
        var callback = () -> { editable ? props.onEditClick(ubo) : props.onViewClick(ubo); };

        return 
            <ListItem key={ubo.Id}>
                <ListItemText
                    primary={formatPrimary(ubo)}
                    secondary={formatSecondary(ubo)} />
                <IconButton onClick=$callback>
                    {icon}
                </IconButton>
            </ListItem>
        ;
    }

    private function renderAddButton() {
        return 
            <ListItem button onClick={props.onAddClick}>
                <Box width="100%" display="flex" justifyContent="center">
                    <Typography color={TextColor.Primary}>Ajouter un bénéficiaire effectif</Typography>
                </Box>
            </ListItem>
        ;
    }

    /**
     * 
     */
    private function toggleList() {
        setState({ listIsCollapsed: !state.listIsCollapsed });
    }
}