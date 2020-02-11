package react.ubo;

import react.ReactMacro.jsx;
import react.ReactComponent;
import mui.core.styles.Styles;
import mui.core.styles.Classes;
import mui.core.*;
import mui.core.button.IconButtonEdge;
import mui.core.button.IconButtonSize;
import mui.icon.ExpandLess;
import mui.icon.ExpandMore;
import react.ubo.vo.UBODeclarationVO;
import react.mui.CagetteTheme;
import react.mui.Alert;
import react.mui.AlertTitle;
import react.mui.Box;
import dateFns.DateFns;
import dateFns.DateFns;
import dateFns.DateFnsLocale;
import react.ubo.UBOList;

typedef UBODeclarationListItemProps = {
    declaration: UBODeclarationVO,
    active: Bool,
    onSelect: (?declaration: UBODeclarationVO) -> Void,
};

typedef UBODeclarationListItemPropsClasses = Classes<[alert, alertMessage]>;

typedef UBODeclarationListItemPropsWithClasses = {
    >UBODeclarationListItemProps,
    classes: UBODeclarationListItemPropsClasses,
};

@:publicUBODeclarationListItemProps(UBODeclarationListItemProps)
@:wrap(Styles.withStyles(styles))
class UBODeclarationListItem extends ReactComponentOfProps<UBODeclarationListItemPropsWithClasses> {

    public static function styles(theme:Theme):ClassesDef<UBODeclarationListItemPropsClasses> {
        return {
            alert: {
                flex: "1"
            },
            alertMessage: {
                width: "100%"
            }
        }
    }

    public function new(props: UBODeclarationListItemPropsWithClasses) {
        super(props);
    }

    override public function render() {
        var declaration = props.declaration;
        var dateStr = DateFns.format(
            Date.fromTime(declaration.CreationDate * 1000),
            'EEEE dd MMMM yyyy',
            { locale: DateFnsLocale.fr }
        );

        var listItem = switch (declaration.Status) {
            case CREATED: 
                <ListItem>
                    <Alert className=${props.classes.alert} severity="info">
                        aa
                    </Alert>
                </ListItem>
                ;
            case VALIDATION_ASKED: 
                <ListItem>
                    <Alert className=${props.classes.alert} severity="info">
                        <AlertTitle>Déclaration du {dateStr} en attente de validation.</AlertTitle>
                    </Alert>
                </ListItem>;
            case INCOMPLETE:
                <ListItem>
                    <Alert className=${props.classes.alert} severity="info">
                        <AlertTitle>Déclaration du {dateStr} incomplète.</AlertTitle>
                        {declaration.Message}<br />
                        Vous pouvez l&rsquo;éditer ci-dessous.
                    </Alert>
                </ListItem>;
            case VALIDATED:
                <ListItem>
                    <Alert className=${props.classes.alert} severity="success">
                        <AlertTitle>Déclaration du {dateStr} acceptée.</AlertTitle>
                    </Alert>
                </ListItem>;
            case REFUSED: 
                <ListItem>
                    <Alert
                        className=${props.classes.alert}
                        classes={{ message: props.classes.alertMessage }}
                        severity="error"
                    >
                        <AlertTitle>
                            <Box display="flex" justifyContent="space-between">
                                <Typography>Déclaration du {dateStr} refusée.</Typography>
                                {renderAlertAction()}
                            </Box>
                        </AlertTitle>
                        {parseReason(declaration.Reason)} {declaration.Message}
                        {renderUboList(false)}
                    </Alert>
                </ListItem>
            ;
        };

        return jsx('
            <>
                $listItem
            </>'
        );
    }

    private function parseReason(reason: UBODeclarationVOReason) {
        return switch (reason) {
            case MISSING_UBO: "Ubo manquant.";
            case WRONG_UBO_INFORMATION: "Une information concernant bénéficiaire effectif est erronée.";
            case UBO_IDENTITY_NEEDED: "L'identité d'un bénéficiaire effectif est requise.";
            case SHAREHOLDERS_DECLARATION_NEEDED: "Déclaration des actionnaires requise.";
            case ORGANIZATION_CHART_NEEDED: "Organigramme requis.";
            case DOCUMENTS_NEEDED: "Documents requis.";
            case DECLARATION_DO_NOT_MATCH_UBO_INFORMATION: "La déclaration ne correspond pas avec les informations fournies.";
            case SPECIFIC_CASE: "Cas spécifique.";
        }
    }

    private function renderAlertAction() {
        if (props.active) {
            var onClick = () -> { props.onSelect(); };
            return 
                <IconButton size=${IconButtonSize.Small} onClick=$onClick>
                    <ExpandLess />
                </IconButton>
            ;
        }

        var onClick = () -> { props.onSelect(props.declaration); };
        return 
            <IconButton size=${IconButtonSize.Small} onClick=$onClick>
                <ExpandMore />
            </IconButton>
        ;
    }

    private function renderUboList(canEdit: Bool) {
        if (props.active) {
            return <Box mt={2} mx={2}><UBOList ubos={props.declaration.Ubos} canEdit={canEdit} /></Box>;
        }

        return <></>;
    }
}
