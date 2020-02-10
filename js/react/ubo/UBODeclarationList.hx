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

typedef UBODeclarationListClasses = Classes<[alert]>;

typedef UBODeclarationListPropsWithClasses = {
    >UBODeclarationListProps,
    classes: UBODeclarationListClasses,
};

@:publicProps(UBODeclarationListProps)
@:wrap(Styles.withStyles(styles))
class UBODeclarationList extends ReactComponentOfProps<UBODeclarationListPropsWithClasses> {

    public static function styles(theme:Theme):ClassesDef<UBODeclarationListClasses> {
        return {
            alert: {
                flex: "1"
            }
        }
    }

    public function new(props: UBODeclarationListPropsWithClasses) {
        super(props);
    }

    override public function render() {
        var res = 
            <List dense>
                {props.declarations.map(declaration -> 
                    <ListItem key={declaration.Id}>
                        {renderItem(declaration)}
                    </ListItem>
                )}
            </List>
        ;

        return jsx('$res');
    }

    private function renderItem(declaration: UBODeclarationVO) {
        var dateStr = DateFns.format(
            Date.fromTime(declaration.CreationDate * 1000),
            'EEEE dd MMMM yyyy',
            { locale: DateFnsLocale.fr }
        );
        return switch (declaration.Status) {
            case CREATED: <Alert className=${props.classes.alert} severity="info">aa</Alert>;
            case VALIDATION_ASKED: 
                <Alert className=${props.classes.alert} severity="info">
                    <AlertTitle>Déclaration du {dateStr} en attente de validation.</AlertTitle>
                </Alert>;
            case INCOMPLETE: 
                <Alert className=${props.classes.alert} severity="info">
                    <AlertTitle>Déclaration du {dateStr} incomplète.</AlertTitle>
                    {declaration.Message}<br />
                    Vous pouvez l&rsquo;éditer ci-dessous.
                </Alert>;
            case VALIDATED: 
                <Alert className=${props.classes.alert} severity="success">
                    <AlertTitle>Déclaration du {dateStr} acceptée.</AlertTitle>
                </Alert>;
            case REFUSED: 
                <Alert className=${props.classes.alert} severity="error">
                    <AlertTitle>Déclaration du {dateStr} refusée.</AlertTitle>
                    {parseReason(declaration.Reason)} {declaration.Message}
                </Alert>
            ;
        }
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
}
